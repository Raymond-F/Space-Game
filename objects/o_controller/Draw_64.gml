/// @description Insert description here
// You can write your code in this editor
if (global.debug) {
	draw_set_font(fnt_gui);
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	if (instance_exists(global.player)) {
		draw_text(GUIW - 10, 10, string(global.player.hex.gx));
		draw_text(GUIW - 10, 30, string(global.player.hex.gy));
	}
	draw_text(GUIW - 10, 50, "Turn: " + string(global.current_turn));
	if (keyboard_lastkey != -1) {
		draw_text(GUIW - 10, 70, "Last press: " + string(keyboard_lastkey));
	}
	draw_text(GUIW - 10, 110, "Instances: " + string(instance_number(all)));
}