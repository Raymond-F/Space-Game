/// @description Insert description here
// You can write your code in this editor
x += lengthdir_x(spd, image_angle);
y += lengthdir_y(spd, image_angle);
lifetime--;
if (lifetime <= 0) {
	var fx = instance_create(x, y, o_zonemap_fightbullet_hit);
	fx.depth = depth - 1;
	instance_destroy();
}