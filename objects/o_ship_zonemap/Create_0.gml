/// @description Insert description here
// You can write your code in this editor
event_inherited();

draw_setup = false;

ship_struct = noone;
target = noone; // Targeted ship or hex
patrol_center = noone; // Central hex
patrol_radius = 20; // Radius of patrol in hexes
enum behaviors {
	patrol, // Move around in a given range towards selected target hex
	travel, // Move towards a destination (target), followed by despawning (e.g. entering a settlement)
	chase, // Chase the selected target ship
	flee // Flee from the selected target ship
}

ai_ship_patrol = function() {
	
}

ai_ship_travel = function() {
	
}

ai_ship_chase = function() {
	
}

ai_ship_flee = function() {
	
}