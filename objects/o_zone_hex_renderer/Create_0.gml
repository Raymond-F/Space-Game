/// @description Insert description here
// You can write your code in this editor

/*
	NOTE: This is probably not the way to go. This makes rendering the
	hex grid and actually selecting/bounding hexes disjointed and also
	adds a lot of weird math. Will probably just create a bajillion
	hex objects programmatically and then optimize from there.
*/

surf = noone;
csize = sprite_get_width(s_zonemap_hex);

render_hexes = function() {
	var w = VIEW_WIDTH + csize * 6/4;
	var h = VIEW_HEIGHT + csize * 4;
	surf = surface_create(w, h);
	surface_set_target(surf);
	for(var xx = csize/2; xx < w; xx += csize*3/2) {
		for (var yy = csize/2; yy < h; yy += csize/2) {
			var xoffset = 0, yoffset = 0;
			if (yy % csize == 0) {
				xoffset = csize * 3/4;
			}
			draw_sprite(s_zonemap_hex, 0, xx + xoffset + csize/4, yy + yoffset);
		}
	}
	surface_reset_target();
}