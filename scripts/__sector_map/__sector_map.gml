// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum zone_security {
	lawless = 0,
	little = 1,
	sparse = 2,
	moderate = 3,
	high = 4
}

function zone_place_terrain(z, num_dustcloud) {
	repeat(num_dustcloud) {
		var xx = irandom_range(0, global.zone_width-1);
		var yy = irandom_range(0, global.zone_height-1);
		apply_terrain_floodfill(z.terrain, hex_type.dust, xx, yy, 0.5, irandom_range(25, 55));
	}
}

function zone(_s, _e, _outer, _inner, _cx, _cy, _total_angle, _layer) constructor {
	// Creation variables
	s = _s;
	e = _e;
	outer = _outer;
	inner = _inner;
	cx = _cx;
	cy = _cy;
	total_angle = _total_angle;
	ring_layer = _layer;
	
	// Other variables
	security = zone_security.high;
	index = 0;
	name = "Zone ";
	description = "A large chunk of space which most folk collectively agree represents a roughly contiguous area. This one isn't particularly noteworthy.";
	locations = ds_list_create(); // A list of locations that are persistent
	last_visited = -1; // The last in-game cycle in which this zone was visited. Negative means never.
	terrain = array_create(global.zone_width);
	for(var i = 0; i < global.zone_width; i++) {
		terrain[i] = array_create(global.zone_height);
	}
	explored = array_2d_create(global.zone_width, global.zone_height, false);
	zone_place_terrain(self, 10);
	controlling_faction = factions.kfed;
	restock_timer = irandom_range(150, 200);
	
	destroy = function() {
		ds_list_destroy(locations);
	}
}

function zone_get(index) {
	return global.sector_map[? index];
}

function sector_map_init() {
	var map = ds_map_create();
	var segments_made = 0;
	// NOTE: If changing this you must also change the number of segments in global.num_sector_rings
	var segments_per_ring = [2 + irandom(1), 3 + irandom(1), 3 + irandom(2), 4 + irandom(1), 4 + irandom(1)];
	var base_dist = 1000;
	var dist = base_dist;
	var thickness = 100;
	var total_angle = 36;
	for (var i = 0; i < array_length(segments_per_ring); i++) {
		var num = segments_per_ring[i];
		var base_width = total_angle / num;
		var angles = []; // End angles for zones
		var base_security = zone_security.high - i;
		for (var j = 0; j < num; j++) {
			angles[j] = base_width * (j+1);
		}
		// Last angle cannot change
		for (var j = 0; j < num; j++) {
			if(j < num-1) {
				angles[j] = angles[j] + random_range(-2, 2);
			}
			var sa = (j == 0 ? 90 - total_angle/2 : 90 - total_angle/2 + angles[j-1]);
			var ea = 90 - total_angle/2 + angles[j];
			var z = new zone(sa, ea, dist + thickness, dist, GUIW/2, GUIH*3/4 + base_dist, total_angle, i);
			z.index = segments_made;
			z.name += string(z.index);
			var sec = base_security;
			if (random(1) < 0.25) { sec = clamp(sec+1, zone_security.lawless, zone_security.high) }
			z.security = sec;
			zone_init(z);
			ds_map_add(map, segments_made, z);
			segments_made++;
		}
		dist += thickness;
	}
	return map;
}
// Create the sector map objects from the global sector map array
function sector_map_create() {
	for (var i = 0; i < ds_map_size(global.sector_map); i++) {
		with (instance_create(0, 0, o_zone_sectormap)) {
			struct = global.sector_map[? i];
			s = struct.s;
			e = struct.e;
			outer = struct.outer;
			inner = struct.inner;
			cx = struct.cx;
			cy = struct.cy;
			index = i;
			security = struct.security;
			switch (security) {
				case zone_security.high : c_outer = $33AA33;
										  c_fill = $118811;
										  break;
				case zone_security.moderate : c_outer = $33AA77;
											  c_fill = $119955;
											  break;
				case zone_security.sparse : c_outer = $33AAAA;
											c_fill = $119999;
											break;
				case zone_security.little : c_outer = $1D94F8;
											c_fill = $0074C8;
											break;
				case zone_security.lawless : c_outer = $3333AA;
											 c_fill = $111199;
											 break;
				default: break;
			}
		}
	}
}

