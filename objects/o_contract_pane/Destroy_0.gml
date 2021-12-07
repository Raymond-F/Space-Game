/// @description Insert description here
// You can write your code in this editor
for (var i = 0; i < ds_list_size(contract_cards); i++) {
	instance_destroy(contract_cards[|i]);
}
for (var i = 0; i < ds_list_size(buttons); i++) {
	instance_destroy(buttons[|i]);
}
ds_list_destroy(contract_cards);
ds_list_destroy(buttons);

audio_play_sound(snd_interface_close, 30, false);