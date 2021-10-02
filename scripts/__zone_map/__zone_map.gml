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

function location(_gx, _gy, _type) constructor {
	gx = _gx;
	gy = _gy;
	type = _type;
	obj = noone;
	img_index = 0; // Used for locations with multiple possible sprites
	size = location_size.small; // Used for settlements and possibly pirate bases
	name = ""; tip_text = ""; prompt_text = "";
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
		resources = loc.resources;
		struct = loc;
		return id;
	}
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
	var set = new location(cx, cy, location_type.settlement);
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
	var base = new location(cx, cy, location_type.settlement);
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
	base.img_index = irandom(sprite_get_number(s_zonemap_settlement_small));
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
	var ev = new location(cx, cy, location_type.event);
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
	var d = new location(cx, cy, location_type.derelict);
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
	var c = new location(cx, cy, location_type.comet);
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
function zone_create(z) {
	var cont = instance_create(0, 0, o_controller_zonemap);
	var hex = cont.hex_array[global.player_x][global.player_y];
	global.player = instance_create(hex.x, hex.y, o_player);
	update_vision(hex, global.sensor_range);
	//instance_create(0, 0, o_zone_hex_renderer);
	instance_create(0, 0, o_zonemap_bgrenderer);
	instance_create(0, 0, o_camera);
	for (var i = 0; i < ds_list_size(z.locations); i++) {
		var loc = z.locations[|i];
		var o = location_create(loc, cont);
		loc.obj = o;
	}
}

// Determine if the mouse is over a hex and, if so, return that hex object
function mouse_get_hex() {
	// The furthest a hex can be while still being the active one is sprite_width/2+1
	var maxw = (sprite_get_width(s_zonemap_hex) / 2) + 1;
	with(o_zonemap_hex) {
		if (abs(mouse_x - x) <= maxw && abs(mouse_y - y) <= maxw) {
			if(position_meeting(mouse_x, mouse_y, id)) {
				return id;
			}
		}
	}
	return noone;
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

function vision_recur(hex, range_rem, start_hex) {
	hex.vision = true;
	hex.explored = true;
	if(hex.type == hex_type.dust && hex != start_hex) {
		range_rem -= 2;
	}
	if (range_rem > 0) {
		var adj = hex_get_adjacent(hex);
		for (var i = 0; i < array_length(adj); i++) {
			vision_recur(adj[i], range_rem-1, start_hex);
		}
	}
}

function update_vision(start, range) {
	with(o_zonemap_hex) {
		vision = false;
	}
	vision_recur(start, range, start);
}

// These two functions activate and deactivate all zonemap objects, respectively. Useful for going to different contexts.
function zonemap_activate_objects() {
	instance_activate_object(o_zonemap_hex);
	instance_activate_object(o_player);
	instance_activate_object(o_zonemap_location);
	instance_activate_object(o_controller_zonemap);
	instance_activate_object(o_zonemap_bgrenderer);
}

function zonemap_deactivate_objects() {
	instance_deactivate_object(o_zonemap_hex);
	instance_deactivate_object(o_player);
	instance_deactivate_object(o_zonemap_location);
	instance_deactivate_object(o_controller_zonemap);
	instance_deactivate_object(o_zonemap_bgrenderer);
}