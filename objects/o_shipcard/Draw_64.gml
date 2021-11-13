/// @description Insert description here
// You can write your code in this editor
if (!active || !instance_exists(par)) {
	exit;
}
depth = par.depth-1;
draw_self();
/*
if (point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x + sprite_width, y + sprite_height)) {
	shader_set(sh_to_white);
	var u_alpha = shader_get_uniform(sh_to_white, "draw_alpha");
	shader_set_uniform_f(u_alpha, 0.2);
	draw_self();
	shader_reset();
}*/
if (sprite != noone) {
	if (sprite_get_width(sprite) > 150 || sprite_get_height(sprite) > 150) {
		var scalar = 150 / max(sprite_get_width(sprite), sprite_get_height(sprite));
		var draw_width = sprite_get_width(sprite) * scalar;
		var draw_height = sprite_get_height(sprite) * scalar;
		draw_sprite_stretched(sprite, 0, x + sprite_width/2 - draw_width/2, y + sprite_height/2 - 8 - draw_height/2, draw_width, draw_height);
	} else {
		draw_sprite(sprite, 0, x + sprite_width/2, y + sprite_height/2 - 8);
	}
}
var name_bg_height = 32;
if(struct.nickname != "") {
	name_bg_height = 48;
}
draw_set_color(c_black);
draw_set_alpha(0.3);
draw_rectangle(x + 1, y + 1, x + sprite_width - 1, y + name_bg_height, false);
draw_set_alpha(1);
draw_set_font(fnt_gui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x + sprite_width/2, y + 16, name);
if(struct.nickname != "") {
	draw_text(x + sprite_width/2, y + 32, "\"" + struct.nickname + "\"");
}