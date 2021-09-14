/// @description Insert description here
// You can write your code in this editor
if (!active || !instance_exists(par)) {
	exit;
}
depth = par.depth-1;
draw_self();
draw_set_font(fnt_gui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + sprite_width/2, y + sprite_height - 16, name);
draw_set_halign(fa_right);
draw_text(x + sprite_width - 4, y + 16, string(quantity));
draw_sprite(sprite, 0, x + sprite_width/2, y + sprite_height/2 - 8);