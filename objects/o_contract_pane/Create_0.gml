/// @description Insert description here
// You can write your code in this editor
create_contractcards = function() {
	ds_list_empty(contract_cards);
	var ct;
	if (global.current_contract != noone) {
		ct = instance_create_depth(x + 52, y + 101, depth - 1, o_contractcard);
		with(ct) {
			init(global.current_contract);
		}
		ds_list_add(contract_cards, ct);
	}
	var yy = y + 327;
	for (var i = 0; i < ds_list_size(global.active_settlement.struct.contracts); i++) {
		var cnt = global.active_settlement.struct.contracts[| i];
		ct = instance_create_depth(x + 52, yy, depth - 1, o_contractcard);
		with(ct) {
			init(cnt);
		}
		ds_list_add(contract_cards, ct);
		yy += sprite_get_height(s_contractcard);
	}
}

refresh = function() {
	instance_destroy_all(o_contractcard);
	create_contractcards();
}

top_text = "CONTRACTS";
contract_cards = ds_list_create();
buttons = ds_list_create();
depth = -100;
create_contractcards();

var exit_button = instance_create(x + sprite_width/2 - sprite_get_width(s_button_large)/2, y + sprite_height - sprite_get_height(s_button_large), o_button);
exit_button.on_press = function() {
	settlement_reactivate_pane();
	instance_destroy();
}
exit_button.text = "EXIT";
exit_button.depth = depth - 5;
exit_button.sprite_index = s_button_large;
ds_list_add(buttons, exit_button);

audio_play_sound(snd_interface_open, 30, false);