/// @description Insert description here
// You can write your code in this editor
draw_self();
if (point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x + sprite_width, y + sprite_height)) {
	shader_set(sh_to_white);
	var u_alpha = shader_get_uniform(sh_to_white, "draw_alpha");
	shader_set_uniform_f(u_alpha, 0.2);
	draw_self();
	shader_reset();
}
if (sprite != noone) {
	draw_sprite(sprite, 0, x + sprite_width/2, y + sprite_height/2);
}
switch (sprite_index) {
	case s_button_tab: // Fallthrough
	case s_button_small: draw_set_font(fnt_dialogue); break;
	case s_button_large: draw_set_font(fnt_gui_big); break;
	default: draw_set_font(fnt_dialogue); break;
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x + sprite_width/2, y + sprite_height/2, text);