/// @description Insert description here
// You can write your code in this editor
create_itemcards = function() {
	var row = 0;
	var col = 0;
	var border_width = 52;
	var border_height = 51;
	var card_width = sprite_get_width(s_itemframe);
	var card_height = sprite_get_height(s_itemframe);
	for (var i = 0; i < ds_list_size(active_list); i++) {
		var itc = instance_create(x + border_width + card_width*row, y + border_height + card_height*col, o_itemcard);
		itc.struct = active_list[|i];
		itc.name = active_list[|i].name;
		itc.quantity = active_list[|i].quantity;
		itc.sprite = active_list[|i].sprite;
		itc.pos = i;
		itc.par = id;
		itc.y_cutoff = [y + 500, y];
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
	inventory_pane_refresh();
}

top_text = "CARGO";
item_cards = ds_list_create();
buttons = ds_list_create();
scroll = 0;
items_per_row = 7;
scroll_cd = 0;
scroll_cd_max = 20;
active_list = global.player_inventory;
create_itemcards();
depth = -100;

var sort_button = instance_create(x + 52, y + 13, o_button);
sort_button.on_press = function() {
	sort_inventory();
	inventory_pane_refresh();
}
sort_button.text = "SORT";
sort_button.depth = depth - 1;
sort_button.sprite_index = s_button_tab;
sort_button.press_sound = snd_interface_pressbutton1;
ds_list_add(buttons, sort_button);
var close_button = instance_create(x + sprite_width - sprite_get_width(s_button_tab) - 52, y + 13, o_button);
close_button.on_press = function() {
	close_inventory();
}
close_button.text = "CLOSE";
close_button.depth = depth - 1;
close_button.sprite_index = s_button_tab;
ds_list_add(buttons, close_button);

audio_play_sound(snd_interface_open, 30, false);