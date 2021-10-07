/// @description Insert description here
// You can write your code in this editor
event_inherited();

weapon_id = 1;
type = weapon_type.projectile;
charge = 0;
charge_max = 10;
max_shots = 12;
cooldown_max = 4; // How long between shots in burst
windup_max = 10; // How long it takes the gun to track to the target
damage = 30;
shield_damage_multiplier = 1.4;
hull_damage_multiplier = 1;
armor_penetration = 0;
projectile_speed = 16;
projectile_sprite = s_projectile_ballistic_large;
projectile_object = o_ballistic_default_projectile;
projectile_spread = 10;
barrel_length = 34;
flash_scale = 1; //scale of muzzle flash
name = "Cantor Striker"

ai = ai_weapon_projectile_default;

sound_windup = snd_gunshot_strikerwindup;
sound_fire = [snd_gunshot_strikerloop];
sound_fire_loops = true;
sound_stopfire = snd_gunshot_strikerstop;