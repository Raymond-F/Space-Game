/// @description Insert description here
// You can write your code in this editor
depth = -50;
var z = global.sector_map[? global.current_zone];
ai_turn = false;
turn_init = false;
ai_delay = 0;
turn_order = [];
turn_index = 0;
enum ai_states {
	scan = 0,
	move = 1,
}
state = ai_states.scan;

// Actions a player will take upon arrival when they travel to a hex
enum player_actions {
	nothing = 0,
	hail = 1,
	attack = 2
}
player_action = player_actions.nothing;


location_prompt_refresh = function() {
	location_prompt_button.active = true;
	var loc_at_hex = noone;
	if (global.player.hex.on_edge) {
		location_prompt_setinfo_edge(global.player.hex);
		return;
	}
	with (o_zonemap_location) {
		if (hex == other.player_hex) {
			loc_at_hex = id;
		}
	}
	location_prompt_setinfo(loc_at_hex);
}

// Set the location prompt for an edge transit
location_prompt_setinfo_edge = function(hex) {
	location_prompt_button.text = "JUMP";
	if (hex.connection != noone) {
		var z = global.sector_map[? hex.connection];
		location_prompt_name = z.name;
		location_prompt_text = z.description;
	} else if (hex.gy == 0) {
		location_prompt_button.active = false;
		location_prompt_name = "Oort Cloud";
		location_prompt_text = "No captain has ever travelled beyond here and returned. Only fools or madmen venture beyond.";
	} else if (hex.gy == global.zone_height-1) {
		location_prompt_button.active = false;
		location_prompt_name = "Empire Territory";
		location_prompt_text = "Only Imperial ships or those rare few Kippers who have been granted passage are allowed further into the system. Running the border has a low success rate, to put it lightly.";
	} else {
		location_prompt_button.active = false;
		location_prompt_name = "Uncharted Space";
		location_prompt_text = "This piece of the belt is hazardous, turbulent, and elsewise inimicable to travel. There's nothing here for you.";
	}
}

// Set the location prompt for a location
location_prompt_setinfo = function(loc) {
	if (loc == noone) {
		location_prompt_name = "";
		location_prompt_text = "";
		location_prompt_button.text = "";
	} else {
		location_prompt_name = loc.struct.name;
		location_prompt_text = loc.struct.tip_text;
		location_prompt_button.text = loc.struct.prompt_text;
	}
}

set_ship_dest = function(sh, hex) {
	var start = sh.hex;
	sh.tx = hex.x;
	sh.ty = hex.y;
	sh.hex.contained_ship = noone;
	if (global.player.hex == sh.hex) {
		sh.hex.contained_ship = global.player;
	}
	sh.hex = hex;
	hex.contained_ship = sh;
	sh.exit_burst = false;
	if (start.vision) {
		var burst = instance_create(sh.x, sh.y, o_zonemap_impulse_burst_fx);
		burst.depth = sh.depth-1;
		sh.image_index = 1;
	}
	update_vision(hex, sh.sensor_range, sh);
	sh.pathable_hexes = get_pathable_hexes(hex, sh.jump_range, sh);
}

set_player_dest = function(hex) {
	global.player.tx = hex.x;
	global.player.ty = hex.y;
	global.player_x = global.player.tx;
	global.player_y = global.player.ty;
	global.camera.follow = true;
	global.camera.target = global.player;
	global.player.hex.contained_ship = noone;
	with (o_ship_zonemap) {
		if (global.player.hex == hex) {
			hex.contained_ship = id;
			break;
		}
	}
	global.player.hex = hex;
	player_hex = global.player.hex;
	global.player.hex.contained_ship = global.player;
	update_vision(hex, global.player.sensor_range, global.player);
	global.player.pathable_hexes = get_pathable_hexes(hex, global.player.jump_range, global.player);
	location_prompt_y = GUIH;
	location_prompt_refresh();
	// Player fx
	global.player.exit_burst = false;
	var burst = instance_create(global.player.x, global.player.y, o_zonemap_impulse_burst_fx);
	burst.depth = global.player.depth-1;
	global.player.image_index = 1;
}

