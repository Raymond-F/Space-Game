// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// Type of location in zone map
enum location_type {
	settlement,
	pirate_base,
	event,
	derelict,
	comet
}

// Size of settlement
enum location_size {
	small,
	medium,
	large
}

function settlement_get_random_name() {
	var name_list = file_parse_lines("data\\settlement_names.txt");
	var unique = false;
	var name = "";
	do {
		name = array_choose(name_list);
		unique = true;
		for (var i = 0; i < ds_list_size(global.settlement_list); i++) {
			if (name == global.settlement_list[|i].name) {
				unique = false;
				break;
			}
		}
	} until (unique);
	return name;
}

function location(z, _gx, _gy, _type) constructor {
	gx = _gx;
	gy = _gy;
	type = _type;
	obj = noone;
	img_index = 0; // Used for locations with multiple possible sprites
	size = location_size.small; // Used for settlements and possibly pirate bases
	name = ""; tip_text = ""; prompt_text = "";
	in_zone = z.index;
	last_visited = -1;
	restock_timer = -1;
	switch(type) {
		case location_type.settlement : {
			interact = function() {
				open_settlement_window(obj.id);
			}
			// Set tooltips
			name = settlement_get_random_name();
			tip_text = "A settlement drifting in the Kaib. The folk here are civilized enough and should be open to providing trade and work.";
			prompt_text = "VISIT";
			ds_list_add(global.settlement_list, self);
		} break;
		case location_type.pirate_base : {
			interact = function() {
				// TODO: some kind of handling for this?
			}
			// Set tooltips
			name = "Pirate Base"
			tip_text = "A settlement drifting in the Kaib. This settlement in particular is the operating base for pirates, smugglers, and other nefarious entities. It may be best to stay away.";
			prompt_text = "VISIT";
		} break;
		case location_type.event : {
			interact = function() {
				event_trigger_random();
			}
			// Set tooltips
			name = "Unknown";
			tip_text = "There's something here. You'll have to investigate further to find out more.";
			prompt_text = "INVESTIGATE";
		} break;
		case location_type.derelict : {
			interact = function() {
				// TODO: derelict harvesting
			}
			// Set tooltips
			name = "Derelict";
			tip_text = "Wreckage of a ship drifts here. Often there are still things of value left, even if scavs have taken a pass or two already.";
			prompt_text = "SALVAGE";
		} break;
		case location_type.comet : {
			interact = function() {
				// TODO: comet harvesting
			}
			// Set tooltips
			name = "Comet";
			tip_text = "This comet has a relatively stable orbital trajectory. It seems to be an ideal candidate for a mining operation, if you've the equipment.";
			prompt_text = "MINE"
		}
		default : {
			interact = function() {}
		} break;
	}
	resources = 1; // Percentage of max resources remaining. Depletes as it's looted. Used in comets/derelicts
	zone_id = noone; // Id of the zone this is in.
	faction = noone;
	patrols = []; // Patrolling NPCs, be they KFED, pirates, or rogue AI. Needs to be cleared at zone transition.
	contracts = ds_list_create();
}

function location_replenish_patrol(loc) {
	for (var i = 0; i < array_length(loc.patrols); i++) {
		if (loc.patrols[i] == noone) {
			var _gx, _gy;
			do {
				_gx = gx + irandom_range(-8, 8);
				_gy = gy + irandom_range(-8, 8);
			} until (hex_exists(_gx, _gy));
			var hex = get_hex_coord(_gx, _gy);
			patrols[i] = ai_create_ship_patrol(faction, hex, 12);
			return patrols[i];
		}
	}
}

function location_create(loc, zone_cont) {
	var _hex = zone_cont.hex_array[loc.gx][loc.gy];
	with (instance_create(_hex.x, _hex.y, o_zonemap_location)) {
		gx = loc.gx;
		gy = loc.gy;
		type = loc.type;
		image_index = loc.img_index;
		size = loc.size;
		hex = _hex;
		_hex.loc = id;
		resources = loc.resources;
		struct = loc;
		faction = noone;
		if (loc.type == location_type.settlement) {
			var z = zone_get_current();
			faction = z.controlling_faction;
			loc.faction = faction;
		} else if (loc.type == location_type.pirate_base) {
			faction = factions.pirate;
			loc.faction = factions.pirate;
		}
		repeat(array_length(loc.patrols)) {
			location_replenish_patrol(loc);
		}
		return id;
	}
}

