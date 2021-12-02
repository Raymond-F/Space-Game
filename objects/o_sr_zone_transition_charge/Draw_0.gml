/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_white);
for (var i = 0; i < ds_list_size(motes); i++) {
	var coord = motes[| i];
	var xx = coord[0];
	var yy = coord[1];
	draw_flare(xx, yy, 8, c_white);
}
draw_set_color($FFBBBB);
draw_flare(buildup_center[0], buildup_center[1], buildup_size + irandom(5), $FFBBBB);
draw_set_color(c_white);