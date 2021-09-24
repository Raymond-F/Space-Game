/// @description Insert description here
// You can write your code in this editor
var bg = s_spacebg_placeholder_sectormap;
draw_sprite_ext(bg, 0, 0, 0, GUIW/sprite_get_width(bg), GUIH/sprite_get_height(bg), 0, c_white, 0.8);
var layers = [];
var _cx = 0, _cy = 0;
var most_inner = 99999, most_outer = 0;
with (o_zone_sectormap) {
	_cx = cx;
	_cy = cy;
	if (array_find(layers, inner) < 0) {
		array_push(layers, inner);
		most_inner = min(most_inner, inner);
	}
	if (array_find(layers, outer) < 0) {
		array_push(layers, outer);
		most_outer = max(most_outer, outer);
	}
}
draw_set_color($444444);
draw_set_alpha(0.2);
draw_circle(_cx, _cy, most_outer, false);
draw_circle(_cx, _cy, most_inner, false);
for (var i = 0; i < array_length(layers); i++) {
	draw_set_color($888888);
	draw_set_alpha(1);
	draw_circle(_cx, _cy, layers[i], true);
}