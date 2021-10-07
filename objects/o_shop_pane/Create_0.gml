/// @description Insert description here
// You can write your code in this editor
create_itemcards = function() {
	var row = 0;
	var col = 0;
	var border_width = 52;
	var border_height = 51;
	var card_width = sprite_get_width(s_itemframe);
	var card_height = sprite_get_height(s_itemframe);
	// Set shop prices for the active list
	for (var i = 0; i < ds_list_size(active_list); i++) {
		if (active_list == player_list) {
			shop_calculate_player_item_value(struct, active_list[|i]);
		} else {
			shop_calculate_item_value(struct, active_list[|i]);
		}
	}
	for (var i = 0; i < ds_list_size(active_list); i++) {
		var itc = instance_create(x + border_width + card_width*row, y + border_height + card_height*col, o_itemcard);
		itc.struct = active_list[|i];
		itc.name = active_list[|i].name;
		itc.quantity = active_list[|i].quantity;
		itc.sprite = active_list[|i].sprite;
		itc.pos = i;
		itc.par = id;
		itc.y_cutoff = [y + 500, y];
		if (active_list == player_list) {
			itc.transfer_target = shop_list;
			itc.current_target = player_list;
			itc.selling = true;
			itc.value = active_list[|i].value;
		} else {
			itc.transfer_target = player_list;
			itc.current_target = shop_list;
			itc.buying = true;
			itc.value = active_list[|i].value;
		}
		itc.depth = depth - 1;
		ds_list_add(item_cards, itc);
		row++;
		if (row >= items_per_row) {
			row = 0;
			col++;
		}
	}
	with(o_itemcard) {
		y -= other.scroll * sprite_height;
		if (y > y_cutoff[0] || y < y_cutoff[1]) {
			active = false;
		}
	}
}

refresh = function() {
	shop_pane_refresh();
}

top_text = "SHOP";
item_cards = ds_list_create();
buttons = ds_list_create();
scroll = 0;
items_per_row = 7;
scroll_cd = 0;
scroll_cd_max = 20;
depth = -100;
struct = global.active_shop;
switch (struct.type) {
	case shop_type.general: player_list = global.player_inventory; inv_text = "INVENTORY"; break;
	case shop_type.weapon: player_list = global.player_weapon_inventory; inv_text = "STORED"; break;
	case shop_type.module: player_list = global.player_module_inventory; inv_text = "STORED"; break;
	case shop_type.ship: player_list = global.player_ship_inventory; inv_text = "STORED"; break;
	default: player_list = global.player_inventory; inv_text = "INVENTORY"; break;
}
shop_list = global.active_shop.inventory;
active_list = shop_list;
sort_itemlist(active_list);
create_itemcards();

var sort_button = instance_create(x + 52, y + 13, o_button);
sort_button.on_press = function() {
	sort_itemlist(active_list);
	shop_pane_refresh();
}
sort_button.text = "SORT";
sort_button.depth = depth - 1;
sort_button.sprite_index = s_button_tab;
sort_button.press_sound = snd_interface_pressbutton1;
ds_list_add(buttons, sort_button);

var inv_button = instance_create(x + sprite_width - 52 - sprite_get_width(s_button_tab) * 2, y + 13, o_button);
inv_button.on_press = function() {
	if (active_list != player_list) {
		scroll = 0;
		active_list = player_list;
	}
	other.shop_btn.image_index = 0;
	shop_pane_refresh();
}
inv_button.text = inv_text;
inv_button.depth = depth - 1;
inv_button.sprite_index = s_button_tab;
inv_button.use_active_image = true;
inv_button.press_sound = snd_interface_pressbutton1;
ds_list_add(buttons, inv_button);

var shop_button = instance_create(x + sprite_width - 52 - sprite_get_width(s_button_tab), y + 13, o_button);
shop_button.on_press = function() {
	if (active_list != shop_list) {
		scroll = 0;
		active_list = shop_list;
	}
	other.inv_btn.image_index = 0;
	shop_pane_refresh();
}
shop_button.text = "SHOP";
shop_button.depth = depth - 1;
shop_button.sprite_index = s_button_tab;
shop_button.use_active_image = true;
shop_button.image_index = 1;
shop_button.press_sound = snd_interface_pressbutton1;
ds_list_add(buttons, shop_button);

shop_button.inv_btn = inv_button;
inv_button.shop_btn = shop_button;

var exit_button = instance_create(x + sprite_width/2 - sprite_get_width(s_button_large)/2, y + sprite_height - sprite_get_height(s_button_large), o_button);
exit_button.on_press = function() {
	settlement_reactivate_pane();
	global.active_shop = noone;
	instance_destroy();
}
exit_button.text = "EXIT";
exit_button.depth = depth - 5;
exit_button.sprite_index = s_button_large;
ds_list_add(buttons, exit_button);

audio_play_sound(snd_interface_open, 30, false);