function hex_exists(gx, gy) {
	return (gx >= 0 && gx < global.zone_width && gy >= 0 && gy < global.zone_height);
}

function distance_nearest_location(xx, yy, z) {
	var smallest_dist = 999;
	for (var i = 0; i < ds_list_size(z.locations); i++) {
		var loc = z.locations[|i];
		var d = point_distance(loc.gx, loc.gy, xx, yy);
		smallest_dist = min(d, smallest_dist);
	}
	return smallest_dist;
}

// Includes settlements and pirate bases
function distance_nearest_settlement(xx, yy, z) {
	var smallest_dist = 999;
	for (var i = 0; i < ds_list_size(z.locations); i++) {
		var loc = z.locations[|i];
		if (loc.type == location_type.event) {
			continue;
		}
		var d = point_distance(loc.gx, loc.gy, xx, yy);
		smallest_dist = min(d, smallest_dist);
	}
	return smallest_dist;
}

function place_settlement(z) {
	// Do not place settlements within 5 tiles of the map edge
	var minx = 5, miny = 5, maxx = global.zone_width - 6, maxy = global.zone_height - 6;
	var cx, cy;
	do {
		cx = irandom_range(minx, maxx);
		cy = irandom_range(miny, maxy);
	} until (distance_nearest_settlement(cx, cy, z) > 15);
	var set = new location(z, cx, cy, location_type.settlement);
	var size_weighting;
	switch (z.security) {
		case zone_security.high: size_weighting = [location_size.large, location_size.large, location_size.medium, location_size.medium, location_size.small]; break;
		case zone_security.moderate: size_weighting = [location_size.large, location_size.medium, location_size.medium, location_size.small, location_size.small, location_size.small]; break;
		case zone_security.sparse: size_weighting = [location_size.medium, location_size.small]; break;
		case zone_security.little: size_weighting = [location_size.medium, location_size.medium, location_size.small]; break;
		case zone_security.lawless: size_weighting = [location_size.small]; break;
		default: size_weighting = [location_size.small]; break;
	}
	set.size = array_choose(size_weighting);
	set.img_index = irandom(sprite_get_number(s_zonemap_pirate_base_small));
	set.zone_id = z;
	var num_patrols;
	switch (z.security) {
		case zone_security.high : num_patrols = 2; break;
		case zone_security.moderate : num_patrols = 2; break;
		case zone_security.sparse : num_patrols = choose(1, 1, 2); break;
		case zone_security.little : num_patrols = 1; break;
		case zone_security.lawless : num_patrols = 0; break;
	}
	if (set.size == location_size.large) {
		num_patrols += 2;
	} else if (set.size == location_size.medium) {
		num_patrols++;
	}
	set.patrols = array_create(num_patrols, noone);
	// Set up settlement-specific things
	settlement_init(set);
	ds_list_add(z.locations, set);
	return set;
}

