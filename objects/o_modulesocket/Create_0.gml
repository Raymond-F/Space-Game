/// @description Insert description here
// You can write your code in this editor
locked = false;
class = 1;
contained = noone;
target_arr = noone;
target_ind = 0;
sprite = noone;
par = noone;

assign_module = function(_struct, insert_index = -1) {
	// "noone" makes this effectively just unassigning the module
	if (_struct == noone) {
		unassign_module();
		return;
	}
	// Add the module back to the module list if there is one
	if (contained != noone) {
		if (insert_index < 0) {
			inventory_add_item(global.player_module_inventory, contained, 1);
		} else {
			inventory_add_item_insert(global.player_module_inventory, contained, 1, insert_index);
		}
	}
	contained = item_get_base_struct(_struct);
	sprite = _struct.sprite;
	// Update the edit ship.
	if (target_arr != noone) {
		target_arr[@ target_ind] = item_get_base_struct(_struct).list_id;
	}
	
	with (o_manage_ship_pane) {
		refresh();
	}
}

unassign_module = function() {
	// Add the module back to the module list
	if (contained != noone) {
		inventory_add_item(global.player_module_inventory, contained, 1);
	}
	contained = noone;
	sprite = noone;
	// Update the edit ship.
	if (target_arr != noone) {
		target_arr[@ target_ind] = noone;
	}
	
	with (o_manage_ship_pane) {
		refresh();
	}
}