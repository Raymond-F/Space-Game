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
terrain_spr = noone;