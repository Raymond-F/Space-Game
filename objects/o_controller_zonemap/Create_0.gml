/// @description Insert description here
// You can write your code in this editor
var z = global.sector_map[? global.current_zone];

set_player_dest = function() {
	global.player.tx = selected_hex.x;
	global.player.ty = selected_hex.y;
	global.player_x = global.player.tx;
	global.player_y = global.player.ty;
	global.camera.follow = true;
	global.camera.target = global.player;
	global.player.hex = targeted_hex;
	update_vision(targeted_hex, global.sensor_range);
	global.current_turn++;
	pcontrol = false;
	pcontrol_timer = 30;
}

hex_array = array_create(global.zone_width);
selected_hex = noone;
targeted_hex = noone;
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