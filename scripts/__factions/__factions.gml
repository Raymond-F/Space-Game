// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function faction_get_relation(faction){
	return global.player_relations[? faction];
}

function faction_set_relation(faction, val){
	global.player_relations[? faction] = clamp(val, -100, 100);
}

function faction_modify_relation(faction, amount) {
	var cur = global.player_relations[? faction];
	global.player_relations[? faction] = clamp(cur + amount, -100, 100);
}

function faction_get_enemies(faction) {
	return global.faction_enemies[? faction];
}

function factions_are_enemies(faction1, faction2) {
	if (faction1 == faction2) {
		return false;
	}
	// Ensure the player is always faction 1
	if(faction2 == factions.player) {
		var temp = faction1;
		faction1 = faction2;
		faction2 = temp;
	}
	if (faction1 == factions.player) {
		return (faction_get_relation(faction2) < global.faction_relation_thresholds[faction_relation_level.unwelcome]);
	} else {
		return (array_contains(global.faction_enemies[? faction1], faction2));
	}
}

function factions_are_allies(faction1, faction2) {
	if (faction1 == faction2) {
		return false;
	}
	// Ensure the player is always faction 1
	if(faction2 == factions.player) {
		var temp = faction1;
		faction1 = faction2;
		faction2 = temp;
	}
	if (faction1 == factions.player) {
		return (faction_get_relation(faction2) >= global.faction_relation_thresholds[faction_relation_level.trusted]);
	} else {
		return false; // For now, no factions are allies
	}
}

function faction_get_prefix(faction) {
	switch (faction) {
		case factions.civilian : return "civilian";
		case factions.empire: return "empire";
		case factions.kfed: return "kfed";
		case factions.pirate: return "pirate";
		case factions.rebel: return "rebel";
		default: return "pirate";
	}
}