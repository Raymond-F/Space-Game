/// @description Insert description here
// You can write your code in this editor
if(!instance_exists(par)) {
	instance_destroy();
	exit;
}
depth = par.depth-1;
//draw_sprite_ext(sprite_index, image_index, x, y, scale, scale, image_angle, c_white, 1);