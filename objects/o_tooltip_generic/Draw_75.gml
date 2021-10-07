/// @description Insert description here
// You can write your code in this editor
timer = max(timer-1, 0);
if (timer > 0) {
	alpha = min(alpha+0.05, 1);
} else {
	alpha = max(alpha-0.05, 0);
}
if (timer == 0 && alpha == 0) {
	instance_destroy();
}

draw_set_alpha(alpha);
draw_set_color(c_black);
draw_rectangle(0, GUIH/2-20, GUIW, GUIH/2+20, false);
draw_set_color(c_white);
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(GUIW/2, GUIH/2, text);
draw_set_alpha(1);