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
				shots_remaining--;
				var flash = instance_create(proj.x, proj.y, o_muzzleflash);
				flash.par = id;
				flash.scale = flash_scale;
				flash.image_angle = image_angle + random_range(-10,10);
			}
			if(shots_remaining > 0) {
				cooldown_remaining--;
			} else {
				firing = false;
				image_angle %= 360;
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
projectile_object = noone;
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