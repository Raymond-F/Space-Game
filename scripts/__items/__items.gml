// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function item(_list_id = 0, _name = "", _sprite = 0, _weight = 1, _stackability = true, _value = 1) constructor {
	list_id = _list_id;
	name = _name;
	sprite = _sprite;
	value = _value; // Per item
	weight = _weight; // Per item
	stackable = _stackability; // Whether an item can be stacked
	quantity = 1; // Unused in list but used in inventories
}

function initialize_itemlist_cargo(){
	var cl = ds_map_create();
	
	ds_map_add_unique(cl, 0, new item(0, "supplies", s_cargo_supplies, 1, true, 100));
	ds_map_add_unique(cl, 1, new item(1, "fuel", s_cargo_placeholder, 0.1, true, 40));
	ds_map_add_unique(cl, 2, new item(2, "alloys", s_cargo_placeholder, 2, true, 250));
	ds_map_add_unique(cl, 3, new item(3, "precious metals", s_cargo_placeholder, 1, true, 1000));
	ds_map_add_unique(cl, 4, new item(4, "electronics", s_cargo_placeholder, 2, true, 400));
	
	return cl;
}

function inventory_find_item_index_by_name(list, name) {
	for(var i = 0; i < ds_list_size(list); i++) {
		if(list[|i].name == name) {
			return i;
		}
	}
	return -1;
}

function inventory_find_item_index_by_id(list, item_id) {
	for(var i = 0; i < ds_list_size(list); i++) {
		if(list[|i].list_id == item_id) {
			return i;
		}
	}
	return -1;
}

function inventory_add_item(list, struct, quantity) {
	var index = inventory_find_item_index_by_id(list, struct.list_id);
	if (index < 0 || !struct.stackable) {
		var cpy = struct_copy(struct, item);
		cpy.quantity = quantity;
		ds_list_add(list, cpy);
	} else {
		list[|index].quantity += quantity;
	}
	update_item_display();
}

function inventory_remove_item(list, name_or_id, quantity) {
	var index;
	if (is_string(name_or_id)) {
		index = inventory_find_item_index_by_name(list, name_or_id);
	} else {
		index = inventory_find_item_index_by_id(list, name_or_id);
	}
	if (index < 0) {
		return;
	} else {
		list[|index].quantity -= quantity;
		if(list[|index].quantity <= 0) {
			delete list[|index];
			ds_list_delete(list, index);
		}
	}
}

function inventory_transfer_item(source, dest, index, quantity) {
	var it = source[|index];
	quantity = min(quantity, it.quantity);
	if(!it.stackable) {
		ds_list_add(dest, it);
		ds_list_delete(source, index);
	}
	var dest_index = inventory_find_item_index_by_id(dest, it.list_id);
	var new_item = struct_copy(global.itemlist_cargo[? it.list_id], item);
	if (dest_index < 0) {
		new_item.quantity = quantity;
		ds_list_add(dest, new_item);
	} else {
		dest[|dest_index].quantity += quantity;
	}
	it.quantity -= quantity;
	if (it.quantity <= 0) {
		delete it;
		ds_list_delete(source, index);
	}
	update_item_display();
}

// Updates the display of things like supplies in the HUD
function update_item_display() {
	var supplies_ind = inventory_find_item_index_by_name(global.player_inventory, "supplies");
	if (supplies_ind < 0) {
		global.supplies = 0;
	} else {
		global.supplies = global.player_inventory[| supplies_ind].quantity;
	}
	var fuel_ind = inventory_find_item_index_by_name(global.player_inventory, "fuel");
	if (fuel_ind < 0) {
		global.fuel = 0;
	} else {
		global.fuel = global.player_inventory[| fuel_ind].quantity;
	}
}