function place_pirate_base(z) {
	// Do not place settlements within 5 tiles of the map edge
	var minx = 5, miny = 5, maxx = global.zone_width - 6, maxy = global.zone_height - 6;
	var cx, cy;
	do {
		cx = irandom_range(minx, maxx);
		cy = irandom_range(miny, maxy);
	} until (distance_nearest_settlement(cx, cy, z) > 15);
	var base = new location(z, cx, cy, location_type.settlement);
	var size_weighting;
	// Pirate bases have inverse size to security
	switch (z.security) {
		case zone_security.lawless: size_weighting = [location_size.large, location_size.large, location_size.medium, location_size.medium, location_size.small]; break;
		case zone_security.little: size_weighting = [location_size.large, location_size.medium, location_size.medium, location_size.small, location_size.small, location_size.small]; break;
		case zone_security.sparse: size_weighting = [location_size.medium, location_size.small]; break;
		case zone_security.moderate: size_weighting = [location_size.medium, location_size.medium, location_size.small]; break;
		case zone_security.high: size_weighting = [location_size.small]; break;
		default: size_weighting = [location_size.small]; break;
	}
	base.size = array_choose(size_weighting);
	var num_patrols;
	switch(base.size) {
		case location_size.small: num_patrols = choose(1, 2, 2); break;
		case location_size.medium: num_patrols = 2; break;
		case location_size.large: num_patrols = 3; break;
		default: num_patrols = 1; break;
	}
	base.patrols = array_create(num_patrols, noone);
	base.img_index = irandom(sprite_get_number(s_zonemap_settlement_small_icon));
	base.zone_id = z;
	ds_list_add(z.locations, base);
	return base;
}

function place_event(z) {
	// Do not place events within 3 tiles of the map edge
	var minx = 3, miny = 3, maxx = global.zone_width - 4, maxy = global.zone_height - 4;
	var cx, cy;
	do {
		cx = irandom_range(minx, maxx);
		cy = irandom_range(miny, maxy);
	} until (distance_nearest_location(cx, cy, z) > 5);
	var ev = new location(z, cx, cy, location_type.event);
	ev.zone_id = z;
	ds_list_add(z.locations, ev);
	return ev;
}

function derelict_populate_stats(z, struct) {
	switch (z.security) {
		case zone_security.lawless:
			struct.size = choose_weighted(location_size.large, 3, location_size.medium, 4, location_size.small, 1);
			struct.resources = random(1) < 0.3 ? 1 : random_range(0.7, 1.0); break;
		case zone_security.little:
			struct.size = choose_weighted(location_size.large, 2, location_size.medium, 5, location_size.small, 3);
			struct.resources = random(1) < 0.2 ? 1 : random_range(0.5, 1.0); break;
		case zone_security.sparse:
			struct.size = choose_weighted(location_size.large, 1, location_size.medium, 3, location_size.small, 5);
			struct.resources = random(1) < 0.1 ? 1 : random_range(0.4, 0.9); break;
		case zone_security.moderate:
			struct.size = choose_weighted(location_size.medium, 2, location_size.small, 5);
			struct.resources = random(1) < 0.1 ? 1 : random_range(0.4, 0.9); break;
		case zone_security.high:
			struct.size = choose_weighted(location_size.medium, 1, location_size.small, 4);
			struct.resources = random(1) < 0.1 ? 1 : random_range(0.2, 0.8); break;
		default: break;
	}
}

function place_derelict(z) {
	// Do not place derelicts within 3 tiles of the map edge
	var minx = 3, miny = 3, maxx = global.zone_width - 4, maxy = global.zone_height - 4;
	var cx, cy;
	do {
		cx = irandom_range(minx, maxx);
		cy = irandom_range(miny, maxy);
	} until (distance_nearest_location(cx, cy, z) > 5);
	var d = new location(z, cx, cy, location_type.derelict);
	derelict_populate_stats(z, d);
	d.zone_id = z;
	ds_list_add(z.locations, d);
	return d;
}

function comet_populate_stats(z, struct) {
	switch (z.security) {
		case zone_security.lawless:
			struct.size = choose_weighted(location_size.large, 3, location_size.medium, 4, location_size.small, 1);
			struct.resources = random(1) < 0.3 ? 1 : random_range(0.7, 1.0); break;
		case zone_security.little:
			struct.size = choose_weighted(location_size.large, 2, location_size.medium, 5, location_size.small, 3);
			struct.resources = random(1) < 0.2 ? 1 : random_range(0.5, 1.0); break;
		case zone_security.sparse:
			struct.size = choose_weighted(location_size.large, 1, location_size.medium, 3, location_size.small, 5);
			struct.resources = random(1) < 0.1 ? 1 : random_range(0.4, 0.9); break;
		case zone_security.moderate:
			struct.size = choose_weighted(location_size.medium, 2, location_size.small, 5);
			struct.resources = random(1) < 0.1 ? 1 : random_range(0.4, 0.9); break;
		case zone_security.high:
			struct.size = choose_weighted(location_size.medium, 1, location_size.small, 4);
			struct.resources = random(1) < 0.1 ? 1 : random_range(0.2, 0.8); break;
		default: break;
	}
}

