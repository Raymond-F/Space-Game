// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// Type of location in zone map
enum location_type {
	settlement,
	pirate_base,
	event
}

// Size of settlement
enum settlement_size {
	small,
	medium,
	large
}

function location(_gx, _gy, _type) constructor {
	gx = _gx;
	gy = _gy;
	type = _type;
	img_index = 0; // Used for locations with multiple possible sprites
	size = settlement_size.small; // Used for settlements and possibly pirate bases
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
		case zone_security.high: size_weighting = [settlement_size.large, settlement_size.large, settlement_size.medium, settlement_size.medium, settlement_size.small]; break;
		case zone_security.moderate: size_weighting = [settlement_size.large, settlement_size.medium, settlement_size.medium, settlement_size.small, settlement_size.small, settlement_size.small]; break;
		case zone_security.sparse: size_weighting = [settlement_size.medium, settlement_size.small]; break;
		case zone_security.little: size_weighting = [settlement_size.medium, settlement_size.medium, settlement_size.small]; break;
		case zone_security.lawless: size_weighting = [settlement_size.small]; break;
		default: size_weighting = [settlement_size.small]; break;
	}
	set.size = array_choose(size_weighting);
	set.img_index = irandom(sprite_get_number(s_zonemap_pirate_base_small));
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
		case zone_security.lawless: size_weighting = [settlement_size.large, settlement_size.large, settlement_size.medium, settlement_size.medium, settlement_size.small]; break;
		case zone_security.little: size_weighting = [settlement_size.large, settlement_size.medium, settlement_size.medium, settlement_size.small, settlement_size.small, settlement_size.small]; break;
		case zone_security.sparse: size_weighting = [settlement_size.medium, settlement_size.small]; break;
		case zone_security.moderate: size_weighting = [settlement_size.medium, settlement_size.medium, settlement_size.small]; break;
		case zone_security.high: size_weighting = [settlement_size.small]; break;
		default: size_weighting = [settlement_size.small]; break;
	}
	base.size = array_choose(size_weighting);
	base.img_index = irandom(sprite_get_number(s_zonemap_settlement_small));
	ds_list_add(z.locations, base);
	return base;
}

function place_event(z) {
	// Do not place settlements within 3 tiles of the map edge
	var minx = 3, miny = 3, maxx = global.zone_width - 4, maxy = global.zone_height - 4;
	var cx, cy;
	do {
		cx = irandom_range(minx, maxx);
		cy = irandom_range(miny, maxy);
	} until (distance_nearest_location(cx, cy, z) > 5);
	var ev = new location(cx, cy, location_type.event);
	ds_list_add(z.locations, ev);
	return ev;
}

// Initialize a zone based on that zone's security level.
// More secure zones will have more seettlements and less pirates
function zone_init(z) {
	var security_level = z.security;
	var num_settlements = 1;
	var num_pirates = 1;
	switch (security_level) {
		case zone_security.high: num_settlements = irandom_range(2, 4); num_pirates = 0; break;
		case zone_security.moderate: num_settlements = irandom_range(2, 3); num_pirates = choose(0, 1, 1); break;
		case zone_security.sparse: num_settlements = irandom_range(1, 2); num_pirates = choose(2, 1, 1, 0); break;
		case zone_security.little: num_settlements = choose(1, 1, 2); num_pirates = choose(2, 2, 1, 1); break;
		case zone_security.lawless: num_settlements = choose(0, 1, 1); num_pirates = choose(3, 3, 2, 2, 2, 1); break;
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
	instance_create(0, 0, o_camera);
	for (var i = 0; i < ds_list_size(z.locations); i++) {
		var loc = z.locations[|i];
		location_create(loc, cont);
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
	vision_recur(start, global.sensor_range, start);
}