/// @description Insert description here
// You can write your code in this editor
if(PRESSED(ord("U"))){
	e += 5;
}
if(PRESSED(ord("Y"))){
	s += 5;
}
if(PRESSED(ord("J"))){
	outer += 10;
}
if(PRESSED(ord("H"))){
	inner += 10;
}

var surf = surface_create(GUIW, GUIH);
surface_clear(surf);
surface_set_target(surf);
draw_arc(GUIW/2, GUIH/2, s, e, outer, inner, c_aqua);
surface_reset_target();

shader_set(sh_draw_outer_portion);
shader_set_uniform_i(shader_get_uniform(sh_draw_outer_portion, "amount"), 5);
var tex = surface_get_texture(surf);
var pixelW = texture_get_texel_width(tex);
var pixelH = texture_get_texel_height(tex);
shader_set_uniform_f(shader_get_uniform(sh_draw_outer_portion, "pixelW"), pixelW);
shader_set_uniform_f(shader_get_uniform(sh_draw_outer_portion, "pixelH"), pixelH);
draw_surface(surf, 0, 0);

shader_reset();
surface_free(surf);