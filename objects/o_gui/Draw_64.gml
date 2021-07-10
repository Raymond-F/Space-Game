/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_gui);
draw_set_color(c_white);
draw_align_reset();
draw_set_valign(fa_middle);
var offset = 0;
var offset_inc = 30;
draw_sprite(s_icon_pix_medium, 0, 12, 12 + offset);
offset += offset_inc;
draw_sprite(s_icon_crew_medium, 0, 12, 12 + offset);
offset += offset_inc;
draw_sprite(s_icon_supplies_medium, 0, 12, 12 + offset);
offset += offset_inc;
draw_sprite(s_icon_fuel_medium, 0, 12, 12 + offset);
offset = 0;
draw_text(34 + sprite_get_width(s_icon_pix_medium)/2, 24 + offset, string(global.pix));
offset += offset_inc;
draw_text(34 + sprite_get_width(s_icon_crew_medium)/2, 24 + offset, string(global.crew));
offset += offset_inc;
draw_text(34 + sprite_get_width(s_icon_supplies_medium)/2, 24 + offset, string(global.supplies));
offset += offset_inc;
draw_text(34 + sprite_get_width(s_icon_fuel_medium)/2, 24 + offset, string(global.fuel));