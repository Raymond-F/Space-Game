/// @description Insert description here
// You can write your code in this editor

cnt = noone; // contract struct

name = "";
desc = "";
price = 0;
difficulty = 0;
icon = -1;

var bw = sprite_get_width(s_button_small);
var bh = sprite_get_height(s_button_small);
accept = instance_create(x + sprite_width - bw - 10, y + sprite_height - bh - 10, o_button);
accept.sprite_index = s_button_small;
accept.text = "ACCEPT";
if (global.current_contract != noone) {
	accept.active = false;
}
accept.on_press = function() {
	contract_accept(cnt);
}