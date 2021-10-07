/// @description Insert description here
// You can write your code in this editor
with(o_modulecard) {
	instance_destroy();
}
with(o_modulesocket) {
	instance_destroy();
}
for (var i = 0; i < ds_list_size(buttons); i++) {
	instance_destroy(buttons[|i]);
}
ds_list_destroy(cards);
ds_list_destroy(sockets);
ds_list_destroy(buttons);

delete global.player_ship;
global.player_ship = global.editing_ship;
global.editing_ship = noone;

audio_play_sound(snd_interface_close, 30, false);