function place_comet(z) {
	// Do not place derelicts within 3 tiles of the map edge
	var minx = 3, miny = 3, maxx = global.zone_width - 4, maxy = global.zone_height - 4;
	var cx, cy;
	do {
		cx = irandom_range(minx, maxx);
		cy = irandom_range(miny, maxy);
	} until (distance_nearest_location(cx, cy, z) > 5);
	var c = new location(z, cx, cy, location_type.comet);
	comet_populate_stats(z, c);
	c.zone_id = z;
	ds_list_add(z.locations, c);
	return c;
}

// Initialize a zone based on that zone's security level.
// More secure zones will have more seettlements and less pirates
function zone_init(z) {
	var security_level = z.security;
	var num_settlements = 1;
	var num_pirates = 1;
	switch (security_level) {
		case zone_security.high: num_settlements = irandom_range(2, 3); num_pirates = 0; break;
		case zone_security.moderate: num_settlements = irandom_range(1, 3); num_pirates = choose(0, 1, 1); break;
		case zone_security.sparse: num_settlements = choose(0, 1, 1, 1); num_pirates = choose(2, 1, 1, 0); break;
		case zone_security.little: num_settlements = choose(0, 1, 1); num_pirates = choose(2, 2, 1, 1); break;
		case zone_security.lawless: num_settlements = choose(0, 1); num_pirates = choose(3, 3, 2, 2, 2, 1); break;
	}
	repeat (num_settlements) {
		place_settlement(z);
	}
	repeat (num_pirates) {
		place_pirate_base(z);
	}
	repeat (irandom_range(15, 20)) {
		place_event(z);
	}
}

