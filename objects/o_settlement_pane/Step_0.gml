/// @description Insert description here
// You can write your code in this editor
if (PRESSED(vk_escape)) {
	if (escape_function == instance_destroy) {
		audio_play_sound(snd_interface_close, 30, false);
	} else {
		audio_play_sound(snd_interface_pressbutton1, 30, false);
	}
	escape_function();
	keyboard_clear(vk_escape);
}