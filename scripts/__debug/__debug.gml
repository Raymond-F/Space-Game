// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// This function takes an input from the player and parses it into tokens, then turns those tokens
// into functions. E.g. "additem 4" would add the item with index 4 to the player's inventory.
function db_terminal() {
	var bad_command = function() {
		show_debug_message("ERROR: Unrecognized command.")
	}
	var short_command = function() {
		show_debug_message("ERROR: Command missing arguments.");
	}
	
	var input = get_string("DEBUG TERMINAL: Enter your command (e.g. \"additem 4\") here.", "");
	var tokens = string_tokenize(input);
	for (var i = 0; i < array_length(tokens); i++) {
		tokens[i] = string_lower(tokens[i]);
	}
	switch (tokens[0]) {
		case "additem" : {
			var qty = 1;
			if (array_length(tokens) == 1) {
				short_command();
			} else if (array_length(tokens) > 2) {
				qty = tokens[2];
			}
			if (tokens[1] == "all") {
				db_cargo_add_all(qty);
			} else {
				db_cargo_add_to_inventory(int64(tokens[1]), qty);
			}
			update_item_display();
		} break;
		case "addmodule": {
			if (array_length(tokens == 1)) {
				short_command();
			}
			if (tokens[1] == "all") {
				db_module_add_all();
			} else {
				db_module_add_to_inventory(int64(tokens[1]));
			}
		} break;
		case "addmoney": {
			if (array_length(tokens == 1)) {
				short_command();
			}
			global.pix += int64(tokens[1]);
		}
		default: bad_command(); break;
	}
}


function db_cargo_add_to_inventory(_id, qty){
	if(!ds_map_exists(global.itemlist_cargo, _id)) {
		show_debug_message("WARNING: Attempted to add nonexistent cargo: " + string(_id));
		return;
	}
	inventory_add_item(global.player_inventory, global.itemlist_cargo[? int64(_id)], qty);
}

// Adds `qty` copies of all cargo to the player's storage
function db_cargo_add_all(qty) {
	var k = ds_map_find_first(global.itemlist_cargo);
	while (!is_undefined(k)) {
		inventory_add_item(global.player_inventory, global.itemlist_cargo[? k], qty);
		k = ds_map_find_next(global.itemlist_cargo, k);
	}
}

function db_module_add_to_inventory(_id){
	if(!ds_map_exists(global.itemlist_modules, _id)) {
		show_debug_message("WARNING: Attempted to add nonexistent module: " + string(_id));
		return;
	}
	inventory_add_item(global.player_module_inventory, global.itemlist_modules[? int64(_id)], 1);
}

// Adds one copy of all modules to the player's storage
function db_module_add_all() {
	var k = ds_map_find_first(global.itemlist_modules);
	while (!is_undefined(k)) {
		inventory_add_item(global.player_module_inventory, global.itemlist_modules[? k], 1);
		k = ds_map_find_next(global.itemlist_modules, k);
	}
}