// Create a zone from a stored zone struct
// If is_loaded is true, this is from a loaded file or initial game start. Else, set the coordinates as destination coords.
// This also performs some bookkeeping like updating contract stages.
function zone_create(z, is_loaded = true) {
	var cont = instance_create(0, 0, o_controller_zonemap);
	//generate zone connections
	var connections = zone_get_connections(z);
	for (var i = 0; i < array_length(connections); i++) {
		var cnx = connections[i];
		var coords = zone_get_connection_coordinates(z, cnx);
		for (var j = 0; j < array_length(coords); j++) {
			get_hex_coord(coords[j][0], coords[j][1]).connection = cnx[0];
		}
	}
	var hex;
	var dir = DIR_NORTH;
	if (is_loaded) {
		hex = cont.hex_array[global.player_x][global.player_y];
	} else {
		global.player_x = global.zone_transition_coords[0];
		global.player_y = global.zone_transition_coords[1];
		hex = cont.hex_array[global.player_x][global.player_y];
		dir = o_sr_zone_transition.dir;
	}
	global.player = instance_create(hex.x, hex.y, o_player);
	if (!is_loaded) {
		var d = direction_get_angle(dir);
		global.player.image_angle = d;
		var dist = 2500;
		global.player.x -= lengthdir_x(dist, d);
		global.player.y -= lengthdir_y(dist, d);
		global.player.exit_burst = false;
		global.player.image_index = 1;
	}
	global.player.struct = global.player_ship;
	global.player.combat_power = ai_local_calculate_power(global.player);
	global.player.jump_range = ship_get_jumprange(global.player_ship);
	update_vision(hex, global.player.sensor_range, global.player);
	global.player.pathable_hexes = get_pathable_hexes(hex, global.player.jump_range, global.player);
	//instance_create(0, 0, o_zone_hex_renderer);
	instance_create(0, 0, o_zonemap_bgrenderer);
	if (!instance_exists(o_camera)) {
		instance_create(0, 0, o_camera);
	} else {
		global.camera.x = global.player.tx;
		global.camera.y = global.player.ty;
	}
	for (var i = 0; i < ds_list_size(z.locations); i++) {
		var loc = z.locations[|i];
		var o = location_create(loc, cont);
		loc.obj = o;
	}
	var num_travellers = 0;
	switch (z.security) {
		case zone_security.high: num_travellers = choose(3, 4, 4, 4, 5); break;
		case zone_security.moderate: num_travellers = choose(3, 3, 4); break;
		case zone_security.sparse: num_travellers = choose(1, 2, 2, 3); break;
		case zone_security.little: num_travellers = choose(1, 1, 2); break;
		case zone_security.lawless: num_travellers = choose(0, 0, 1); break;
	}
	repeat(num_travellers) {
		generate_traveller(true);
	}
	
	if (global.current_contract != noone) {
		var cnt = global.current_contract;
		// Entering a new zone means on any contract with a stage to travel there will update.
		// If a zone is already the target zone, leaving will always revert the contract stage.
		if (cnt.target_zone == z.index && ((cnt.type == contract_type.bounty && cnt.stage == 0) ||
		      (cnt.type == contract_type.delivery && cnt.stage == 0) ||
			  (cnt.type == contract_type.courier && cnt.stage == 0) ||
			  (cnt.type == contract_type.hunting && cnt.stage == 0) ||
			  (cnt.type == contract_type.fulfillment && cnt.stage == 1))) {
			cnt.stage++;
		} else if ((cnt.type == contract_type.bounty && cnt.stage == 1) ||
		      (cnt.type == contract_type.delivery && cnt.stage == 1) ||
			  (cnt.type == contract_type.courier && cnt.stage == 1) ||
			  (cnt.type == contract_type.hunting && cnt.stage == 1) ||
			  (cnt.type == contract_type.fulfillment && cnt.stage == 2)) {
			cnt.stage--;
		}
		
		// If this is a bounty contract in this zone, generate the bounty ship
		if (cnt.type == contract_type.bounty && cnt.stage == 1) {
			var bounty = ai_create_ship_patrol(cnt.target_faction, get_hex_coord(cnt.target_hex[0], cnt.target_hex[1]), 10);
			bounty.is_bounty_target = true;
			delete bounty.ship_struct;
			bounty.ship_struct = cnt.ship_struct;
		}
	}
	
	var fade = instance_create(0, 0, o_fx_fadein);
	if (is_loaded) {
		fade.color = c_black;
	}
}

// Get the hex of an arbitrary location
function get_hex(xx, yy) {
	// The furthest a hex can be while still being the active one is sprite_width/2+1
	var maxw = (sprite_get_width(s_zonemap_hex) / 2) + 1;
	with(o_zonemap_hex) {
		if (abs(xx - x) <= maxw && abs(yy - y) <= maxw) {
			if(position_meeting(xx, yy, id)) {
				return id;
			}
		}
	}
	return noone;
}

// Determine if the mouse is over a hex and, if so, return that hex object
function mouse_get_hex() {
	return get_hex(mouse_x, mouse_y);
}

// Get an array of up to 6 adjacent hexes for a given hex.
function hex_get_adjacent(hex) {
	if (!instance_exists(o_controller_zonemap)) {
		return [];
	}
	var xx = hex.gx, yy = hex.gy;
	var yoffset = 0;
	if (xx % 2 == 1) {
		yoffset = 1;
	} else {
		yoffset = -1;
	}
	var check = [[xx, yy-1], [xx, yy+1], [xx+1, yy], [xx-1, yy], [xx+1, yy + yoffset], [xx-1, yy + yoffset]];
	var arr = [];
	for (var i = 0; i < array_length(check); i++) {
		if(check[i][0] >= 0 && check[i][0] < global.zone_width &&
		   check[i][1] >= 0 && check[i][1] < global.zone_height) {
		  array_push(arr, o_controller_zonemap.hex_array[check[i][0]][check[i][1]]);
	    }
	}
	return arr;
}

