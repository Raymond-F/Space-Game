/// @description Insert description here
// You can write your code in this editor
draw_self();
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + sprite_width/2, y + 26, top_text);

if (tab == open_tab.module) {
	// Draw class indicators
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_gui);
	var gap = 109;
	var count = 0;
	var yy = y + 54;
	draw_text(x + 216, yy + gap*count, "CLASS 1"); count++;
	draw_text(x + 216, yy + gap*count, "CLASS 2"); count++;
	draw_text(x + 216, yy + gap*count, "CLASS 3"); count++;
	draw_text(x + 216, yy + gap*count, "CLASS 4"); count++;
	draw_text(x + 216, yy + gap*count, "CLASS 5"); count++;
	draw_text(x + 216, yy + gap*count, "CLASS 6");
} else if (tab == open_tab.weapon) {
	// Draw ship sprite
	var sh = global.editing_ship;
	var spr = sh.sprite;
	draw_sprite(spr, 0, x + 566, y + 375);
	draw_set_font(fnt_gui_big);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_color(C_DIALOGUE);
	draw_text(x + 566, y + sprite_height - 10, sh.name);
} else if (tab == open_tab.ship) {
	// Draw ship sprite
	var sh = global.editing_ship;
	var spr = sh.sprite;
	draw_sprite(spr, 0, x + 800, y + 375);
	draw_set_font(fnt_gui_big);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_color(C_DIALOGUE);
	draw_text(x + 800, y + sprite_height - 10, sh.name);
	draw_set_valign(fa_top);
	draw_text(x + 800, y + 60, "CURRENT SHIP");
}