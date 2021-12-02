/// @description Insert description here
// You can write your code in this editor
var h = sprite_get_height(s_button_contextmenu);
for (var i = 0; i < array_length(buttons); i++) {
	var b = buttons[i];
	b.x = point_x_to_gui(x);
	b.y = point_y_to_gui(y) + (i * h);
}