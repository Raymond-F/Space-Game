// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// Setup the actual combat manager object
function combat_setup() {
	if(!instance_exists(o_combat_manager)) {
		instance_create(0,0, o_combat_manager);
		close_inventory();
	}
}

function combat_create_ship(info, is_player) {
	var yy = VIEW_HEIGHT/2;
	if(is_player) {
		var xx = VIEW_WIDTH/4;
	}
	else {
		var xx = VIEW_WIDTH*3/4;
	}
	var sh = instance_create(xx, yy, o_ship);
	
	var parse_arrays_for_best_module_of_type = function(_info, type) {
		//go down the module list from highest class to lowest class
		for(var i = 0; i < array_length(_info.class6); i++) {
			var m = global.itemlist_modules[? _info.class6[i]];
			if(m.type == type) {
				return m;
			}
		}
		for(var i = 0; i < array_length(_info.class5); i++) {
			var m = global.itemlist_modules[? _info.class5[i]];
			if(m.type == type) {
				return m;
			}
		}
		for(var i = 0; i < array_length(_info.class4); i++) {
			var m = global.itemlist_modules[? _info.class4[i]];
			if(m.type == type) {
				return m;
			}
		}
		for(var i = 0; i < array_length(_info.class3); i++) {
			var m = global.itemlist_modules[? _info.class3[i]];
			if(m.type == type) {
				return m;
			}
		}
		for(var i = 0; i < array_length(_info.class2); i++) {
			var m = global.itemlist_modules[? _info.class2[i]];
			if(m.type == type) {
				return m;
			}
		}
		for(var i = 0; i < array_length(_info.class1); i++) {
			var m = global.itemlist_modules[? _info.class1[i]];
			if(m.type == type) {
				return m;
			}
		}
		return noone;
	}
	
	var drive = parse_arrays_for_best_module_of_type(info, MODULETYPE_DRIVE);
	var wepsys = parse_arrays_for_best_module_of_type(info, MODULETYPE_WEPSYS);
	var shield = parse_arrays_for_best_module_of_type(info, MODULETYPE_SHIELD);
	
	with (sh) {
		info_id = info.info_id;
		name = info.name;
		sprite_index = info.sprite;
		hardpoints = [];
		for(var i = 0; i < array_length(info.hardpoints); i++) {
			if(info.hardpoint_objects[i] != noone) {
				var hardpoint_coords = info.hardpoints[i];
				var wep_struct = global.itemlist_weapons[? info.hardpoint_objects[i]];
				hardpoints[i] = instance_create(x + hardpoint_coords[0], y + hardpoint_coords[1], wep_struct.index);
				hardpoints[i].par = sh;
				if(!is_player) {
					hardpoints[i].image_angle += 180;
				}
			}
			else {
				hardpoints[i] = noone;
			}
		}
		engines = info.engines;
		hull_max = info.statistics.hull;
		hull_current = hull_max;
		base_armor = info.statistics.armor;
		base_evasion = drive.stats.maneuvering - info.statistics.evasion_penalty;
		if(shield != noone) {
			shield_max = shield.stats.capacity;
			shield_recharge = shield.stats.recharge;
			shield_stability_base = shield.stats.stability;
		}
		else {
			shield_max = 0;
			shield_recharge = 0;
			shield_stability_base = 0;
		}
		shield_current = shield_max;
		if(wepsys != noone) {
			processing_max = wepsys.stats.processing;
			weapon_charge_multiplier = wepsys.stats.speed_mod;
			base_accuracy_bonus = wepsys.stats.accuracy;
		}
		else {
			processing_max = 0;
			weapon_charge_multiplier = 0;
			base_accuracy_bonus = 0;
		}
	}
	return sh;
}

function select_target_point_on_ship(target_ship) {
	var xx, yy;
	do {
		xx = irandom_range(target_ship.bbox_left, target_ship.bbox_right);
		yy = irandom_range(target_ship.bbox_top, target_ship.bbox_bottom);
	} until (collision_point(xx, yy, target_ship, true, false));
	return [xx, yy];
}

function create_projectile_with_target(target_ship, target_point, wep){
	var pspr = wep.projectile_sprite;
	var pobj = wep.projectile_object;
	var spread = wep.projectile_spread;
	var xx, yy;
	do {
		xx = target_point[0] + irandom_range(-spread, spread);
		yy = target_point[1] + irandom_range(-spread, spread);
	} until (collision_point(xx, yy, target_ship, true, false));
	var proj = instance_create(wep.x + lengthdir_x(wep.barrel_length, wep.image_angle),
			   wep.y + lengthdir_y(wep.barrel_length, wep.image_angle), pobj);
	proj.sprite_index = pspr;
	proj.image_angle = point_direction(proj.x, proj.y, xx, yy);
	proj.depth = wep.depth + 1;
	proj.par = wep.par;
	proj.target = target_ship;
	proj.tx = xx;
	proj.ty = yy;
	return proj;
}

function get_angle_with_smallest_difference(start, target) {
	start %= 360;
	target %= 360;
	var baseline = abs(start-target);
	if (abs(start - target - 360) < baseline) {
		return target + 360;
	} else if (abs(start - target + 360) < baseline) {
		return target - 360;
	} else {
		return target;
	}
	return min(abs(start - target), abs(start - target - 360), abs(start - target + 360));
}

// Damage a shield.
function damage_shield(proj, shield) {
	var damage_to_shield = proj.damage * proj.shield_damage_multiplier - shield.par.shield_stability_base;
	shield.par.shield_current = max(shield.par.shield_current - damage_to_shield, 0);
	if (proj.type == weapon_type.projectile || proj.type == weapon_type.plasma) {
		ds_list_add(shield.hit_flares, [proj.x, proj.y, power(damage_to_shield, 0.66)]);
	} else {
		var hit = collision_line_nearest_point(proj.x, proj.y, proj.tx, proj.ty, proj.target.shield_object, true, false);
		ds_list_add(shield.hit_flares, [hit[1], hit[2], power(damage_to_shield, 0.66)]);
	}
}

// Damage the hull of a ship
function damage_hull(proj, target) {
	var damage_to_hull = proj.damage * proj.hull_damage_multiplier - target.base_armor;
	target.hull_current = max(target.hull_current - damage_to_hull, 0);
}