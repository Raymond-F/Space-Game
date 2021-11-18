// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// Most functions here are assumed to be run from the zonemap controller.

// Generate a ship appropriate to the area.
function ai_generate_ship(_x, _y, faction) {
	var threat_level = 0; // Scales inversely with security for pirates, and directly for non-civilians
	if (faction == factions.pirate) {
		threat_level = zone_security.high - global.current_zone.security;
	} else if (faction == factions.civilian) {
		threat_level = 0;
	} else {
		threat_level = global.current_zone.security;
	}
}

// Calculate power for a given ship. Power is used to determine relative strength of ships for chase or
// flee decisions.
function ai_local_calculate_power(sh){
	var struct;
	if (sh.object_index == o_player) {
		struct = global.player_ship;
	} else {
		struct = sh.ship_struct;
	}
	// TODO: More robust power calculation
	var pwr;
	pwr = struct.class * 100;
	pwr += array_length(struct.hardpoints)*20;
	if (sh.faction == factions.civilian) {
		pwr *= 0.5;
	}
}