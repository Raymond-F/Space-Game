/// @description Insert description here
// You can write your code in this editor
switch (origin_dir) {
	case DIR_EAST: x -= spd; break;
	case DIR_NORTH: y += spd; break;
	case DIR_WEST: x += spd; break;
	case DIR_SOUTH: y -= spd; break;
}

if (x < VIEW_LEFT - length || x > VIEW_RIGHT + length ||
	  y < VIEW_TOP - length || y > VIEW_BOTTOM + length) {
	instance_destroy();	
}