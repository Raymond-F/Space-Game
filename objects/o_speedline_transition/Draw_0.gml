/// @description Insert description here
// You can write your code in this editor
var ex = x;
var ey = y;
switch(origin_dir) {
	case DIR_EAST: ex += length; break;
	case DIR_NORTH: ey += length; break;
	case DIR_WEST: ex -= length; break;
	case DIR_SOUTH: ey += length; break;
}

draw_set_color(c_white);
draw_line_width(x, y, ex, ey, thickness);