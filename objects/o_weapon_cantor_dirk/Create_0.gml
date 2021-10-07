/// @description Insert description here
// You can write your code in this editor
event_inherited();

weapon_id = 0;
type = weapon_type.projectile;
charge = 0;
charge_max = 8;
max_shots = 8;
cooldown_max = 5; // How long between shots in burst
windup_max = 10; // How long it takes the gun to track to the target
damage = 10;
shield_damage_multiplier = 1.4;
hull_damage_multiplier = 1;
armor_penetration = 0;
projectile_speed = 12;
projectile_sprite = s_projectile_ballistic_default;
projectile_object = o_ballistic_default_projectile;
projectile_spread = 30;
barrel_length = 30;
flash_scale = 0.5; //scale of muzzle flash
name = "Cantor Dirk"

ai = ai_weapon_projectile_default;

sound_fire_loops = true;
sound_fire = [snd_gunshot_dirkloop];
sound_stopfire = snd_gunshot_dirkstop;
sound_windup = snd_gunshot_dirkwindup;