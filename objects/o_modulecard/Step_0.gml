/// @description Insert description here
// You can write your code in this editor
if (mouse_x == mouse_xprevious && mouse_y == mouse_yprevious) {
	tooltip_timer = max(tooltip_timer-1, 0);
} else {
	tooltip_timer = tooltip_delay;
}

if (mouse_collision_gui() && global.dragged_module == noone && active) {
	if (MPRESSED(mb_right)) {
		var socket = find_first_unoccupied_socket();
		if (socket == noone) {
			audio_play_sound(snd_interface_deadclick, 30, false);
		} else {
			if (module_addition_valid(global.editing_ship, struct)) {
				inventory_remove_item(global.player_module_inventory, struct.list_id, 1);
				with (socket) {
					assign_module(other.struct);
				}
				audio_play_sound(snd_interface_install, 30, false);
			} else {
				audio_play_sound(snd_interface_deadclick, 30, false);
				switch (struct.type) {
					case MODULETYPE_SHIELD: tooltip_make_generic("A ship may only have one shield module."); break;
					case MODULETYPE_DRIVE: tooltip_make_generic("A ship may only have one drive module."); break;
					case MODULETYPE_WEPSYS: tooltip_make_generic("A ship may only have one weapon system module."); break;
				}
			}
		}
	} else if (MPRESSED(mb_left)) {
		global.dragged_module = id;
	}
} else {
	tooltip_timer = tooltip_delay;
}

if (global.dragged_module == id && MRELEASED(mb_left)) {
	var done = false;
	var socket = noone;
	with (o_modulesocket) {
		if (mouse_collision_gui()) {
			socket = id;
			break;
		}
	}
	if (socket != noone && (module_addition_valid(global.editing_ship, struct) || (socket.contained.type != MODULETYPE_OTHER && socket.contained.type == struct.type))) {
		with (socket) {
			if (!locked && class >= global.dragged_module.struct.class) {
				var index = inventory_find_item_index_by_id(global.player_module_inventory, global.dragged_module.struct.list_id);
				var insert_index = -1;
				if (index >= 0 && global.player_module_inventory[| index].quantity == 1) {
					insert_index = index;
				}
				inventory_remove_item(global.player_module_inventory, global.dragged_module.struct.list_id, 1);
				assign_module(global.dragged_module.struct, insert_index);
				audio_play_sound(snd_interface_install, 30, false);
				with(o_manage_ship_pane) {
					refresh();
				}
			} else if (class < global.dragged_module.struct.class) {
				audio_play_sound(snd_interface_deadclick, 30, false);
			}
			done = true;
			break;
		}
	} else if (socket != noone) {
		audio_play_sound(snd_interface_deadclick, 30, false);
		switch (struct.type) {
			case MODULETYPE_SHIELD: tooltip_make_generic("A ship may only have one shield module."); break;
			case MODULETYPE_DRIVE: tooltip_make_generic("A ship may only have one drive module."); break;
			case MODULETYPE_WEPSYS: tooltip_make_generic("A ship may only have one weapon system module."); break;
		}
	}
	if (!done) {
		with (o_modulecard) {
			if (active && mouse_collision_gui() && id != global.dragged_module.id) {
				var temp = global.player_module_inventory[| pos];
				var temppos = pos;
				global.player_module_inventory[| pos] = global.player_module_inventory[| global.dragged_module.pos];
				pos = global.dragged_module.pos;
				global.dragged_module.pos = temppos;
				global.player_module_inventory[| pos] = temp;
				with(o_manage_ship_pane) {
					refresh();
				}
				audio_play_sound(snd_interface_pressbutton1, 30, false);
				break;
			}
		}
	}
	global.dragged_module = noone;
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;