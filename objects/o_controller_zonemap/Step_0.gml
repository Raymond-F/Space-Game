/// @description Insert description here
// You can write your code in this editor

// Don't interact with the map when an interface is up
if (instance_exists(par_interface)) {
	exit;
}

// Debug stuff
if (PRESSED(vk_f4)) {
	// Go to nearest settlement
	with (o_zonemap_location) {
		if (type == location_type.settlement) {
			other.targeted_hex = hex;
			other.set_player_dest();
			other.targeted_hex = noone;
			break;
		}
	}
}

pcontrol_timer = max(-1, pcontrol_timer-1);
if (pcontrol_timer == 0) {
	pcontrol = true;
}

selected_hex = mouse_get_hex();

if (!pcontrol || ai_turn) {
	// Skip condition
}
else if (MPRESSED(mb_right) && selected_hex != noone && selected_hex.vision == true &&
		 (global.debug || hex_is_pathable(global.player, selected_hex))) {
	targeted_hex = selected_hex;
	set_player_dest();
	global.current_turn++;
	ai_delay = 30;
	ai_turn = true;
	pcontrol = false;
	pcontrol_timer = 30;
	targeted_hex = noone;
	var s = audio_play_sound(snd_pulsestart, 30, false);
	audio_sound_pitch(s, random_range(0.6, 0.8));
} else if (PRESSED(vk_space)) {
	global.current_turn++;
	ai_turn = true;
	pcontrol = false;
	pcontrol_timer = 30;
} else if (PRESSED(vk_enter)) {
	with (o_zonemap_location) {
		if (hex == global.player.hex) {
			struct.interact();
			if (type == location_type.event) {
				global.event_current_object = id;
			}
			break;
		}
	}
}

/* AI SHIP state machine */
if (ai_turn) {
	if (!turn_init) {
		turn_init = true;
		turn_order = ai_ship_get_turn_order(global.faction_priority)
		turn_index = 0;
		with (o_ship_zonemap) {
			move_done = false;
		}
	}
	while (ai_delay == 0 && turn_index < array_length(turn_order)) {
		var sh = turn_order[turn_index];
		if(!instance_exists(sh)) {
			// The ship was destroyed at some point.
			turn_index++;
			if (turn_index >= array_length(turn_order)) {
				ai_delay = 45;
			}
			continue;
		}
		// Sometimes ships can end up without a target or with an invalid target.
		// In this case, return to default behavior.
		if (!instance_exists(sh.target)) {
			ai_ship_behavior_default(sh);
		}
		// Scan for threats if appropriate.
		var scan = function(sh) {
			if (sh.behavior == behaviors.patrol || sh.behavior == behaviors.travel) {
				var start_behavior = sh.behavior;
				var seen_ship = ai_ship_get_seen_enemy_or_player(sh);
				if (seen_ship != noone) {
					ai_ship_get_response(sh, seen_ship);
					if (sh.behavior != start_behavior && instance_exists(o_zonemap_alert)) {
						ai_delay = 45;
					}
				}
			}
		}
		if (!sh.move_done && state = ai_states.scan) {
			scan(sh);
			state = ai_states.move;
		}
		if (ai_delay > 0) {
			break;
		}
		if (state = ai_states.move) {
			switch (sh.behavior) {
				case behaviors.patrol: {
					if (sh.patrol_delay > 0) {
						sh.patrol_delay--;
						break;
					}
					var nearest = ai_ship_get_nearest_hex_to_target(sh, sh.target);
					var hex_otherwise_pathable =  hex_is_pathable(sh, sh.target);
					set_ship_dest(sh, nearest);
					if (nearest == sh.target || hex_otherwise_pathable) { // Choose new patrol
						// This also fires if the patrol tile is pathable, but occupied.
						sh.ai_ship_patrol_choose_new();
						sh.patrol_delay = irandom_range(2, 3);
					}
				} break;
				case behaviors.travel: {
					var nearest = ai_ship_get_nearest_hex_to_target(sh, sh.target);
					set_ship_dest(sh, nearest);
					if (nearest == sh.target) {
						sh.active = false; // Destination will be reached. Deactivate the ship.
						// If the destination is visible, also proc a delay.
						if (sh.target.vision) {
							ai_delay = 45;
						}
					}
				} break;
				case behaviors.chase: {
					var move_target = sh.target;
					var visible_ships = ai_ship_get_ships_in_vision(sh);
					var target_is_visible = array_contains(visible_ships, sh.target);
					if (!target_is_visible) {
						move_target = sh.target_last_seen;
					} else {
						sh.target_last_seen = sh.target.hex;
					}
					var nearest = ai_ship_get_nearest_hex_to_target(sh, move_target);
					set_ship_dest(sh, nearest);
					if (nearest == sh.target.hex) {
						if (sh.target.hex.vision) {
							if (sh.target == global.player) {
								ai_delay = 90;
							} else {
								ai_delay = 180;
							}
						}
						// Frequently the state machine will pause here as this can often be
						// either a dialogue or combat with the player.
						sh.arrival_action_delay = 30;
					} else if (nearest == sh.target_last_seen) {
						// If the ship has not come into vision, return to default behavior.
						visible_ships = ai_ship_get_ships_in_vision(sh);
						target_is_visible = array_contains(visible_ships, sh.target);
						if (target_is_visible) {
							sh.target_last_seen = sh.target.hex;
						} else {
							ai_ship_behavior_default(sh);
							sh.patrol_delay = irandom_range(1, 2);
						}
					}
				} break;
				case behaviors.flee: {
					var flee_target = sh.target;
					var visible_ships = ai_ship_get_ships_in_vision(sh);
					var target_is_visible = array_contains(visible_ships, sh.target);
					if (!target_is_visible) {
						flee_target = sh.target_last_seen;
					} else {
						sh.target_last_seen = sh.target.hex;
						turns_since_target_seen = 0;
					}
					var farthest = ai_ship_get_farthest_hex_from_target(sh, flee_target);
					set_ship_dest(sh, farthest);
					if (ship_is_in_vision(sh, sh.target)) {
						sh.turns_since_target_seen = 0;
					} else {
						sh.turns_since_target_seen++;
					}
					if (sh.turns_since_target_seen > 2) {
						sh.turns_since_target_seen = 0;
						ai_ship_behavior_default(sh);
					}
				} break;
			}
			sh.move_done = true;
			state = ai_states.scan;
		}
		turn_index++;
		if (turn_index >= array_length(turn_order)) {
			ai_delay = 45;
		}
	}
	if (!instance_exists(par_interface) && !instance_exists(o_combat_manager)) {
		ai_delay = max(0, ai_delay-1);
	}
	if (ai_turn && ai_delay == 0 && turn_index >= array_length(turn_order)) {
		turn_end();
	}
}