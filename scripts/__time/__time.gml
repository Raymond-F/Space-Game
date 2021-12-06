// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/*
	zone_update(zone z)
	
	This function is the main update function for zone time advancement. Every turn, at the end of that turn,
	this function is called. It can also be called many times in succession to simulate a lot of time passing
	in a zone the player hasn't visited in a long time.
	
	As such, this function should be quite fast given it can be requested several hundred times at once
	in many cases.
*/
function zone_update(z){
	var traveller_chance = 0.04;
	
	/*
	z.restock_timer--;
	if (z.restock_timer <= 0) {
		z.restock_timer = irandom_range(150, 200);
		shops_restock_zone(z);
	}*/
	
	if (z.index != global.current_zone) {
		return;
	}
	
	// These will only run if this is the current active zone
	if (random(1) < traveller_chance) {
		generate_traveller();
	}
}

function shops_restock_zone(z) {
	var settlements = zone_get_locations_of_type(location_type.settlement, z);
	for (var i = 0; i < array_length(settlements); i++) {
		var set = settlements[i];
		for (var j = 0; j < ds_list_size(set.shop_list); j++) {
			shop_restock(set.shop_list[|j]);
		}
	}
}

// Generates a traveller in the current zone
// If `init` is true, travellers can be generated on any random tile. Otherwise they generate on the edge.
function generate_traveller(init = false, faction = factions.civilian) {
	var start, final, dest_type; // dest_type is 0 for settlement, 1 for map edge
	// Pick a start hex
	if (init) {
		var hex;
		do {
			var xx = irandom(global.zone_width-1);
			var yy = irandom(global.zone_height-1);
			hex = get_hex_coord(xx, yy);
		} until (hex.contained_ship == noone);
		start = hex;
		dest_type = choose(0, 1);
	} else {
		var hex;
		do {
			var xx, yy;
			// Start from settlement
			if (settlement_exists() && random(1) < 0.5) {
				var loc = array_choose(zone_get_locations_of_type(location_type.settlement));
				xx = loc.gx;
				yy = loc.gy;
				dest_type = 1;
			} else { // Start from edge
				// Horizontal edge
				if (random(1) < 0.5) {
					xx = choose(0, global.zone_width-1);
					yy = irandom(global.zone_height-1);
				} else {
					xx = irandom(global.zone_width-1);
					yy = choose(0, global.zone_height-1);
				}
				dest_type = 0;
			}
			hex = get_hex_coord(xx, yy);
		} until (hex.contained_ship == noone && (!hex.on_edge || hex.connection != noone));
		start = hex;
	}
	// Pick a destination hex
	switch(dest_type) {
		case 0 :
			var loc = array_choose(zone_get_locations_of_type(location_type.settlement));
			final = get_hex_coord(loc.gx, loc.gy);
			break;
		case 1 :
			var xx, yy, h;
			do {
				if (random(1) < 0.5) {
					xx = choose(0, global.zone_width-1);
					yy = irandom(global.zone_height-1);
				} else {
					xx = irandom(global.zone_width-1);
					yy = choose(0, global.zone_height-1);
				}
				var h = get_hex_coord(xx, yy);
			} until (xx != start.gx && yy != start.gy && h.connection != noone);
			final = h;
			break;
	}
	ai_create_ship_travel(faction, start, final);
}