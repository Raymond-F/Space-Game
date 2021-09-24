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

function zone(_s, _e, _outer, _inner, _cx, _cy) constructor {
	// Creation variables
	s = _s;
	e = _e;
	outer = _outer;
	inner = _inner;
	cx = _cx;
	cy = _cy;
	
	// Other variables
	security = zone_security.high;
	index = 0;
	locations = ds_list_create(); // A list of locations that are persistent
	last_visited = -1; // The last in-game cycle in which this zone was visited. Negative means never.
	terrain = array_create(global.zone_width);
	for(var i = 0; i < global.zone_width; i++) {
		terrain[i] = array_create(global.zone_height);
	}
	zone_place_terrain(self, 10);
	
	destroy = function() {
		ds_list_destroy(locations);
	}
}

function sector_map_init() {
	var map = ds_map_create();
	var segments_made = 0;
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
			var z = new zone(sa, ea, dist + thickness, dist, GUIW/2, GUIH*3/4 + base_dist);
			z.index = segments_made;
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