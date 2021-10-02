/// @description Insert description here
// You can write your code in this editor
title = "*SETTLEMENT*";
image = noone;
obj = noone;
buttons = [];

open_main = function() {
	var bx = GUIW/2 - sprite_width/2 + 3;
	var by = GUIH/2 - sprite_height/2 + 352;
	var bh = sprite_get_height(s_button_settlement_pane);
	var shop_button = instance_create(bx, by, o_button);
	shop_button.sprite_index = s_button_settlement_pane;
	shop_button.text = "SHOP";
	shop_button.on_press = function() {
		// TODO: Open shop screen
	}
	array_push(buttons, shop_button);
	by += bh;
	var exit_button = instance_create(bx, by, o_button);
	exit_button.sprite_index = s_button_settlement_pane;
	exit_button.text = "LEAVE";
	exit_button.on_press = function() {
		with (o_settlement_pane) {
			instance_destroy();
		}
	}
	array_push(buttons, exit_button);
	by += bh;
	for (var i = 0; i < array_length(buttons); i++) {
		buttons[i].depth = depth - 1;
	}
}

open_main();