function ds_list_find_array(list, arr) {
	for(var i = 0; i < ds_list_size(list); i++) {
		if(array_equals(arr, list[|i])) {
			return i;
		}
	}
	return -1;
}

function apply_terrain_floodfill(arr, type, sx, sy, spread_chance, max_size) {
	var open = ds_list_create();
	var closed = ds_list_create();
	ds_list_add(open, [sx, sy]);
	var size = 0;
	while(ds_list_size(open) > 0 && size < max_size) {
		var xx = open[|0][0];
		var yy = open[|0][1];
		var hex = [xx, yy];
		arr[@ xx][@ yy] = type;
		ds_list_add(closed, hex);
		ds_list_delete(open, ds_list_find_array(open, hex));
		size++;
		var yoffset = 0;
		if (xx % 2 == 1) {
			yoffset = 1;
		} else {
			yoffset = -1;
		}
		var adj = [[xx, yy-1], [xx, yy+1], [xx+1, yy], [xx-1, yy], [xx+1, yy + yoffset], [xx-1, yy + yoffset]];
		for (var i = 0; i < array_length(adj); i++) {
			// add adjacent hexes (maybe)
			if(random(1) > spread_chance) {
				continue;
			}
			var this_hex = adj[i];
			if(adj[i][0] < 0 || adj[i][0] >= global.zone_width || adj[i][1] < 0 || adj[i][1] >= global.zone_height) {
				continue;
			}
			var f = max(-1, ds_list_find_array(open, this_hex), ds_list_find_array(closed, this_hex));
			if (f == -1) {
				ds_list_add(open, this_hex);
			}
		}
	}
		
	ds_list_destroy(open);
	ds_list_destroy(closed);
}

function apply_terrain_floodfill_hex(type, start, spread_chance, max_size) {
	var open = ds_list_create();
	var closed = ds_list_create();
	ds_list_add(open, start);
	var size = 0;
	while(ds_list_size(open) > 0 && size < max_size) {
		var hex = open[|0];
		hex.type = type;
		ds_list_add(closed, hex);
		ds_list_delete(open, ds_list_find_index(open, hex));
		size++;
		var adj = hex_get_adjacent(hex);
		for (var i = 0; i < array_length(adj); i++) {
			// add adjacent hexes (maybe)
			if(random(1) > spread_chance) {
				continue;
			}
			var this_hex = adj[i];
			var f = max(-1, ds_list_find_index(open, this_hex), ds_list_find_index(closed, this_hex));
			if (f == -1) {
				ds_list_add(open, this_hex);
			}
		}
	}
		
	ds_list_destroy(open);
	ds_list_destroy(closed);
}

// If the player is the one doing this vision check, mark those hexes as in vision and explored.
// Otherwise, add them do a vision list and return it.
function vision_recur(hex, range_rem, start_hex, seen, player_vision = true, vlist = []) {
	if (player_vision) {
		hex.vision = true;
		hex.explored = true;
	}
	array_push(vlist, hex);
	if(hex.vision_cost > 1 && hex != start_hex) {
		range_rem -= hex.vision_cost - 1;
	}
	ds_map_add(seen, hex, range_rem);
	if (range_rem > 0) {
		var adj = hex_get_adjacent(hex);
		for (var i = 0; i < array_length(adj); i++) {
			var next_hex = adj[i];
			if (!ds_map_exists(seen, next_hex)) {
				vision_recur(adj[i], range_rem-1, start_hex, seen, player_vision, vlist);
			} else {
				if (seen[? next_hex] < range_rem-1) {
					seen[? next_hex] = range_rem-1;
					vision_recur(adj[i], range_rem-1, start_hex, seen, player_vision, vlist);
				}
			}
		}
	}
	// This will run very last in the recurrence
	if (hex == start_hex) {
		if(player_vision) {
			global.player.visible_hexes = vlist;
		} else {
			return vlist;
		}
	}
}

