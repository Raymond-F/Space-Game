/// @description Insert description here
// You can write your code in this editor
if (color == noone) {
	draw_self();
} else {
	shader_set(sh_to_color);
	shader_set_uniform_f_array(shader_get_uniform(sh_to_color, "colors"), color);
	shader_set_uniform_f(shader_get_uniform(sh_to_color, "draw_alpha"), 1);
	draw_self();
	shader_reset();
}