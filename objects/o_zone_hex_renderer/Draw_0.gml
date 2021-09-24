/// @description Insert description here
// You can write your code in this editor

if (!surface_exists(surf)) {
	render_hexes();
}

var xquanta = floor(VIEW_LEFT/csize);
var yquanta = floor(VIEW_TOP/csize);
var xdraw = xquanta*csize*3/2;
var ydraw = (yquanta-1)*csize;
while (xdraw < VIEW_LEFT) {
	xdraw += csize*3/2;
}
while (xdraw > VIEW_LEFT) {
	xdraw -= csize*3/2;
}
xdraw = clamp(xdraw, 0, global.zone_width * csize*3/4 + csize*9/2);
ydraw = clamp(ydraw, 0, global.zone_height * csize*3/4);
draw_surface(surf, xdraw, ydraw);