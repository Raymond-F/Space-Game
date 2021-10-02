/// @description Insert description here
// You can write your code in this editor
var xx = GUIW/2-sprite_width/2, yy = GUIH/2 - sprite_height/2;
draw_sprite(sprite_index, image_index, xx, yy);
draw_set_color(c_white);
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(GUIW/2, yy + 8, title);
if (image != noone) {
	// TODO: Draw image
}
var size_spr;
switch (loc.struct.size) {
	case location_size.large : size_spr = s_icon_settlementsize_large; break;
	case location_size.medium : size_spr = s_icon_settlementsize_medium; break;
	case location_size.small : size_spr = s_icon_settlementsize_small; break;
}
draw_sprite(size_spr, 0, xx + sprite_width - 40, yy + 8);
for (var i = 0; i < array_length(loc.struct.industries); i++) {
	var spr = settlement_get_industry_icon(loc.struct.industries[i]);
	draw_sprite(spr, 0, xx + 20 + (sprite_get_width(spr) + 4)*i, yy + 56);
}