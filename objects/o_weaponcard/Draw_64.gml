/// @description Insert description here
// You can write your code in this editor
if (!active || !instance_exists(par)) {
	exit;
}
depth = par.depth-1;
if (global.dragged_weapon == id) {
	depth = par.depth - 20;
	if (sprite != noone) {
		draw_set_alpha(0.8);
		if (sprite_get_width(sprite) > 60 || sprite_get_height(sprite) > 60) {
			var scalar = 60 / max(sprite_get_width(sprite), sprite_get_height(sprite));
			var draw_width = sprite_get_width(sprite) * scalar;
			var draw_height = sprite_get_height(sprite) * scalar;
			draw_sprite_stretched(sprite, 0, MOUSE_GUIX - draw_width/2, MOUSE_GUIY - draw_height/2, draw_width, draw_height);
		} else {
			draw_sprite(sprite, 0, MOUSE_GUIX, MOUSE_GUIY);
		}
		draw_set_alpha(1);
	}
	exit;
}
draw_self();
if (global.dragged_weapon != noone && global.dragged_weapon.object_index == o_weaponcard) {
	draw_set_color(c_white);
	draw_rectangle_feathered(x + 1, y + 1, x + sprite_width - 2, y + sprite_height - 2, 0.5, 5)
}
if (point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x + sprite_width, y + sprite_height)) {
	shader_set(sh_to_white);
	var u_alpha = shader_get_uniform(sh_to_white, "draw_alpha");
	shader_set_uniform_f(u_alpha, 0.2);
	draw_self();
	shader_reset();
}
if (sprite != noone) {
	if (sprite_get_width(sprite) > 60 || sprite_get_height(sprite) > 60) {
		var scalar = 60 / max(sprite_get_width(sprite), sprite_get_height(sprite));
		var draw_width = sprite_get_width(sprite) * scalar;
		var draw_height = sprite_get_height(sprite) * scalar;
		draw_sprite_stretched(sprite, 0, x + sprite_width/2 - draw_width/2, y + sprite_height/2 - 8 - draw_height/2, draw_width, draw_height);
	} else {
		draw_sprite(sprite, 0, x + sprite_width/2, y + sprite_height/2 - 8);
	}
}
draw_set_font(fnt_gui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x + sprite_width/2, y + 16, name);
draw_set_halign(fa_right);
draw_text(x + sprite_width - 4, y + 12, string(quantity));