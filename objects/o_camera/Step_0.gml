/// @description Insert description here
// You can write your code in this editor

// Manual control
var xchange = 0, ychange = 0;
if (HELD(ord("D"))) {
	xchange++;
}
if (HELD(ord("A"))) {
	xchange--;
}
if (xchange == 0) {
	if (xspd > 0) {
		xspd = max(0, xspd-2);
	} else if (xspd < 0) {
		xspd = min(0, xspd+2);
	}
} else {
	xspd = clamp(xspd + xchange, -maxspd, maxspd);
	follow = false;
}
if (HELD(ord("S"))) {
	ychange++;
}
if (HELD(ord("W"))) {
	ychange--;
}
if (ychange == 0) {
	if (yspd > 0) {
		yspd = max(0, yspd-2);
	} else if (yspd < 0) {
		yspd = min(0, yspd+2);
	}
} else {
	yspd = clamp(yspd + ychange, -maxspd, maxspd);
	follow = false;
}

if (follow && instance_exists(target)) {
	x = lerp(x, target.x, 0.2);
	y = lerp(y, target.y, 0.2);
} else {
	x += xspd;
	y += yspd;
}
x = clamp(x, global.camera_constraints[0], global.camera_constraints[2]);
y = clamp(y, global.camera_constraints[1], global.camera_constraints[3]);

camera_set_view_pos(CAM, x - VIEW_WIDTH/2, y - VIEW_HEIGHT/2);