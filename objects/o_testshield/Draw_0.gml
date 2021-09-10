/// @description Insert description here
// You can write your code in this editor
wiggle += pi/64

shader_set(sh_fade_from_point);
shader_set_uniform_f(u_factor, 1.0 + sin(wiggle)*0.1 + reduction);
var tex = sprite_get_texture(sprite_index, image_index);
var uvs = texture_get_uvs(tex);
shader_set_uniform_f_array(u_point, [(uvs[2] - uvs[0])/2, (uvs[3] - uvs[1])/2]);
draw_sprite_ext(sprite_index, image_index, VIEW_WIDTH/2, VIEW_HEIGHT/2, 1.5, 3.0, 0, c_white, 1);

shader_reset();

draw_text(VIEW_WIDTH/2, VIEW_HEIGHT/2, "FACTOR: " + string(1 + sin(wiggle)*0.1 + reduction));