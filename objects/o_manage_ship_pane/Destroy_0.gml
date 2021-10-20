/// @description Insert description here
// You can write your code in this editor
with(o_modulecard) {
	instance_destroy();
}
with(o_modulesocket) {
	instance_destroy();
}
with(o_weaponcard) {
	instance_destroy();
}
with(o_weaponsocket) {
	instance_destroy();
}
with(o_shipcard) {
	instance_destroy();
}
for (var i = 0; i < ds_list_size(buttons); i++) {
	instance_destroy(buttons[|i]);
}
ds_list_destroy(cards);
ds_list_destroy(sockets);
ds_list_destroy(buttons);

instance_destroy(module_button);
instance_destroy(weapon_button);
instance_destroy(ship_button);
instance_destroy(close_button);

delete global.player_ship;
global.player_ship = global.editing_ship;
global.editing_ship = noone;
global.dragged_module = noone;
global.dragged_weapon = noone;

audio_play_sound(snd_interface_close, 30, false);