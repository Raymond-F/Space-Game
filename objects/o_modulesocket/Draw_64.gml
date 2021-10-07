/// @description Insert description here
// You can write your code in this editor
if (locked) {
	draw_set_color($333333);
	draw_rectangle(x, y, x+sprite_width-1, y+sprite_height-1, false);
	image_index = 1; // Locked
} else if (contained != noone) {
	draw_set_color($333333);
	draw_rectangle(x, y, x+sprite_width-1, y+sprite_height-1, false);
	image_index = 0;
} else {
	draw_set_color($111111);
	draw_rectangle(x, y, x+sprite_width-1, y+sprite_height-1, false);
	image_index = 0; // Empty
}

if (global.dragged_module != noone) {
	if (class >= global.dragged_module.class && !locked && contained == noone) {
		draw_set_alpha(0.2);
		draw_set_color(c_white);
		draw_rectangle(x, y, x+sprite_width-1, y+sprite_height-1, false);
		draw_set_alpha(1);
	} else if (class < global.dragged_module.class || locked) {
		draw_set_color(c_red);
		draw_set_alpha(0.2);
		draw_rectangle(x, y, x+sprite_width-1, y+sprite_height-1, false);
		draw_set_alpha(1);
	}
}
if (contained != noone) {
	if (sprite != noone) {
		if (sprite_get_width(sprite) > 60 || sprite_get_height(sprite) > 60) {
			var scalar = 60 / max(sprite_get_width(sprite), sprite_get_height(sprite));
			var draw_width = sprite_get_width(sprite) * scalar;
			var draw_height = sprite_get_height(sprite) * scalar;
			draw_sprite_stretched(sprite, 0, x + sprite_width/2 - draw_width/2, y + sprite_height/2 - draw_height/2, draw_width, draw_height);
		} else {
			draw_sprite(sprite, 0, x + sprite_width/2, y + sprite_height/2 - 8);
		}
	}
	draw_set_color(c_black);
	draw_set_alpha(0.3);
	draw_set_font(fnt_gui_small);
	var maxw = sprite_width-4;
	var nameh = string_height_ext(contained.name, -1, maxw);
	draw_rectangle(x+2, y+2, x+sprite_width-2, y+4 + nameh, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_valign(fa_top);
	draw_set_halign(fa_middle);
	draw_text_ext(x + sprite_width/2, y + 3, contained.name, -1, maxw);
}
draw_self();