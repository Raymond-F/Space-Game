/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_black);
draw_rectangle(VIEW_LEFT, VIEW_TOP, VIEW_RIGHT, VIEW_BOTTOM, false);

draw_set_alpha(0.2);
var col = choose($DD6611, $CC6611, $BB6611, $AA6611, $AA7700, $AA8800);
draw_set_color(col);
draw_rectangle(VIEW_LEFT, VIEW_TOP, VIEW_RIGHT, VIEW_BOTTOM, false);
draw_set_alpha(1);
draw_set_color(c_white);

var reps = 8;
var dx = ship_x;
var dy = ship_y;
var alpha = 1;
repeat(reps) {
	draw_sprite_ext(s_zonemap_player, 1, dx, dy, 0.2, 0.2, travel_angle, c_white, alpha);
	alpha -= 1/(reps+1);
	dx -= lengthdir_x(ship_speed, travel_angle);
	dy -= lengthdir_y(ship_speed, travel_angle);
}