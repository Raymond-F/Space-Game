/// @description Insert description here
// You can write your code in this editor
event_inherited();

arrival_action_delay = max(arrival_action_delay-1, -1);
if (arrival_action_delay == 0) {
	if (target == global.player) { // Fight player if hostile, otherwise scan
		if (factions_are_enemies(factions.player, faction)) { // Fight!
			global.local_ship = id;
			var int = instance_create(hex.x, hex.y, o_zonemap_interaction_icon);
			on_arrival = combat_setup;
			arrival_execution_timer = 45;
		} else {
			global.local_ship = id;
			var fname = "";
			switch (faction) {
				case factions.kfed: fname = "dlg_event_scan_kfed.txt"; break;
				default: fname = "dlg_event_scan_kfed.txt"; break;
			}
			arrival_argument = fname;
			var int = instance_create(hex.x, hex.y, o_zonemap_interaction_icon);
			int.sprite_index = s_zonemap_icon_comms;
			on_arrival = dsys_initialize_window;
			arrival_execution_timer = 45;
			global.last_player_scan = global.current_turn;
		}
	} else { // AI ships fight
		var int = instance_create(hex.x, hex.y, o_zonemap_interaction_icon);
		on_arrival = ai_ship_fight;
		arrival_argument = target;
		arrival_execution_timer = 45;
	}
}
arrival_execution_timer = max(arrival_execution_timer-1, -1);
if (arrival_execution_timer == 0 && on_arrival >= 0) {
	on_arrival(arrival_argument);
	ai_ship_behavior_default(id);
}