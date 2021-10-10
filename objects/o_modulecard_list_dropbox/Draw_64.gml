/// @description Insert description here
// You can write your code in this editor
var a = 0.5;
draw_set_color(c_white);
for (var i = 0; i < 5; i++) {
	draw_set_alpha(a);
	draw_rectangle(coords[0] + i, coords[1] + i, coords[2] - i, coords[3] - i, true);
	a -= 0.1;
}
draw_set_alpha(1);