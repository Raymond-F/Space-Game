/// @description Insert description here
// You can write your code in this editor
for (var i = 0; i < ds_list_size(item_cards); i++) {
	instance_destroy(item_cards[|i]);
}
for (var i = 0; i < ds_list_size(buttons); i++) {
	instance_destroy(buttons[|i]);
}
ds_list_destroy(item_cards);
ds_list_destroy(buttons);

// Reset player item values
for (var i = 0; i < ds_list_size(player_list); i++) {
	var it = player_list[|i];
	it.value = item_get_true_value(it);
}

audio_play_sound(snd_interface_close, 30, false);