function update_vision(start, range, sh) {
	var seen = ds_map_create();
	if (sh.object_index == o_player) {
		with(o_zonemap_hex) {
			vision = false;
		}
		sh.visible_hexes = [];
		vision_recur(start, range, start, seen, true, []);
	} else {
		sh.visible_hexes = [];
		sh.visible_hexes = vision_recur(start, range, start, seen, false, []);
	}
	ds_map_destroy(seen);
}

function path_recur(hex, range_rem, start_hex, seen, sh, plist = []) {
	if(hex.movement_cost >= 0 && !ds_map_exists(seen, hex) && array_find(sh.visible_hexes, hex) >= 0) {
		array_push(plist, hex);
		ds_map_add(seen, hex, "");
	}
	if(hex.movement_cost > 1 && hex != start_hex) {
		range_rem -= hex.movement_cost - 1;
	}
	if (range_rem > 0) {
		var adj = hex_get_adjacent(hex);
		for (var i = 0; i < array_length(adj); i++) {
			path_recur(adj[i], range_rem-1, start_hex, seen, sh, plist);
		}
	}
	// This will run very last in the recurrence
	if (hex == start_hex) {
		return plist;
	}
}

// Returns a ds_list of hexes which are pathable and in a certain travel distance of the target.
// This should always be called after updated vision is established. A ship can never travel past
function get_pathable_hexes(start, range, sh) {
	var seen = ds_map_create();
	var hexes = path_recur(start, range, start, seen, sh);
	ds_map_destroy(seen);
	return hexes;
}

function ship_update(sh) {
	update_vision(sh.hex, sh.sensor_range, sh);
	sh.pathable_hexes = get_pathable_hexes(sh.hex, sh.jump_range, sh);
}

// These two functions activate and deactivate all zonemap objects, respectively. Useful for going to different contexts.
function zonemap_activate_objects() {
	instance_activate_object(o_zonemap_hex);
	instance_activate_object(par_ship_zonemap);
	instance_activate_object(o_zonemap_location);
	instance_activate_object(o_controller_zonemap);
	instance_activate_object(o_zonemap_bgrenderer);
	with (o_controller_zonemap) {
		instance_activate_object(location_prompt_button);
	}
}

function zonemap_deactivate_objects() {
	instance_deactivate_object(o_zonemap_hex);
	instance_deactivate_object(par_ship_zonemap);
	instance_deactivate_object(o_zonemap_location);
	with (o_controller_zonemap) {
		location_prompt_button.y = GUIH;
		instance_deactivate_object(location_prompt_button);
	}
	instance_deactivate_object(o_controller_zonemap);
	instance_deactivate_object(o_zonemap_bgrenderer);
}

function hex_is_pathable(sh, hex) {
	return (array_find(sh.pathable_hexes, hex) >= 0);
}

function ship_get_cooccupant(sh) {
	with (par_ship_zonemap) {
		if (id != sh && sh.hex = hex) {
			return id;
		}
	}
	return noone;
}

