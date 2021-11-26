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


location_prompt_refresh = function() {
	var loc_at_hex = noone;
	with (o_zonemap_location) {
		if (hex == other.player_hex) {
			loc_at_hex = id;
		}
	}
	location_prompt_setinfo(loc_at_hex);
}

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
	sh.tx = hex.x;
	sh.ty = hex.y;
	sh.hex.contained_ship = noone;
	sh.hex = hex;
	hex.contained_ship = sh;
	sh.exit_burst = false;
	if (hex.vision) {
		var burst = instance_create(sh.x, sh.y, o_zonemap_impulse_burst_fx);
		burst.depth = sh.depth-1;
		sh.image_index = 1;
	}
	update_vision(hex, sh.sensor_range, sh);
	sh.pathable_hexes = get_pathable_hexes(hex, sh.jump_range, sh);
}

set_player_dest = function() {
	global.player.tx = targeted_hex.x;
	global.player.ty = targeted_hex.y;
	global.player_x = global.player.tx;
	global.player_y = global.player.ty;
	global.camera.follow = true;
	global.camera.target = global.player;
	global.player.hex.contained_ship = noone;
	global.player.hex = targeted_hex;
	player_hex = global.player.hex;
	global.player.hex.contained_ship = global.player;
	update_vision(targeted_hex, global.player.sensor_range, global.player);
	global.player.pathable_hexes = get_pathable_hexes(targeted_hex, global.player.jump_range, global.player);
	location_prompt_y = GUIH;
	location_prompt_refresh();
	// Player fx
	global.player.exit_burst = false;
	var burst = instance_create(global.player.x, global.player.y, o_zonemap_impulse_burst_fx);
	burst.depth = global.player.depth-1;
	global.player.image_index = 1;
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
		hex_array[i][j] = hex;
	}
}

global.camera_constraints = [l + VIEW_WIDTH/4, t + VIEW_HEIGHT/4, r - VIEW_WIDTH/4, b - VIEW_HEIGHT/4];

location_prompt_y = GUIH;
location_prompt_x = GUIW/2 - sprite_get_width(s_location_prompt)/2;
location_prompt_button = instance_create(GUIW/2 - sprite_get_width(s_button_large)/2, GUIH, o_button);
location_prompt_button.on_press = function() {
	if (location_prompt_button.text == "") {
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