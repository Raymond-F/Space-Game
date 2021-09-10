/// @description Insert description here
// You can write your code in this editor
if(faded_in) {
	with(player) {
		draw_set_valign(fa_middle);
		draw_set_halign(fa_left);
		draw_progress_bar(10, 10, 10+GUIW/4, 40, 3, $FFBB22, c_white, shield_current, shield_max);
		draw_set_color(c_white);
		draw_text(25, 25, "SHIELDS");
		draw_set_color(c_white);
		draw_progress_bar(10, 50, 10+GUIW/5, 90, 3, $55FF55, c_white, hull_current, hull_max);
		draw_text(25, 70, "HULL");
	}
	with(enemy) {
		draw_set_halign(fa_right);
		draw_progress_bar(GUIW-10-GUIW/4, 10, GUIW-10, 40, 3, $FFBB22, c_white, shield_current, shield_max, true);
		draw_set_color(c_white);
		draw_text(GUIW-25, 25, "SHIELDS");
		draw_set_color(c_white);
		draw_set_halign(fa_right);
		draw_progress_bar(GUIW-10-GUIW/5, 50, GUIW-10, 90, 3, $5555FF, c_white, hull_current, hull_max, true);
		draw_text(GUIW-25, 70, "HULL");
	}
}

if(fade > 0) {
	draw_set_color(c_black);
	draw_set_alpha(fade);
	draw_rectangle(0, 0, GUIW, GUIH, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
}