/// @description Insert description here
// You can write your code in this editor
if (point_distance(x, y, tx, ty) > 1) {
	image_angle = point_direction(x, y, tx, ty);
}
x = lerp(x, tx, 0.15);
y = lerp(y, ty, 0.15);
if (point_distance(x, y, tx, ty) < 0.25) {
	x = tx;
	y = ty;
}
if (!exit_burst && point_distance(x, y, tx, ty) < 32) {
	exit_burst = true;
	image_index = 0;
	if (image_alpha > 0) {
		var burst = instance_create(x, y, o_zonemap_impulse_burst_fx);
		burst.depth = depth-1;
	}
}

depth = -y - 256;