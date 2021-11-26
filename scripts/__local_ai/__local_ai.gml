// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// Most functions here are assumed to be run from the zonemap controller.

// Generate a ship appropriate to the area.
function ai_generate_ship(_x, _y, faction) {
	var threat_level = 0; // Scales inversely with security for pirates, and directly for non-civilians
	var z = zone_get_current();
	if (faction == factions.pirate) {
		threat_level = zone_security.high - z.security;
	} else if (faction == factions.civilian) {
		threat_level = 0;
	} else {
		threat_level = z.security;
	}
	// TODO: Integrate new ships as they come in
	var suffix = "";
	var prefix = "";
	switch (threat_level) {
		case 0: suffix = "veryeasy"; break;
		case 1: suffix = "easy"; break;
		case 2: suffix = "medium"; break;
		case 3: suffix = "hard"; break;
		case 4: suffix = "veryhard"; break;
	}
	switch (faction) {
		default: prefix = "pirate"; break;
	}
	var fn = prefix + "_" + suffix;
	
	var struct = load_ship_from_file(fn);
	if (struct == noone) {
		show_debug_message("ERROR: Could not parse ship from file: " + fn);
		struct = load_default_ship();
	}
	var new_ship = instance_create(_x, _y, o_ship_zonemap);
	new_ship.ship_struct = struct;
	new_ship.faction = faction;
	new_ship.jump_range = ship_get_jumprange(struct);
	new_ship.combat_power = ai_local_calculate_power(new_ship);
	
	return new_ship;
}

// Calculate power for a given ship. Power is used to determine relative strength of ships for chase or
// flee decisions.
function ai_local_calculate_power(sh){
	var struct;
	if (sh.object_index == o_player) {
		struct = global.player_ship;
	} else {
		struct = sh.ship_struct;
	}
	// TODO: More robust power calculation
	var pwr;
	pwr = struct.class * 100;
	pwr += array_length(struct.hardpoints)*20;
	if (sh.faction == factions.civilian) {
		pwr *= 0.5;
	}
	return pwr;
}

// These two functions obtain the nearest and farthest hex from a given target, respectively.
// The former is used for pathing to things, while the latter is generally for fleeing.
// This can result in pathing to another ship's tile only if that ship is a target.
// Note that `target` will be the target hex containing whatever object this is moving to, if the target isn't the hex itself.
function ai_ship_get_nearest_hex_to_target(sh, target) {
	var nearest = sh.hex;
	var nearest_dist = point_distance(nearest.x, nearest.y, target.x, target.y);
	var target_hex;
	if (target.object_index == o_zonemap_hex) {
		target_hex = target;
	} else {
		target_hex = target.hex;
	}
	target = target_hex;
	for (var i = 0; i < array_length(sh.pathable_hexes); i++) {
		var h = sh.pathable_hexes[i];
		var hex_ship = h.contained_ship;
		if (hex_ship != noone) {
			if (h != target) {
				continue;
			} else {
				if (sh.behavior == behaviors.patrol) {
					continue;
				}
			}
		}
		var h_dist = point_distance(h.x, h.y, target.x, target.y);
		if (nearest == sh.hex || h_dist < nearest_dist) {
			nearest = h;
			nearest_dist = h_dist;
		}
	}
	return nearest;
}

function ai_ship_get_farthest_hex_from_target(sh, target) {
	var farthest = sh.hex;
	var farthest_dist = point_distance(farthest.x, farthest.y, target.x, target.y);
	for (var i = 0; i < array_length(sh.pathable_hexes); i++) {
		var h = sh.pathable_hexes[i];
		var hex_ship = h.contained_ship;
		if (hex_ship != noone) {
			continue;
		}
		var h_dist = point_distance(h.x, h.y, target.x, target.y);
		if (h_dist > farthest_dist) {
			farthest = h;
			farthest_dist = h_dist;
		}
	}
	return farthest;
}

// Get visible ships. This does not return ships which are marked as inactive,
// i.e. those which are entering a destination
function ai_ship_get_ships_in_vision(sh) {
	var ships = [];
	for (var i = 0; i < array_length(sh.visible_hexes); i++) {
		var hex = sh.visible_hexes[i];
		if (hex.contained_ship != noone && hex.contained_ship.active) {
			array_push(ships, hex.contained_ship);
		}
	}
	return ships;
}

// Find the first enemy or the player in vision, if any
function ai_ship_get_seen_enemy_or_player(sh) {
	var visible_ships = ai_ship_get_ships_in_vision(sh);
	// Scan for enemies
	var enemy_or_player = noone;
	for (var i = 0; i < array_length(visible_ships); i++) {
		var seen_ship = visible_ships[i];
		if (factions_are_enemies(seen_ship.faction, sh.faction)) {
			enemy_or_player = seen_ship;
			break;
		}
	}
	if (enemy_or_player != noone) {
		return enemy_or_player;
	}
	for (var i = 0; i < array_length(visible_ships); i++) {
		var seen_ship = visible_ships[i];
		if (seen_ship == global.player) {
			return global.player;
		}
	}
	return noone;
}

