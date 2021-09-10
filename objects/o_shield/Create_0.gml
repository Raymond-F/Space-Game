/// @description Insert description here
// You can write your code in this editor
u_point = shader_get_uniform(sh_fade_from_point, "point");
u_factor = shader_get_uniform(sh_fade_from_point, "factor");
u_flare_point = shader_get_uniform(sh_fade_to_point, "point");
u_flare_factor = shader_get_uniform(sh_fade_to_point, "factor");
wiggle = 0;
par = noone;
hit_flares = ds_list_create();
// When the shield breaks, this rises to visually show the shield fading out
break_advancement = 0;