player_move = function(hex, action = player_actions.nothing) {
	targeted_hex = hex;
	set_player_dest(hex);
	player_action = action;
	global.player.action = action;
	global.player.action_delay = 30;
	global.current_turn++;
	if (action == player_actions.nothing) {
		ai_delay = 30;
	} else if (action == player_actions.hail) {
		ai_delay = 60;
	} else {
		ai_delay = 120;
	}
	ai_turn = true;
	pcontrol = false;
	pcontrol_timer = 30;
	targeted_hex = noone;
	var s = audio_play_sound(snd_pulsestart, 30, false);
	audio_sound_pitch(s, random_range(0.6, 0.8));
}

turn_end = function() {
	turn_init = false;
	ai_turn = false;
	pcontrol = true;
	zone_update(zone_get_current());
}

hex_array = array_create(global.zone_width);
selected_hex = noone;
targeted_hex = noone;
player_hex = noone;
for (var i = 0; i < global.zone_width; i++) {
	hex_array[i] = array_create(global.zone_height);
}
pcontrol = true;
pcontrol_timer = -1;

ship_registry = ds_list_create();
turn_order = [];
turn_index = 0;


wait_indicator_alpha = 0;

// For camera constraints
var l = 99999, r = 0, t = 99999, b = 0;

var csize = sprite_get_width(s_zonemap_hex);
var base_offset = csize/2;
for(var i = 0; i < global.zone_width; i++) {
	for (var j = 0; j < global.zone_height; j++) {
		var xpos = base_offset + i * csize * 3/4;
		var ypos = base_offset + j * csize;
		if(i % 2 == 1) {
			ypos += csize/2;
		}
		var hex = instance_create(xpos, ypos, o_zonemap_hex);
		l = min(xpos, l);
		r = max(xpos, r);
		t = min(ypos, t);
		b = max(ypos, b);
		hex.gx = i;
		hex.gy = j;
		hex.type = z.terrain[i][j];
		switch(hex.type) {
			case hex_type.dust : hex.vision_cost = 3; break;
		}
		hex.explored = z.explored[i][j];
		hex_array[i][j] = hex;
	}
}

global.camera_constraints = [l + VIEW_WIDTH*2/5, t + VIEW_HEIGHT*2/5, r - VIEW_WIDTH*2/5, b - VIEW_HEIGHT*2/5];

location_prompt_y = GUIH;
location_prompt_x = GUIW/2 - sprite_get_width(s_location_prompt)/2;
location_prompt_button = instance_create(GUIW/2 - sprite_get_width(s_button_large)/2, GUIH, o_button);
location_prompt_button.on_press = function() {
	if (location_prompt_button.text == "") {
		return;
	}
	if (global.player.hex.connection != noone) {
		var h = global.player.hex;
		var cnx = global.sector_map[? h.connection];
		var dir;
		// vertical
		if (h.gx > 0 && h.gx < global.zone_width-1) {
			dir = h.gy == 0 ? DIR_NORTH : DIR_SOUTH;
		} else { // horizontal
			dir = h.gx == 0 ? DIR_WEST : DIR_EAST;
		}
		global.zone_transition_coords = zone_transition_get_corresponding_hex(zone_get_current(), h, cnx, dir);
		global.target_zone = h.connection;
		global.player.image_angle = dir * 90;
		begin_transition(dir);
		
		return;
	}
	with (o_zonemap_location) {
		if (hex == global.player.hex) {
			struct.interact();
			if (type == location_type.event) {
				global.event_current_object = id;
			}
			break;
		}
	}
}
location_prompt_button.sprite_index = s_button_large;
location_prompt_button.depth = depth - 1;
location_prompt_setinfo(noone);

begin_transition = function(dir) {
	var trans = instance_create(global.player.x, global.player.y, o_sr_zone_transition_charge);
	trans.dir = dir;
	pcontrol = false;
	location_prompt_text = "";
	zone_get_current().last_visited = global.current_turn;
	audio_play_sound(snd_transition_charge, 51, false);
}

zone_transition = function(z) {
	// Copy explored values
	var cur = zone_get_current();
	with (o_zonemap_hex) {
		if (explored) {
			cur.explored[gx][gy] = true;
		}
	}
	
	// Destroy local zone objects, including this at the end.
	instance_destroy_all(o_zonemap_hex);
	instance_destroy_all(o_ship_zonemap);
	instance_destroy_all(o_zonemap_location);
	instance_destroy_all(o_zonemap_bgrenderer);
	instance_destroy(location_prompt_button);
	instance_destroy_all(o_player);
	
	instance_create(0, 0, o_sr_zone_transition);
	o_sr_zone_transition.dir = o_sr_zone_transition_charge.dir;
	
	instance_destroy();
}