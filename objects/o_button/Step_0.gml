/// @description Insert description here
// You can write your code in this editor
if (global.ui_layer == ui_layer && point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, x, y, x + sprite_width, y + sprite_height)) {
	if (MPRESSED(mb_left)) {
		if (use_active_image) {
			image_index++; // if the button has an "active" sprite, switch to it
		}
		global.pressed_button = id;
		on_press();
		if (press_sound != noone) {
			audio_play_sound(press_sound, 20, false);
		}
	}
}