// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/*
	CONTRACT TYPES
	Bounty - Hunt a specific NPC which will spawn in a given zone.
	Hunting - Kill a specified number of NPCs of a specific faction in a given zone.
	Delivery - Deliver a specified number of items to a given settlement.
	Courier - Travel to a specific settlement.
	Fulfillment - Gather a specified number of items and give it to a settlement
*/
enum contract_type {
	bounty,
	hunting,
	delivery,
	courier,
	fulfillment
}

// Difficulty is from 1 to 5
function contract(initial_location, _difficulty) constructor{
	difficulty = _difficulty
	name = "";
	description = "";
	target_zone = 0;
	loc = initial_location;
	end_loc = loc; // Possibly update this later
	target_faction = noone;
	ship_struct = noone;
}

function contract_generate_bounty_get_factiontarget(cnt) {
	var loc = cnt.loc;
	var fac = loc.faction;
	if (random(1) < 0.8) {
		return factions.pirate;
	} else {
		var enemy = array_choose(faction_get_enemies(fac));
		return enemy;
	}
}

function contract_generate_bounty_get_struct(cnt) {
	var suffix = "";
	switch(cnt.difficulty) {
		case 1: suffix = "easy"; break;
		case 2: suffix = "medium"; break;
		case 3: suffix = "hard"; break;
		case 4: suffix = "veryhard"; break;
		case 5: suffix = "elite"; break;
	}
	var prefix = faction_get_prefix(faction);
	var fn = prefix + "_" + suffix;
	var struct = load_ship_from_file(fn);
	if (struct == noone) {
		show_debug_message("ERROR: Could not parse ship from file: " + fn);
		struct = load_default_ship();
	}
	struct.nickname = ship_generate_name(cnt.target_faction);
	return struct;
}

// Generate a bounty contract's information
function contract_generate_bounty(_contract) {
	var cnt = _contract;
	cnt.target_faction = contract_generate_bounty_get_factiontarget(cnt);
	cnt.ship_struct = contract_generate_bounty_get_struct(cnt);
}