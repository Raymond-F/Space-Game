/// @description Insert description here
// You can write your code in this editor
if(entrance_delay == 1) {
	instance_create(0, 0, o_screenflash);
}
entrance_delay = max(entrance_delay - 1, 0);
if(entrance_delay == 0) {
	y = lerp(y, targ_y, 0.2);
}
if (hull_current <= 0 && !created_deathfx) {
	created_deathfx = true;
	with(instance_create(x, y, o_explosion_maker)) {
		par = other.id;
	}
}