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
function contract(initial_location, _difficulty) constructor {
	difficulty = _difficulty
	name = "";
	description = "";
	type = contract_type.bounty;
	target_zone = 0;
	loc = initial_location; // Where this contract was accepted from
	end_loc = loc; // Possibly update this later for certain types of contract.
	target_zone = noone; // Zone of the target location or enemy(ies).
	target_faction = noone; // Target faction for bounty or hunting contracts
	ship_struct = noone; // Ship struct for bounty contracts
	target_hex = [0, 0]; // Coordinates of patrol center for bounty contracts
	item_id = noone; // Item id for fulfillment/delivery contracts
	current_number = 0; // Current number for fulfillment/delivery/hunting contracts
	target_number = 1; // Target number for fulfillment/delivery/hunting contracts
	price = 1000; // How much this contract pays out
	stage = 0; // Stages of progress on the contract
	last_stage = 0; // Stage on which this can be turned in
	stage_strings = []; // Array of strings for stage-related imperatives, e.g. "Travel to Zone 2".
}

// Generate contracts for a settlement.
// Uses location struct
function settlement_generate_contracts(loc) {
	var weight;
	switch (loc.size) {
		case location_size.small: weight = [1, 2]; break;
		case location_size.medium: weight = [1, 1, 2, 2, 2, 2, 3]; break;
		case location_size.large: weight = [1, 2, 2, 3, 3]; break;
	}
	var num = array_choose(weight);
	// Clear current contracts at this location
	for (var i = 0; i < ds_list_size(loc.contracts); i++) {
		var c = loc.contracts[|i];
		delete c;
	}
	ds_list_clear(loc.contracts);
	repeat (num) {
		contract_generate(loc);
	}
}

function contract_generate(loc) {
	/* TODO: Uncomment this when all types of contract are working.
	var type = choose_weighted([contract_type.bounty, 4, contract_type.courier, 2, contract_type.delivery, 3,
								contract_type.fulfillment, 1, contract_type.hunting, 3]);
	*/
	var type = contract_type.bounty;
	var z = zone_get(loc.in_zone);
	var sec = z.security;
	var new_contract;
	switch (type) {
		case contract_type.bounty : {
			// TODO: difficulty calculation
			// Low security locations generate higher value bounties.
			var dfc = 0;
			new_contract = new contract(loc, dfc);
			contract_generate_bounty(new_contract);
		} break;
		default: break;
	}
	new_contract.type = type;
	ds_list_add(loc.contracts, new_contract);
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

function contract_generate_text_bounty(cnt) {
	//TODO: This will need unique text per faction targeted. Perhaps also variants. Just one for now.
	cnt.name = "Hunt " + cnt.ship_struct.nickname;
	var desc = "Bring justice to the notorious captain of the vessel known as %SN%. They can be found in %ZONE%.";
	var ship_name = cnt.ship_struct.nickname;
	var zone_name = zone_get(cnt.target_zone).name;
	desc = string_replace_all(desc, "%SN%", ship_name);
	desc = string_replace_all(desc, "%ZONE%", zone_name);
	cnt.description = desc;
	cnt.stage_strings[0] = "Travel to " + zone_name + ".";
	cnt.stage_strings[1] = "Find and destroy the ship known as " + ship_name + ".";
	cnt.stage_strings[2] = "Return to " + cnt.loc.name + " to claim your reward.";
}

// Generate a bounty contract's information
function contract_generate_bounty(_contract) {
	var cnt = _contract;
	cnt.target_faction = contract_generate_bounty_get_factiontarget(cnt);
	cnt.ship_struct = contract_generate_bounty_get_struct(cnt);
	cnt.target_hex = [irandom_range(10, global.zone_width - 10), irandom_range(10, global.zone_height - 10)];
	cnt.target_zone = zone_get_random_adjacent(zone_get(cnt.loc.in_zone));
	contract_generate_text_bounty(cnt);
	cnt.last_stage = 2;
	
	return cnt;
}

// Accept a contract
function contract_accept(cnt) {
	global.current_contract = cnt;
	var list = global.active_settlement.struct.contracts;
	ds_list_delete(list, ds_list_find_index(list, cnt));
}

// Finish a contract
function contract_complete(cnt) {
	global.pix += cnt.price;
	faction_modify_relation(global.active_settlement.faction, irandom_range(1, 3) + round(cnt.difficulty/2));
	delete cnt;
	global.current_contract = noone;
}

// Abandon a contract
function contract_cancel(cnt) {
	faction_modify_relation(cnt.loc.faction, -5);
	delete cnt;
	global.current_contract = noone;
}

