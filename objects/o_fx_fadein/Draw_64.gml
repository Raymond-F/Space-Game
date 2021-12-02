/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(alpha);
draw_set_color(color);
draw_rectangle(0, 0, GUIW, GUIH, false);
draw_set_alpha(1);

alpha -= increment;
if (alpha <= 0) {
	instance_destroy();
}