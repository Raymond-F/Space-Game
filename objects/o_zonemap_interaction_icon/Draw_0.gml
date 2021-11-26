/// @description Insert description here
// You can write your code in this editor
timer--;

if (timer > 0) {
	image_angle = lerp(image_angle, 0, 0.3);
	scale = lerp(scale, 0.125, 0.3);
} else if (timer > -10) {
	scale = lerp(scale, 0, 0.3);
} else {
	instance_destroy();
	exit;
}
image_xscale = scale;
image_yscale = scale;
if (scale > 0) {
	var surf = surface_create(ceil(sprite_width), ceil(sprite_height));
	surface_clear(surf);
	surface_set_target(surf);
	draw_sprite_ext(sprite_index, image_index, sprite_width/2, sprite_height/2, image_xscale, image_yscale, 0, c_white, 1);
	surface_reset_target();
	draw_surface(surf, x - sprite_width/2, y - sprite_height/2);
	draw_outline_surface(surf, x - sprite_width/2, y - sprite_height/2, 1);
	surface_free(surf);
}