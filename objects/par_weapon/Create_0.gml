/// @description Insert description here
// You can write your code in this editor
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