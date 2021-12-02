/// @description Insert description here
// You can write your code in this editor
for (var i = 0; i < array_length(buttons); i++) {
	instance_destroy(buttons[i]);
}

audio_play_sound(snd_interface_close, 30, false);
global.active_settlement = noone;