enum alert_types {
	chase,
	flee,
	investigate
}
// Create an alert bubble for a ship.
function ai_ship_create_alert(sh, type) {
	if (!sh.hex.vision) {
		return noone;
	}
	var alert = instance_create(sh.x + 16, sh.y - 16, o_zonemap_alert);
	var spr;
	switch (type) {
		case alert_types.chase: spr = s_zonemap_icon_chase; break;
		case alert_types.flee: spr = s_zonemap_icon_flee; break;
		case alert_types.investigate: spr = s_zonemap_icon_investigate; break;
		default: spr = s_zonemap_icon_chase; break;
	}
	alert.sprite_index = spr;
	alert.depth = sh.depth - 10;
	return alert;
}

// Determine what behavior to apply to a seen ship
// `secondary` determines if this is in response to another response check.
// Generally, if a ship sees it is being chased it will flee or sometimes chase back and engage.
// This can only happen if it can see the target though.
function ai_ship_get_response(sh, targ, secondary = false) {
	if (factions_are_enemies(sh.faction, targ.faction)) {
		var my_power = ai_local_calculate_power(sh);
		var their_power = ai_local_calculate_power(targ);
		var power_dif = my_power - their_power;
		var power_ratio = power_dif / my_power;
		if (true || power_ratio > -0.1 && sh.behavior == behaviors.patrol) {
			sh.behavior = behaviors.chase;
			sh.target = targ;
			sh.target_last_seen = targ;
			ai_ship_create_alert(sh, alert_types.chase);
		} else if (power_ratio > -0.1 && sh.behavior == behaviors.travel) {
			// Do not alter course
		} else {
			sh.behavior = behaviors.flee;
			sh.target = targ;
			sh.target_last_seen = targ;
			ai_ship_create_alert(sh, alert_types.flee);
		}
		if (!secondary) {
			var visible_to_target = ai_ship_get_ships_in_vision(targ);
			if (targ != global.player && targ.behavior != behaviors.chase &&
			    targ.behavior != behaviors.flee && array_contains(visible_to_target, sh)) {
				ai_ship_get_response(targ, sh, true);
			}
		}
	} else if (sh.behavior == behaviors.patrol &&
			   global.current_turn - global.last_player_scan >= global.player_scan_cooldown &&
			   random(1) < 0.1) { // Ship is the player, determine if we should scan
		sh.behavior = behaviors.chase;
		sh.target = global.player;
		sh.target_last_seen = global.player.hex;
		ai_ship_create_alert(sh, alert_types.investigate);
	}
}

// Step through the ship list
function ai_ship_get_turn_order(priority) {
	var order = [];
	for (var i = 0; i < array_length(priority); i++) {
		var fac = priority[i];
		for (var j = 0; j < ds_list_size(global.ship_registry); j++) {
			var sh = global.ship_registry[| j];
			if (sh.faction == fac) {
				array_push(order, sh);
			}
		}
	}
	// Order now holds all registered ships.
	return order;
}

function ai_ship_behavior_default(sh) {
	if (sh.default_behavior == behaviors.patrol) {
		with(sh) {
			ai_ship_patrol_choose_new();
		}
	} else if (sh.default_behavior == behaviors.travel) {
		with(sh) {
			ai_ship_travel_restart();
		}
	}
	sh.behavior = sh.default_behavior;
}

function ai_create_ship_patrol(faction, center_hex, radius) {
	var sh = ai_generate_ship(center_hex.x, center_hex.y, faction);
	sh.patrol_center = center_hex;
	sh.patrol_radius = radius;
	with(sh) {
		ai_ship_patrol_choose_new();
	}
	sh.default_behavior = behaviors.patrol;
	sh.behavior = behaviors.patrol;
	ship_update(sh);
	return sh;
}

function ai_create_ship_travel(faction, start_hex, end_hex) {
	var sh = ai_generate_ship(start_hex.x, start_hex.y, faction);
	sh.final_destination = end_hex;
	sh.default_behavior = behaviors.travel;
	sh.behavior = behaviors.travel;
	ship_update(sh);
	return sh;
}

function ai_ship_fight(other_ship) {
	var winner, loser;
	if (ship_determine_win(other_ship)) {
		winner = id;
		loser = other_ship;
	} else {
		winner = other_ship;
		loser = id;
	}
	if (hex.vision) {
		var subroutine = instance_create(hex.x, hex.y, o_sr_shipfight);
		subroutine.winner = winner;
		subroutine.loser = loser;
	} else { // No need to do animation if the ships aren't in vision
		ship_destroy_zonemap(loser);
	}
}

// Determine if the calling ship wins in a fight using combat power and some rng for spice.
// NOTE: This must be called from the attacking ship.
function ship_determine_win(other_ship) {
	var my_power = ai_local_calculate_power(id) * random_range(0.9, 1.1);
	var their_power = ai_local_calculate_power(other_ship) * random_range(0.9, 1.1);
	return my_power >= their_power;
}

function ship_is_in_vision(sh, targ) {
	return array_contains(ai_ship_get_ships_in_vision(sh), targ);
}