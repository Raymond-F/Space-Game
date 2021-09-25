/// @description Insert description here
// You can write your code in this editor
if (!explored && !global.debug) {
	exit;
}
draw_self();
if(type == hex_type.dust) {
	draw_sprite(s_zonemap_hexdust, 0, x, y);
}

if(!vision) {
	draw_set_alpha(0.3);
	draw_sprite(s_zonemap_oov_hex, 0, x, y);
	draw_set_alpha(1);
}