/// @description Insert description here
// You can write your code in this editor
event_inherited();

weapon_id = 100;
type = weapon_type.beam;
charge = 0;
charge_max = 4;
max_shots = 1;
windup_max = 10; // How long it takes the gun to track to the target
damage = 600;
shield_damage_multiplier = 0.8;
hull_damage_multiplier = 1.25;
armor_penetration = 0;
projectile_sprite = s_projectile_laser_narrow;
projectile_object = o_beam_default_projectile;
barrel_length = 20;
flash_scale = 1; //scale of muzzle flash
name = "NT Alpha"

ai = ai_weapon_beam_default;

sound_fire = [snd_gunshot_newtonalphaloop];
sound_fire_loops = true;
sound_windup = snd_gunshot_newtonalphawindup;
sound_stopfire = snd_gunshot_newtonalphastop;