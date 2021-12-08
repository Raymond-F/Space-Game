/// @description Insert description here
// You can write your code in this editor

cnt = noone; // contract struct

name = "";
desc = "";
price = 0;
difficulty = 0;
icon = -1;

init = function(_contract) {
	cnt = _contract;
	name = cnt.name;
	desc = cnt.description;
	price = cnt.price;
	difficulty = cnt.difficulty;
	// TODO: Icon
	
	if (global.current_contract != noone && global.current_contract == cnt) {
		button.text = "CLAIM";
		if (cnt.stage != cnt.last_stage) {
			button.active = false;
		}
		button.on_press = function() {
			contract_complete(cnt);
			with (o_contract_pane) {
				refresh();
			}
		}
	} else {
		button.text = "ACCEPT";
		if (global.current_contract != noone) {
			button.active = false;
		}
		button.on_press = function() {
			contract_accept(cnt);
			with (o_contract_pane) {
				refresh();
			}
		}
	}
}

var bw = sprite_get_width(s_button_medium);
var bh = sprite_get_height(s_button_medium);
button = instance_create(x + sprite_width - bw - 16, y + sprite_height - bh - 10, o_button);
button.sprite_index = s_button_medium;
button.depth = depth-1;