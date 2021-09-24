/// @description Insert description here
// You can write your code in this editor
if (!setup) {
	setup = true;
	target = instance_nearest(x, y, o_player);
	x = target.x;
	y = target.y;
	camera_set_view_pos(CAM, x - VIEW_WIDTH/2, y - VIEW_HEIGHT/2);
}