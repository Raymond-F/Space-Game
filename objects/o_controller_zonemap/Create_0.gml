/// @description Insert description here
// You can write your code in this editor
var z = global.sector_map[? global.current_zone];

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

set_player_dest = function() {
	global.player.tx = targeted_hex.x;
	global.player.ty = targeted_hex.y;
	global.player_x = global.player.tx;
	global.player_y = global.player.ty;
	global.camera.follow = true;
	global.camera.target = global.player;
	global.player.hex = targeted_hex;
	player_hex = global.player.hex;
	update_vision(targeted_hex, global.sensor_range);
	global.current_turn++;
	pcontrol = false;
	pcontrol_timer = 30;
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