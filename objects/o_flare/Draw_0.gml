/// @description Insert description here
// You can write your code in this editor
draw_flare(x, y, radius, color, buffer_factor);
draw_flare(x, y, radius*1.5, c_white, 0);
radius = lerp(radius, 0, 0.2);
minimum_life--;
if (radius < 10 && minimum_life <= 0) {
	instance_destroy();
}