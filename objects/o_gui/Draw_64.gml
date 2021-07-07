/// @description Insert description here
// You can write your code in this editor
draw_sprite(s_icon_pix_medium, 0, 12, 12);
draw_set_font(fnt_gui);
draw_set_color(c_white);
draw_align_reset();
draw_set_valign(fa_middle);
draw_text(34 + sprite_get_width(s_icon_pix_medium)/2, 24, string(global.pix));