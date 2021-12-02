/// @description Insert description here
// You can write your code in this editor
var bw = sprite_get_width(s_button_contextmenu);
if (mouse_x < x - bw || mouse_x > x + bw*2 || mouse_y < y - bw || mouse_y > y + (bw * (array_length(buttons)+1))) {
	instance_destroy();
}