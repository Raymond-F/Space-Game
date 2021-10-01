/// @description Insert description here
// You can write your code in this editor
draw_sprite(sprite_index, image_index, GUIW/2-sprite_width/2, GUIH/2-sprite_height/2);
draw_set_color(c_white);
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(GUIW/2, GUIH/2-sprite_height/2 + 8, title);
if (image != noone) {
	// TODO: Draw image
}