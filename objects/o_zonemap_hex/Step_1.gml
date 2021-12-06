/// @description Insert description here
// You can write your code in this editor
if (!setup) {
	setup = true;
	if(gx == 0 || gy == 0 || gx == global.zone_width-1 || gy == global.zone_height-1) {
		sprite_index = s_zonemap_hexedge;
		on_edge = true;
		if (connection == noone) {
			image_index = 1;
		}
	}
	depth = -y;
}