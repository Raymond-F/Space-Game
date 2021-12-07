/// @description Insert description here
// You can write your code in this editor
title = "*SETTLEMENT*";
image = noone;
obj = noone;
buttons = [];

clear_buttons = function() {
	for (var i = 0; i < array_length(buttons); i++) {
		instance_destroy(buttons[i]);
	}
	buttons = [];
}

buttons_set_depth = function() {
	for (var i = 0; i < array_length(buttons); i++) {
		buttons[i].depth = depth - 1;
	}
}

open_shop_list = function() {
	clear_buttons();
	var shops = loc.struct.shops;
	var bx = GUIW/2 - sprite_width/2 + 3;
	var by = GUIH/2 - sprite_height/2 + 352;
	var bh = sprite_get_height(s_button_settlement_pane);
	for (var i = 0; i < array_length(shops); i++) {
		var button = instance_create(bx, by, o_button);
		button.sprite_index = s_button_settlement_pane;
		switch (shops[i].type) {
			case shop_type.general: button.text = "GENERAL GOODS"; break;
			case shop_type.module: button.text = "MODULES"; break;
			case shop_type.weapon: button.text = "WEAPONS"; break;
			case shop_type.ship: button.text = "SHIPYARD"; break;
			default: button.text = "UNDEFINED"; break;
		}
		button.linked_shop = shops[i];
		button.on_press = function() {
			global.active_shop = global.pressed_button.linked_shop;
			var sp = instance_create(GUIW/2 - sprite_get_width(s_shop_pane)/2, GUIH/2 - sprite_get_height(s_shop_pane)/2, o_shop_pane);
			sp.top_text = global.pressed_button.text;
			settlement_deactivate_pane();
		}
		array_push(buttons, button);
		by += bh;
	}
	var back_button = instance_create(bx, by, o_button);
	back_button.sprite_index = s_button_settlement_pane;
	back_button.text = "BACK";
	back_button.on_press = function() {
		open_main();
	}
	back_button.press_sound = snd_interface_pressbutton1;
	array_push(buttons, back_button);
	buttons_set_depth();
	escape_function = open_main;
}

open_main = function() {
	clear_buttons();
	var bx = GUIW/2 - sprite_width/2 + 3;
	var by = GUIH/2 - sprite_height/2 + 352;
	var bh = sprite_get_height(s_button_settlement_pane);
	
	var shop_button = instance_create(bx, by, o_button);
	shop_button.sprite_index = s_button_settlement_pane;
	shop_button.text = "SHOP";
	shop_button.on_press = function() {
		open_shop_list();
	}
	shop_button.press_sound = snd_interface_pressbutton1;
	array_push(buttons, shop_button);
	
	by += bh;
	var manage_button = instance_create(bx, by, o_button);
	manage_button.sprite_index = s_button_settlement_pane;
	manage_button.text = "MANAGE SHIP";
	manage_button.on_press = function() {
		instance_create(GUIW/2 - sprite_get_width(s_ship_management_pane)/2, GUIH/2 - sprite_get_height(s_ship_management_pane)/2, o_manage_ship_pane);
		settlement_deactivate_pane();
	}
	manage_button.press_sound = snd_interface_pressbutton1;
	array_push(buttons, manage_button);
	
	by += bh;
	var contract_button = instance_create(bx, by, o_button);
	contract_button.sprite_index = s_button_settlement_pane;
	contract_button.text = "CONTRACTS";
	contract_button.on_press = function() {
		instance_create(GUIW/2 - sprite_get_width(s_contract_pane)/2, GUIH/2 - sprite_get_height(s_contract_pane)/2, o_contract_pane);
		settlement_deactivate_pane();
	}
	contract_button.press_sound = snd_interface_pressbutton1;
	array_push(buttons, contract_button);
	
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
	buttons_set_depth();
	escape_function = instance_destroy;
}

open_main();

audio_play_sound(snd_interface_open, 30, false);