/// @description Insert description here
// You can write your code in this editor

if (!surface_exists(surf) || update) {
	draw();
}
if (!surface_exists(fill_surf) || update) {
	draw_fill();
}
update = false;
draw_set_alpha(highlighted ? 0.4 : 0.2);
draw_surface(fill_surf, 0, 0);
draw_set_alpha(1);
shader_set(sh_draw_outer_portion);
shader_set_uniform_i(shader_get_uniform(sh_draw_outer_portion, "amount"), 3);
var tex = surface_get_texture(surf);
var pixelW = texture_get_texel_width(tex);
var pixelH = texture_get_texel_height(tex);
shader_set_uniform_f(shader_get_uniform(sh_draw_outer_portion, "pixelW"), pixelW);
shader_set_uniform_f(shader_get_uniform(sh_draw_outer_portion, "pixelH"), pixelH);

draw_surface(surf, 0, 0);
shader_reset();

if(highlighted) {
	draw_set_color(c_white);
	draw_set_font(fnt_dialogue);
	draw_text(MOUSE_GUIX, MOUSE_GUIY, "Locations: " + string(ds_list_size(struct.locations)));
}