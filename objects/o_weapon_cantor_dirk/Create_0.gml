/// @description Insert description here
// You can write your code in this editor
event_inherited();

weapon_id = 0;
type = weapon_type.projectile;
charge = 0;
charge_max = 8;
projectile_sprite = s_projectile_ballistic_default;
projectile_object = o_ballistic_default_projectile;
projectile_spread = 30;
barrel_length = 30;
flash_scale = 0.5; //scale of muzzle flash
name = "Cantor Dirk"

ai = function() {
	if(!setup) {
		setup = true;
		max_shots = 8;
		damage = 10;
		shield_damage_multiplier = 1.4;
		hull_damage_multiplier = 1;
		armor_penetration = 0;
		projectile_speed = 12;
		shots_remaining = max_shots;
		cooldown_max = 5;
		cooldown_remaining = 0;
		firing = false;
		windup_max = 10;
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