function initialize_default_player_inventory() {
	global.player_inventory = ds_list_create();
	var ids = [0, 1];
	var quantities = [10, 50];
	for (var i = 0; i < array_length(ids); i++) {
		inventory_add_item(global.player_inventory, global.itemlist_cargo[? ids[i]], quantities[i]);
	}
	update_item_display();
}

function close_inventory() {
	if (instance_exists(o_inventory_pane)) {
		with (o_inventory_pane) {
			instance_destroy();
		}
	}
	with (o_loot_pane) {
		instance_destroy();
	}
}

function sort_inventory() {
	// Bubble sort for now until it becomes cost prohibitive (if ever).
	for (var i = 0; i < ds_list_size(global.player_inventory)-1; i++) {
		var first = global.player_inventory[|i];
		for (var j = i; j < ds_list_size(global.player_inventory)-1; j++) {
			var check = global.player_inventory[|j];
			if (check.list_id < first.list_id) {
				var t = first;
				global.player_inventory[|i] = check;
				global.player_inventory[|j] = t;
				first = check;
			}
		}
	}
}

// A more generalized form of sort_inventory
function sort_itemlist(list) {
	for (var i = 0; i < ds_list_size(list)-1; i++) {
		var first = list[|i];
		for (var j = i; j < ds_list_size(list)-1; j++) {
			var check = list[|j];
			if (check.list_id < first.list_id) {
				var t = first;
				list[|i] = check;
				list[|j] = t;
				first = check;
			}
		}
	}
}

// Refreshes item cards in the inventory pane.
function inventory_pane_refresh() {
	if (!instance_exists(o_inventory_pane)) {
		return;
	}
	with(o_itemcard) {
		instance_destroy();
	}
	with(o_inventory_pane) {
		create_itemcards();
	}
}

// As above but for the loot pane
function loot_pane_refresh() {
	if (!instance_exists(o_loot_pane)) {
		return;
	}
	with(o_itemcard) {
		instance_destroy();
	}
	with(o_loot_pane) {
		create_itemcards();
	}
}

// Generate loot from the pointed-at file
function generate_loot() {
	var fname = "loot\\" + global.loot_file; //set to correct directory
	if(!file_exists(fname)){
		show_debug_message("ERROR: could not open file with filename: " + fname);
		return ds_list_create();
	}
	var file = file_text_open_read(fname);
	if(file < 0){
		return ds_list_create();
	}
	var lines = [];
	var linecount = 0;
	while(!file_text_eof(file)){
		var line = "";
		line = file_text_readln(file);
		while(string_char_at(line, string_length(line)) == "\r" || string_char_at(line, string_length(line)) == "\n"){
			line = string_delete(line, string_length(line), 1);
		}
		lines[linecount] = line;
		linecount++;
	}
	//we should now have a set of arrays representing the possible loot rolls.
	file_text_close(file);
	var tokenized = [];
	var total_weight = 0;
	for (var i = 0; i < array_length(lines); i++) {
		tokenized[i] = tokenize_to_int64(lines[i])
		total_weight += tokenized[i][3];
	}
	var list = ds_list_create()
	repeat (global.loot_rolls) {
		var roll = random_range(0, total_weight);
		var net_weight = 0;
		var chosen = [0, 1, 1, 0]; // A technically valid array, just in case
		for (var i = 0; i < array_length(tokenized); i++) {
			net_weight += tokenized[i][3];
			if(net_weight > roll) {
				chosen = tokenized[i];
				break;
			}
		}
		var qty = irandom_range(chosen[1], chosen[2]);
		// Add it to the list
		var in_list = false;
		for(var i = 0; i < ds_list_size(list); i++) {
			// Item already in list. Add to quantity.
			if (chosen[0] == list[|i].list_id && list[|i].stackable) {
				list[|i].quantity += qty;
				in_list = true;
				break;
			}
		}
		if (!in_list) {
			ds_list_add(list, struct_copy(global.itemlist_cargo[? chosen[0]], item));
			list[|i].quantity = qty;
		}
	}
	return list;
}