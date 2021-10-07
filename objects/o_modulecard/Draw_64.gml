/// @description Insert description here
// You can write your code in this editor
if (!active || !instance_exists(par)) {
	exit;
}
depth = par.depth-1;
draw_self();
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

// Draw module size pips
var pip_coords = [];
switch (class) {
	case 1: pip_coords = [[sprite_width/2, sprite_height - 32]]; break;
	case 2: pip_coords = [[sprite_width/2 - 6, sprite_height - 32],
							[sprite_width/2 + 6, sprite_height - 32]]; break;
	case 3: pip_coords = [[sprite_width/2, sprite_height - 32],
							[sprite_width/2 - 10, sprite_height - 32],
							[sprite_width/2 + 10, sprite_height - 32]]; break;
	case 4: pip_coords = [[sprite_width/2 - 6, sprite_height - 32],
							[sprite_width/2 + 6, sprite_height - 32],
							[sprite_width/2 - 6, sprite_height - 42],
							[sprite_width/2 + 6, sprite_height - 42]]; break;
	case 5: pip_coords = [[sprite_width/2, sprite_height - 32],
							[sprite_width/2 - 10, sprite_height - 32],
							[sprite_width/2 + 10, sprite_height - 32],
							[sprite_width/2 - 6, sprite_height - 42],
							[sprite_width/2 + 6, sprite_height - 42]]; break;
	case 6: pip_coords = [[sprite_width/2, sprite_height - 32],
							[sprite_width/2 - 10, sprite_height - 32],
							[sprite_width/2 + 10, sprite_height - 32],
							[sprite_width/2, sprite_height - 42],
							[sprite_width/2 - 10, sprite_height - 42],
							[sprite_width/2 + 10, sprite_height - 42]]; break;
}
for (var i = 0; i < array_length(pip_coords); i++) {
	draw_sprite(s_module_sizepip, 0, x + pip_coords[i][0], y + pip_coords[i][1]);
}
if (invalid) {
	draw_sprite(s_cancelsymbol, 0, x + sprite_width/2, y + sprite_height/2);
}