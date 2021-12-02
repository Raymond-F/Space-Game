/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_white);
draw_set_alpha((start_timer - timer) / (start_timer*4));
draw_rectangle(0, 0, GUIW, GUIH, false);
draw_set_alpha(1);