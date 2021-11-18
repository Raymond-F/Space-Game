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