/// @description Insert description here
// You can write your code in this editor
draw_self();

draw_set_font(fnt_gui_big);
draw_set_color(C_DIALOGUE);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(x + 175, y + 8, top_text);

draw_set_font(fnt_dialogue_big);
draw_text_ext(x + sprite_width/2, y + 80, tip_text, -1, sprite_width - 30);

draw_set_halign(fa_middle);
draw_text(x + sprite_width/2, y + 144, contents);