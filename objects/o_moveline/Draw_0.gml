/// @description Insert description here
// You can write your code in this editor
y += spd;
if(y > VIEW_HEIGHT + 20) {
	instance_destroy();
}

draw_set_color(c_white);
draw_rectangle(x, y+1, x, y - len, false);