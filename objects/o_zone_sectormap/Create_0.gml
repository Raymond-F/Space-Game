/// @description Insert description here
// You can write your code in this editor
s = 0;
e = 0;
outer = 0;
inner = 0;
cx = 0;
cy = 0;
depth = -5;
index = 0;
struct = noone;

highlighted = false;
update = false;

c_outer = $33AA33;
c_fill = $118811;

surf = noone;
fill_surf = noone;

draw = function() {
	surf = surface_create(GUIW, GUIH);
	surface_clear(surf);
	surface_set_target(surf);
	draw_arc(cx, cy, s, e, outer, inner, c_outer);
	surface_reset_target();
}

draw_fill = function() {
	fill_surf = surface_create(GUIW, GUIH);
	surface_clear(fill_surf);
	surface_set_target(fill_surf);
	draw_arc(cx, cy, s, e, outer, inner, c_fill);
	surface_reset_target();
}

mouse_in_area = function() {
	var mdist = point_distance(cx, cy, MOUSE_GUIX, MOUSE_GUIY);
	var mang = point_direction(cx, cy, MOUSE_GUIX, MOUSE_GUIY);
	if (mdist <= outer && mdist >= inner && mang >= s && mang <= e) {
		return true;
	}
	return false;
}