/// @description Insert description here
// You can write your code in this editor
draw_self();

draw_set_font(fnt_gui_big);
draw_set_color(C_DIALOGUE);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(x + 165, y + 8, name);

draw_set_halign(fa_left);
draw_set_font(fnt_dialogue);
draw_text_ext(x + 50, y + 70, desc, -1, 500);

if (icon >= 0) {
	draw_sprite_stretched(icon, 0, x + 600, y + 30, 100, 100);
}

var w = 20;
var offset = difficulty * (w/2);
var dy = y + 100;
var dx = x + 682 - offset;
repeat (difficulty + 1) {
	draw_sprite_ext(s_contractpip, 0, dx, dy, 0.125, 0.125, 0, c_white, 1);
	dx += w;
}

// Price
draw_set_valign(fa_bottom);
draw_set_font(fnt_gui_big);
draw_sprite(s_icon_pix_medium, 0, x + 16, y  + sprite_height - 38);
draw_text(x + 40, y + sprite_height - 4, string(price));