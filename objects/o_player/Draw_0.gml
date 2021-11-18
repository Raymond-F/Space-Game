/// @description Insert description here
// You can write your code in this editor
event_inherited();

surface_set_target(path_surf);
var xscale = VIEW_WIDTH/GUIW;
var yscale = VIEW_HEIGHT/GUIH;
for (var i = 0; i < array_length(pathable_hexes); i++) {
	with(pathable_hexes[i]) {
		draw_sprite(s_zonemap_hexpathable, 0, (x - VIEW_LEFT) * xscale, (y - VIEW_TOP) * yscale);
	}
}
surface_reset_target();

draw_set_alpha(0.1);
draw_surface(path_surf, VIEW_LEFT, VIEW_TOP);

draw_set_alpha(0.5);
shader_set(sh_draw_outer_portion);
var u_pixelW = shader_get_uniform(sh_draw_outer_portion, "pixelW");
var u_pixelH = shader_get_uniform(sh_draw_outer_portion, "pixelH");
var u_amount = shader_get_uniform(sh_draw_outer_portion, "amount");
var tex = surface_get_texture(path_surf);
shader_set_uniform_f(u_pixelW, texture_get_texel_width(tex));
shader_set_uniform_f(u_pixelH, texture_get_texel_height(tex));
shader_set_uniform_i(u_amount, 5);
draw_surface(path_surf, VIEW_LEFT, VIEW_TOP);

shader_reset();
surface_clear(path_surf);
draw_set_alpha(1);

draw_self();