/// @description Insert description here
// You can write your code in this editor
if (!active || !instance_exists(par)) {
	exit;
}
depth = par.depth-1;
draw_self();
if ((buying || selling) && point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x + sprite_width, y + sprite_height)) {
	shader_set(sh_to_white);
	var u_alpha = shader_get_uniform(sh_to_white, "draw_alpha");
	shader_set_uniform_f(u_alpha, 0.2);
	draw_self();
	shader_reset();
}
if (sprite != noone) {
	if (sprite_get_width(sprite) > 120 || sprite_get_height(sprite) > 120) {
		var scalar = 120 / max(sprite_get_width(sprite), sprite_get_height(sprite));
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
draw_text(x + sprite_width/2, y + sprite_height - 16, name);
if (variable_struct_exists(struct, "nickname") && struct.nickname != "") {
	draw_text(x + sprite_width/2, y + sprite_height - 32, "\"" + struct.nickname + "\"")
}
if (struct.struct_t != struct_type.ship) {
	draw_set_halign(fa_right);
	draw_text(x + sprite_width - 4, y + 12, string(quantity));
}
var yoffset = 0;
if (buying || selling) {
	var val_string = string(value);
	draw_set_halign(fa_left);
	if (buying && value > global.pix) {
		draw_set_color(C_SKILLTEST_FAILURE);
	} else {
		draw_set_color(c_white);
	}
	draw_text(x + sprite_get_width(s_icon_pix_medium), y + 12, val_string);
	draw_sprite(s_icon_pix, 0, x + 4, y + 4);
	yoffset += 20;
}
if (struct.struct_t == struct_type.cargo) {
	var weight_string = string(struct.weight);
	// If this is a decimal, remove trailing zeroes
	if (struct.weight % 1 != 0) {
		weight_string = string_remove_trailing_zeroes(weight_string);
	}
	// If this is not in a shop inventory, show the total weight
	if (!buying && struct.quantity > 1) {
		var total_weight = struct.weight * struct.quantity;
		var total_weight_string = string(total_weight);
		if (total_weight % 1 != 0) {
			total_weight_string = string_remove_trailing_zeroes(total_weight_string);
		}
		weight_string = total_weight_string + " (" + weight_string + ")";
	}
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	if (transfer_target == global.player_inventory && struct.weight > cargo_get_available_space()) {
		draw_set_color(C_SKILLTEST_FAILURE);
	}
	draw_text(x + sprite_get_width(s_icon_itemweight) + 8, y + 12 + yoffset, weight_string);
	draw_sprite(s_icon_itemweight, 0, x + 4, y + 4 + yoffset);
}

if (struct.struct_t == struct_type.module) {
	// Draw module size pips
	var pip_coords = [];
	switch (struct.class) {
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
}