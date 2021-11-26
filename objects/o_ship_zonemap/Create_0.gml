/// @description Insert description here
// You can write your code in this editor
event_inherited();
ds_list_add(global.ship_registry, id);

draw_setup = false;

ship_struct = noone;
target = noone; // Targeted ship or hex
patrol_center = o_controller_zonemap.hex_array[floor(global.zone_width/2)][floor(global.zone_height/2)]; // Central hex
patrol_radius = 20; // Radius of patrol in hexes
patrol_delay = 0; // Delay until starting another patrol path
final_destination = noone; // Overall destination, e.g. a settlement tile for a merchant. The ship will always try to path here when not running or chasing.
target_last_seen = noone; // Last seen hex of chase or flee target.
enum behaviors {
	patrol, // Move around in a given range towards selected target hex. Target is a hex.
	travel, // Move towards a destination (target), followed by despawning (e.g. entering a settlement). Target is a hex.
	chase, // Chase the selected target ship. Target is a ship.
	flee // Flee from the selected target ship. Target is a ship.
}
behavior = behaviors.patrol;
default_behavior = behaviors.patrol;
inactive_fade_delay = 30;
move_done = false;
turns_since_target_seen = 0; // Tracks how long it's been since a fleeing ship has seen the fled-from target.
image_alpha = 0;

arrival_action_delay = -1;
arrival_execution_timer = -1;
on_arrival = -1; // Function after any appropriate arrival indicators happen
arrival_argument = noone;

/* PATROL AI STUFF */

// Initialize patrol routine, either on creation or from another behavior
ai_ship_patrol_init = function(center_hex, radius) {
	behavior = behaviors.patrol;
	patrol_center = center_hex;
	patrol_radius = radius;
	target = ai_ship_patrol_choose_new();
}

// Pick a new patrol destination
ai_ship_patrol_choose_new = function() {
	while (true) {
		var px, py;
		do {
			px = irandom_range(hex.gx - patrol_radius, hex.gx + patrol_radius);
			py = irandom_range(hex.gy - patrol_radius, hex.gy + patrol_radius);
		} until (px >= 0 && px < global.zone_width && py >= 0 && py < global.zone_height &&
			     point_distance(hex.gx, hex.gy, px, py) <= patrol_radius);
		var thex = o_controller_zonemap.hex_array[px][py];
		if (thex.loc != noone) {
			continue;
		}
		target = thex;
		return;
	}
}

// Step function for patrol behavior
ai_ship_patrol_action = function() {
	var visible_ships = ai_ship_get_ships_in_vision(id);
	// Scan for enemies
	var enemy = noone;
	for (var i = 0; i < array_length(visible_ships); i++) {
		var sh = visible_ships[i];
		if (factions_are_enemies(faction, sh.faction)) {
			enemy = sh;
			break;
		}
	}
	if (enemy != noone) {
		var my_power = ai_local_calculate_power(struct);
		var their_power = ai_local_calculate_power(enemy);
		if (my_power >= their_power || abs((my_power / their_power) - 1) < 0.1) {
			ai_ship_chase_init(enemy);
			target_last_seen = enemy.hex;
			ai_ship_chase();
			return;
		} else {
			ai_ship_flee_init(enemy);
			target_last_seen = enemy.hex;
			ai_ship_flee();
			return;
		}
	} else { // Scan for player and have chance of checking them
		var player_in_range = false;
		for (var i = 0; i < array_length(visible_ships); i++) {
			var sh = visible_ships[i];
			if (sh == global.player) {
				player_in_range = true;
				break;
			}
		}
		if (player_in_range && global.current_turn - global.last_player_scan > global.player_scan_cooldown) {
			ai_ship_chase_init(global.player);
			global.last_player_scan = global.current_turn;
			target_last_seen = global.player.hex;
			ai_ship_chase();
			return;
		}
	}
	// Move towards target
	var thex = ai_ship_get_nearest_hex_to_target(id, target);
	while (thex.contained_ship != noone) { // occupied, pick a new patrol target
		ai_ship_patrol_choose_new();
		var thex = ai_ship_get_nearest_hex_to_target(id, target);
	}
	var me = id;
	with (o_controller_zonemap) {
		set_ship_dest(me, thex);
	}
}

// Move towards the patrol point. If we reach it, pick a new one. If we can reach it but it's
// occupied, move as near as possible and pick a new one. If neutral to the player perhaps rerout
// to scan them. If enemies with a ship, evaluate whether stronger and engage or run.
ai_ship_patrol = function() {
	ai_ship_patrol_action();
}

/* TRAVEL STUFF */

// Final destination should be set up already in the ship creation.
// Now, simply set the target there.
ai_ship_travel_init = function(final_dest) {
	behavior = behaviors.travel;
	final_destination = final_dest;
	target = final_destination;
}

ai_ship_travel_restart = function() {
	behavior = behaviors.travel;
	target = final_destination;
}

ai_ship_travel_action = function() {
	var visible_ships = ai_ship_get_ships_in_vision(id);
	// Scan for enemies
	var enemy = noone;
	for (var i = 0; i < array_length(visible_ships); i++) {
		var sh = visible_ships[i];
		if (factions_are_enemies(faction, sh.faction)) {
			enemy = sh;
			break;
		}
	}
	if (enemy != noone) {
		var my_power = ai_local_calculate_power(struct);
		var their_power = ai_local_calculate_power(enemy);
		if (their_power > my_power/2) {
			ai_ship_flee_init(enemy);
			return 0;
		}
	}
	// Move towards the destination
	var thex = ai_ship_get_nearest_hex_to_target(id, target);
	var me = id;
	with (o_controller_zonemap) {
		set_ship_dest(me, thex);
		if (thex == target) {
			active = false;
		}
	}
}

// Look for enemies to run from. The ship will generally run from basically any enemies in travel
// state, as it's assumed to be for merchants and such. Otherwise, keep going to the destination.
ai_ship_travel = function() {
	ai_ship_travel_action();
}

/* CHASE STUFF */
ai_ship_chase_init = function(_target) {
	behavior = behaviors.chase;
	target = _target;
	target_last_seen = _target.hex;
}

ai_ship_chase_action = function() {
	var visible_ships = ai_ship_get_ships_in_vision(id);
	if (array_contains(visible_ships, target)) {
		var thex = ai_ship_get_nearest_hex_to_target(id, target);
		var me = id;
		with (o_controller_zonemap) {
			set_ship_dest(me, thex);
			return 60;
		}
	}
}

// Chase after the given ship. If they aren't in view, move towards their last known location.
// If we reach their last known location and can't see them, go back to default behavior.
ai_ship_chase = function() {
	ai_ship_chase_action();
}

/* FLEE STUFF */
ai_ship_flee_init = function(target) {
	behavior = behaviors.flee;
}

ai_ship_flee = function() {
	
}