/// @description Insert description here
// You can write your code in this editor
var hx, hy;
if(par.opponent.shield_current > 0) {
	var sh = noone;
	with(o_shield) {
		if (par == other.par.opponent) {
			sh = id;
			break;
		}
	}
	var hit = collision_line_nearest_point(x, y, tx, ty, sh, true, false);
	hx = hit[1];
	hy = hit[2];
} else {
	hx = tx;
	hy = ty;
}
var len = point_distance(x, y, hx, hy);
var ang = point_direction(x, y, hx, hy);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * len/sprite_width, image_yscale, ang, c_white, 1);
start_fx_index += random_range(0.1, 0.125);
end_fx_index += random_range(0.1, 0.125);
draw_sprite(s_hitfx_laser_small, start_fx_index, x, y);
draw_sprite(s_hitfx_laser_small, end_fx_index, hx, hy);