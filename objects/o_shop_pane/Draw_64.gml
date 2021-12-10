/// @description Insert description here
// You can write your code in this editor
draw_self();
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + sprite_width/2, y + 26, top_text);

// Weight display
var wy = y + sprite_height - 26;
var wx = x + sprite_width*4/5;
draw_weight_display(wx, wy);