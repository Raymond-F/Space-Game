/// @description Insert description here
// You can write your code in this editor
x += lengthdir_x(spd, image_angle);
y += lengthdir_y(spd, image_angle);
lifetime--;
if (lifetime <= 0) {
	instance_destroy();
}