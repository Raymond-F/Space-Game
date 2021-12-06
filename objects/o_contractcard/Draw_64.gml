/// @description Insert description here
// You can write your code in this editor
draw_self();

draw_set_font(fnt_gui_big);
draw_set_color(C_DIALOGUE);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(x + 165, y + 8, name);

draw_set_halign(fa_left);
draw_text_ext(x + 50, y + 80, desc, -1, 500);

if (icon >= 0) {
	draw_sprite_stretched(icon, 0, 600, 30, 100, 100);
}

var w = 32;
var offset = difficulty * (w/2);
var dy = y + 150;
var dx = x + 650 - offset;
repeat (difficulty + 1) {
	draw_sprite_ext(s_contractpip, 0, dx, dy, 0.25, 0.25, 0, c_white, 1);
	dx += w;
}

// Price
draw_set_valign(fa_bottom);
draw_sprite(s_icon_pix_big, 0, x + 30, y - 30);
draw_text(x + 100, y - 15, string(price));