/// @description Insert description here
// You can write your code in this editor
if (!explored && !global.debug) {
	exit;
}

var terrain_spr = noone;
switch(type) {
	case hex_type.dust : terrain_spr = s_zonemap_hexdust; break;
	default: terrain_spr = noone;
}
if (terrain_spr != noone) {
	draw_sprite(terrain_spr, 0, x, y);
}
draw_self();

if(!vision) {
	draw_set_alpha(0.2);
	draw_sprite(s_zonemap_oov_hex, 0, x, y);
	draw_set_alpha(1);
}

if(vision && loc != noone && loc.type == location_type.settlement) {
	var spr = s_zonemap_settlement;
	draw_sprite(spr, 0, x, y);
}

// Debug display for whether this hex contains a ship
if(global.debug && contained_ship != noone) {
	draw_set_alpha(0.4);
	draw_set_color(c_white);
	draw_circle(x, y, 16, false);
	draw_set_alpha(1);
}