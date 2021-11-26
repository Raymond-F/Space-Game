/// @description Insert description here
// You can write your code in this editor
function ai_weapon_projectile_default() {
	if(!setup) {
		setup = true;
		shots_remaining = max_shots;
		cooldown_remaining = 0;
		firing = false;
		windup_remaining = windup_max;
		target = [0,0];
		target_angle = 0;
	}
	if(charge == charge_max && (fire || autofire)) {
		fire = false;
		charge = 0;
		firing = true;
		target = select_target_point_on_ship(par.opponent);
		target_angle =  get_angle_with_smallest_difference(image_angle, point_direction(x, y, target[0], target[1]));
		windup_remaining = windup_max;
		shots_remaining = max_shots;
		if (sound_windup != noone) {
			audio_play_sound(sound_windup, 11, false);
		}
	}
	if(firing) {
		if(windup_remaining > 0) {
			windup_remaining--;
			image_angle = lerp(image_angle, target_angle, 0.3);
		} else {
			if(cooldown_remaining == 0) {
				cooldown_remaining = cooldown_max;
				var proj = create_projectile_with_target(par.opponent, target, id);
				proj.damage = damage;
				proj.shield_damage_multiplier = shield_damage_multiplier;
				proj.hull_damage_multiplier = hull_damage_multiplier;
				proj.armor_penetration = armor_penetration;
				proj.spd = projectile_speed;
				proj.image_xscale = projectile_xscale;
				proj.image_yscale = projectile_yscale;
				proj.color = projectile_color;
				shots_remaining--;
				var flash = instance_create(proj.x, proj.y, o_muzzleflash);
				flash.par = id;
				flash.scale = flash_scale;
				flash.image_angle = image_angle + random_range(-10,10);
				// Audio
				if (array_length(sound_fire) > 0) {
					var snd = array_choose(sound_fire);
					if (!sound_fire_loops || sound_fire_id == noone) {
						sound_fire_id = audio_play_sound(snd, 10, sound_fire_loops);
					}
				}
			}
			if(shots_remaining > 0) {
				cooldown_remaining--;
			} else {
				if (sound_fire_loops) {
					audio_stop_sound(sound_fire_id);
					sound_fire_id = noone;
				}
				if (sound_stopfire != noone) {
					audio_play_sound(sound_stopfire, 10, false);
				}
				firing = false;
				image_angle %= 360;
			}
		}
	}
}

function ai_weapon_beam_default() {
	if(!setup) {
		setup = true;
		shots_remaining = max_shots;
		cooldown_remaining = 0;
		firing = false;
		windup_remaining = windup_max;
		target = [0,0];
		target_angle = 0;
		proj = noone;
	}
	if(charge == charge_max && (fire || autofire)) {
		fire = false;
		charge = 0;
		firing = true;
		target = select_target_point_on_ship(par.opponent);
		target_angle =  get_angle_with_smallest_difference(image_angle, point_direction(x, y, target[0], target[1]));
		windup_remaining = windup_max;
		shots_remaining = max_shots;
		
		if (sound_windup != noone) {
			audio_play_sound(sound_windup, 12, false);
		}
	}
	if(firing) {
		if(windup_remaining > 0) {
			windup_remaining--;
			image_angle = lerp(image_angle, target_angle, 0.3);
		} else {
			if (proj == noone) {
				proj = instance_create(x + lengthdir_x(barrel_length, image_angle), y + lengthdir_y(barrel_length, image_angle), projectile_object);
				proj.tx = target[0];
				proj.ty = target[1];
				proj.target = par.opponent;
				var drift_target = select_target_point_on_ship(par.opponent);
				proj.endx = drift_target[0];
				proj.endy = drift_target[1];
				proj.damage = damage;
				proj.shield_damage_multiplier = shield_damage_multiplier;
				proj.hull_damage_multiplier = hull_damage_multiplier;
				proj.armor_penetration = armor_penetration;
				proj.par = par;
				proj.depth = depth - 1;
				
				if (array_length(sound_fire) > 0) {
					sound_fire_id = audio_play_sound(array_choose(sound_fire), 10, sound_fire_loops);
				}
			}
			if(instance_exists(proj)) {
				image_angle = point_direction(x, y, proj.tx, proj.ty);
				proj.x = x + lengthdir_x(barrel_length, image_angle);
				proj.y = y + lengthdir_y(barrel_length, image_angle);
			} else {
				proj = noone;
				firing = false;
				if (sound_fire_loops && sound_fire_id != noone) {
					audio_stop_sound(sound_fire_id);
					sound_fire_id = noone;
				}
				if (sound_stopfire != noone) {
					audio_play_sound(sound_stopfire, 10, false);
				}
			}
		}
	}
}

enum weapon_type {
	projectile,
	blaster,
	beam,
	plasma
}

ai = noone;
par = noone; //parent ship
type = weapon_type.projectile;
charge = 0;
charge_max = 999;
weapon_id = 0;
projectile_sprite = noone;
projectile_xscale = 1;
projectile_yscale = 1;
projectile_object = noone;
projectile_color = [0.9, 0.9, 0];
projectile_spread = 0;
barrel_length = 0;
setup = false;
name = "";
rel_x = 0;
rel_y = 0;
init = false;

autofire = false; //Whether this weapon will repeatedly fire every time available
fire = false; //Whether to fire when available next
spread = 0; //Radius of spread from a target point

hud = instance_create(0, 0, o_weapon_hud)
hud.wep = id;

sound_fire = []; // An array of different shot sounds. One is chosen at random each attack.
sound_fire_loops = false; // Whether the firing sound effect is a loop.
sound_fire_id = noone; // The sound ID of the last fire sound played. Used to stop loops, mainly.
sound_stopfire = noone; // A sound made when the gun stops firing, if any.
sound_windup = noone; // A sound made when the guns is winding up to fire, if any.