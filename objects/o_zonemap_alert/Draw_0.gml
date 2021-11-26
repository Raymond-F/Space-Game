/// @description Insert description here
// You can write your code in this editor
timer--;

if (timer > 0) {
	image_angle = lerp(image_angle, 0, 0.3);
	scale = lerp(scale, 1, 0.3);
} else if (timer > -10) {
	scale = lerp(scale, 0, 0.3);
} else {
	instance_destroy();
	exit;
}
image_xscale = scale;
image_yscale = scale;
draw_self();