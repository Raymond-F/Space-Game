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
		if (active_list == global.player_inventory) {
			itc.transfer_target = loot_list;
			itc.current_target = global.player_inventory;
		} else {
			itc.transfer_target = global.player_inventory;
			itc.current_target = loot_list;
		}
		itc.depth = depth - 1;
		ds_list_add(item_cards, itc);
		row++;
		if (row >= items_per_row) {
			row = 0;
			col++;
		}
	}
	with (o_itemcard) {
		if (y > y_cutoff[0] || y < y_cutoff[1]) {
			active = false;
		}
	}
}

refresh = function() {
	loot_pane_refresh();
}

top_text = "SPOILS";
item_cards = ds_list_create();
buttons = ds_list_create();
scroll = 0;
items_per_row = 7;
scroll_cd = 0;
scroll_cd_max = 20;
depth = -100;
loot_list = generate_loot();
active_list = loot_list;
create_itemcards();

var sort_button = instance_create(x + 52, y + 13, o_button);
sort_button.on_press = function() {
	sort_itemlist(active_list);
	loot_pane_refresh();
}
sort_button.text = "SORT";
sort_button.depth = depth - 1;
sort_button.sprite_index = s_button_tab;
ds_list_add(buttons, sort_button);

var inv_button = instance_create(x + sprite_width - 52 - sprite_get_width(s_button_tab) * 2, y + 13, o_button);
inv_button.on_press = function() {
	active_list = global.player_inventory;
	other.loot_btn.image_index = 0;
	loot_pane_refresh();
}
inv_button.text = "CARGO";
inv_button.depth = depth - 1;
inv_button.sprite_index = s_button_tab;
inv_button.use_active_image = true;
inv_button.press_sound = snd_interface_pressbutton1;
ds_list_add(buttons, inv_button);

var loot_button = instance_create(x + sprite_width - 52 - sprite_get_width(s_button_tab), y + 13, o_button);
loot_button.on_press = function() {
	active_list = loot_list;
	other.inv_btn.image_index = 0;
	loot_pane_refresh();
}
loot_button.text = "LOOT";
loot_button.depth = depth - 1;
loot_button.sprite_index = s_button_tab;
loot_button.use_active_image = true;
loot_button.image_index = 1;
loot_button.press_sound = snd_interface_pressbutton1;
ds_list_add(buttons, loot_button);

loot_button.inv_btn = inv_button;
inv_button.loot_btn = loot_button;

var leave_button = instance_create(x + sprite_width/2 - sprite_get_width(s_button_large)/2, y + sprite_height - sprite_get_height(s_button_large), o_button);
leave_button.on_press = function() {
	close_inventory();
}
leave_button.text = "LEAVE";
leave_button.depth = depth - 5;
leave_button.sprite_index = s_button_large;
ds_list_add(buttons, leave_button);

audio_play_sound(snd_interface_open, 30, false);