/// @description Insert description here
// You can write your code in this editor
draw_self();
draw_set_font(fnt_gui_big);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + sprite_width/2, y + 26, top_text);

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