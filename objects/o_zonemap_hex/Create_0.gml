/// @description Insert description here
// You can write your code in this editor
enum hex_type {
	empty = 0,
	dust = 1
}

setup = false;
type = hex_type.empty;
gx = 0;
gy = 0;
explored = false;
movement_cost = 1; // negative numbers denote unpathable
vision_cost = 1; // negative numbers denote that all vision ends on that hex
contained_ship = noone; // What ship is here. Only one ship can be permanently on a tile.
// If more than one ship is on a tile, one of them will either die, despawn, or leave after
// whatever action brings it there.
loc = noone;