function draw_self_ship() {
	var sz = 64;
	var surf = surface_create(sz*2, sz*2)
	surface_clear(surf);
	surface_set_target(surf);
	// gpu_set_tex_filter(true);
	var col = [0.8, 0.8, 0.8];
	if (faction == factions.player) {
		col = [1, 1, 1];
	} else if (factions_are_enemies(factions.player, faction)) {
		col = [0.8, 0, 0];
	} else if (factions_are_allies(factions.player, faction)) {
		col = [0, 0.8, 0];
	}else {
		col = [0.5, 0.5, 0.5];
	}
	shader_set(sh_to_color);
	var u_col = shader_get_uniform(sh_to_color, "colors");
	var u_alpha = shader_get_uniform(sh_to_color, "draw_alpha");
	shader_set_uniform_f_array(u_col, col);
	shader_set_uniform_f(u_alpha, image_alpha);
	var occ = noone;
	if (dif(x, tx) < 32 && dif(y, ty) < 32) {
		occ = ship_get_cooccupant(id);
		if (occ != noone && (dif(occ.x, occ.tx) >= 32 || dif(occ.y, occ.ty) >= 32)) {
			occ = noone;
		}
	}
	if (occ == noone) {
		x_display = x;
		y_display = y;
		draw_sprite_ext(sprite_index, image_index, sz, sz, image_xscale, image_yscale, image_angle, c_white, image_alpha);
	} else { // If we share a space, draw the sprite orbiting the other ship.
		var angle = ((360 * get_timer()) / (6 * 1000000)) % 360;
		if (id > occ.id) {
			angle += 180;
			angle %= 360;
		}
		var xpos = sz + lengthdir_x(sz/3, angle);
		var ypos = sz + lengthdir_y(sz/3, angle);
		x_display = x - sz + xpos;
		y_display = y - sz + ypos;
		draw_sprite_ext(sprite_index, image_index, xpos, ypos, image_xscale, image_yscale, angle + 90, c_white, image_alpha);
	}
	shader_reset();
	surface_reset_target();
	draw_outline_surface(surf, x-sz, y-sz, image_alpha);
	draw_surface(surf, x-sz, y-sz);
	surface_free(surf);
	// gpu_set_tex_filter(false);
}

function ship_destroy_zonemap(sh) {
	// Check if this is a bounty target or of the faction of a hunting contract and update stage appropriately
	var cnt = global.current_contract;
	if (cnt.type == contract_type.bounty && sh.is_bounty_target) {
		cnt.stage++;
	} else if (cnt.type == contract_type.hunting && sh.faction == cnt.target_faction && 
	           cnt.current_number < cnt.target_number && (cnt.target_zone == noone || cnt.target_zone == global.current_zone)) {
		cnt.current_number++;
		if (cnt.current_number == cnt.target_number) {
			cnt.stage++;
		}
	}
	
	delete sh.ship_struct;
	instance_destroy(sh);
	with (o_zonemap_hex) {
		contained_ship = noone;// This will be reestablished later
	}
	with (par_ship_zonemap) {
		if (id == sh) {
			continue;
		}
		hex.contained_ship = id;
		if (id != global.player && target == sh) {
			ai_ship_behavior_default(id);
			target = noone;
		}
	}
}

// Get a hex by its hex grid coordinates
function get_hex_coord(gx, gy) {
	with(o_controller_zonemap) {
		if (gx >= 0 && gx < global.zone_width && gy >= 0 && gy < global.zone_height) {
			return hex_array[gx][gy];
		}
	}
	return noone;
}

function zone_get_locations_of_type(type, z = zone_get_current()) {
	var arr = [];
	for (var i = 0; i < ds_list_size(z.locations); i++) {
		var loc = z.locations[|i];
		if (loc.type = type) {
			array_push(arr, loc);
		}
	}
	return arr;
}

// Returns true if there is at least one settlement in an area, otherwise false
function settlement_exists(z = zone_get_current()) {
	return array_length(zone_get_locations_of_type(location_type.settlement)) > 0;
}

// Create a contextmenu with the given object
function contextmenu_create(xx, yy, target) {
	var ctxt = instance_create(mouse_x, mouse_y, o_zonemap_contextmenu);
	ctxt.target = target;
	return ctxt;
}

// Load the hailing dialogue for a given faction
function zonemap_hail_ship(sh) {
	var fname = "dlg_hail_";
	fname += faction_get_prefix(sh.faction) + "_";
	var rel = faction_get_relation(sh.faction);
	if (rel < global.faction_relation_thresholds[faction_relation_level.unwelcome]) {
		fname += "hostile";
	} else if (rel < global.faction_relation_thresholds[faction_relation_level.neutral]) {
		fname += "wary";
	} else if (rel < global.faction_relation_thresholds[faction_relation_level.trusted]) {
		fname += "neutral";
	} else {
		fname += "wary";
	}
	if (!file_exists(fname)) {
		fname = "dlg_hail_civilian_neutral";
	}
	fname += ".txt";
	dsys_initialize_window(fname);
}