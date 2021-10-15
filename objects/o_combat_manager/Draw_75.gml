/// @description Insert description here
// You can write your code in this editor
if(fade > 0) {
	draw_set_color(c_black);
	draw_set_alpha(fade);
	draw_rectangle(0, 0, GUIW, GUIH, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
}