// Calculate the connections of each zone. Entries are in the format:
// [id, start overlap, end overlap]
// start and end overlap are done by proportion, normalized so 0 is the start angle and 1 is the end angle
function zone_get_connections(z) {
	var ret = [];
	// Get horizontal connections, as those are easiest
	if (z.s != 90 - z.total_angle/2) {
		var left = global.sector_map[? z.index-1];
		array_push(ret, [left.index, -1, -1]);
	}
	if (z.e != 90 + z.total_angle/2) {
		var right = global.sector_map[? z.index+1];
		array_push(ret, [right.index, -1, -1]);
	}
	var get_zones_in_ring = function(number) {
		var ret = [];
		for (var i = 0; i < ds_map_size(global.sector_map); i++) {
			var z = global.sector_map[? i];
			if (z.ring_layer == number) {
				array_push(ret, i);
			}
		}
		return ret;
	}
	var get_connection_array = function(z, oth) {
		var start, final;
		var z_width = z.e - z.s;
		if (oth.s <= z.s) {
			start = 0;
		} else {
			start = (oth.s - z.s)/z_width;
		}
		if (oth.e >= z.e) {
			final = 1;
		} else {
			final = ((z.e - z.s) - (z.e - oth.e))/z_width
		}
		var ret = [oth.index, start, final];
		return ret;
	}
	
	// Get outer components
	if (z.ring_layer < global.num_sector_rings - 1) {
		var zones = get_zones_in_ring(z.ring_layer + 1);
		for (var i = 0; i < array_length(zones); i++) {
			var oth = global.sector_map[? zones[i]];
			if (oth.e <= z.s || oth.s >= z.e) {
				continue;
			}
			var arr = get_connection_array(z, oth);
			array_push(ret, arr);
		}
	}
	// Get inner components
	if (z.ring_layer > 0) {
		var zones = get_zones_in_ring(z.ring_layer - 1);
		for (var i = 0; i < array_length(zones); i++) {
			var oth = global.sector_map[? zones[i]];
			if (oth.e <= z.s || oth.s >= z.e) {
				continue;
			}
			var arr = get_connection_array(z, oth);
			array_push(ret, arr);
		}
	}
	
	return ret;
}

function zone_get_connection_coordinates(z, cnx) {
	var ret = []; // This will hold coordinate tuples
	var oth = global.sector_map[? cnx[0]];
	var s = cnx[1];
	var e = cnx[2];
	var layer_dif;
	if (oth.ring_layer > z.ring_layer) {
		layer_dif = 1;
	} else if (oth.ring_layer < z.ring_layer) {
		layer_dif = -1;
	} else {
		layer_dif = 0;
	}
	if (layer_dif != 0) {
		// convert the proportion value into start/end values
		var s_coord = max(0, round(s * global.zone_width));
		var e_coord = min(global.zone_width - 1, round(e * global.zone_width)+1);
		var gy = layer_dif > 0 ? 0 : global.zone_height-1;
		for (var i = s_coord; i <= e_coord; i++) {
			array_push(ret, [i, gy]);
		}
	} else {
		var gx;
		if (oth.index < z.index) {
			gx = 0;
		} else {
			gx = global.zone_width - 1;
		}
		for (var i = 1; i < global.zone_height-1; i++) {
			array_push(ret, [gx, i]);
		}
	}
	
	return ret;
}

// Get the corresponding hex during zone transitions.
// The ship starts 1 hex from the edge in the given direction.
// Returns a coordinate tuple.
function zone_transition_get_corresponding_hex(start_zone, start_hex, target_zone, dir) {
	var tx, ty;
	// Horizontal transition is easy
	if (dir == DIR_WEST || dir == DIR_EAST) {
		if (dir == DIR_WEST) {
			tx = global.zone_width - 2;
		} else {
			tx = 1;
		}
		ty = start_hex.gy;
	} else {
		if (dir == DIR_NORTH) {
			ty = global.zone_height - 2;
		} else {
			ty = 1;
		}
		// Get proportion of overlap
		var z = start_zone;
		var oth = target_zone;
		
		var ztotal = z.e - z.s;
		var othtotal = oth.e - oth.s;
		
		var sx = start_hex.gx;
		var sx_prop = sx / (global.zone_width-1);
		var sx_angle = sx_prop * ztotal;
		var sx_total = z.s + sx_angle;
		var oth_angle = sx_total - oth.s;
		var oth_prop = oth_angle/othtotal;
		tx = clamp(round(oth_prop * global.zone_width), 1, global.zone_width - 2);
	}
	
	return [tx, ty];
}

function zone_get_random_adjacent(z) {
	return array_choose(zone_get_connections(z))[0];
}