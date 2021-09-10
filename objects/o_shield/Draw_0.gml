/// @description Insert description here
// You can write your code in this editor
if(!instance_exists(par)) {
	exit;
}
depth = par.depth - 10;
wiggle += pi/64 + random(pi/128);
var pct = par.shield_current/par.shield_max;
if(pct == 0) {
	break_advancement = min(break_advancement+1, 30);
	if (break_advancement == 30) {
		exit;
	}
}

shader_set(sh_fade_to_point);
shader_set_uniform_f(u_factor, 0.7 + sin(wiggle)*0.03 - pct/2.5 - break_advancement/30);
var tex = sprite_get_texture(sprite_index, image_index);
var uvs = texture_get_uvs(tex);
shader_set_uniform_f_array(u_point, [(uvs[2] - uvs[0])/2, (uvs[3] - uvs[1])/2]);

image_xscale = 1;
image_yscale = 1;
//values are deliberately flipped
var xscale = 1.5*sprite_width/par.sprite_height;
var yscale = 1.5*sprite_height/par.sprite_width;
draw_sprite_ext(sprite_index, image_index, par.x, par.y, xscale, yscale, 0, c_white, 1);

shader_reset();

if(pct <= 0){
	exit;
}

// Draw hit flares
shader_set(sh_fade_from_point);
for (var i = 0; i < ds_list_size(hit_flares); i++) {
	var flare = hit_flares[|i];
	shader_set_uniform_f(u_flare_factor, 12/flare[2]);//sqrt(flare[2])/10);
	var centerpoint = sprite_get_width(s_shipshield)/2;
	var angle = point_direction(par.x, par.y, flare[0], flare[1]);
	var x_uvp = lengthdir_x(centerpoint, angle) + centerpoint;
	var y_uvp = lengthdir_y(centerpoint, angle) + centerpoint;
	var x_rel = x_uvp / (centerpoint*2);
	var y_rel = y_uvp / (centerpoint*2);
	
	var uv_xbase = uvs[0];
	var uv_ybase = uvs[1];
	var uv_width = uvs[2] - uv_xbase;
	var uv_height = uvs[3] - uv_ybase;
	
	var x_in_uv = uv_xbase + (x_rel * uv_width);
	var y_in_uv = uv_ybase + (y_rel * uv_height);
	shader_set_uniform_f_array(u_flare_point, [x_in_uv, y_in_uv]);
	draw_sprite_ext(sprite_index, image_index, par.x, par.y, xscale, yscale, 0, c_white, 1);
	flare[@ 2] = lerp(flare[2], 0, 0.1);
	if(flare[2] < 0.1) {
		ds_list_delete(hit_flares, i);
		i--;
	}
}

image_xscale = xscale - 0.05;
image_yscale = yscale - 0.05;
shader_reset();