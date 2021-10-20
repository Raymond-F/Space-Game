/// @description Insert description here
// You can write your code in this editor
if (mouse_x == mouse_xprevious && mouse_y == mouse_yprevious) {
	tooltip_timer = max(tooltip_timer-1, 0);
} else {
	tooltip_timer = tooltip_delay;
}

if (mouse_collision_gui() && global.dragged_weapon == noone && active) {
	if (MPRESSED(mb_right)) {
		var socket = find_first_unoccupied_socket();
		if (socket == noone) {
			audio_play_sound(snd_interface_deadclick, 30, false);
		} else {
			inventory_remove_item(global.player_weapon_inventory, struct.list_id, 1);
			with (socket) {
				assign_weapon(other.struct);
			}
			audio_play_sound(snd_interface_install, 30, false);
		}
	} else if (MPRESSED(mb_left)) {
		global.dragged_weapon = id;
	}
} else {
	tooltip_timer = tooltip_delay;
}

if (global.dragged_weapon == id && MRELEASED(mb_left)) {
	var done = false;
	var socket = noone;
	with (o_weaponsocket) {
		if (mouse_collision_gui()) {
			socket = id;
			break;
		}
	}
	if (socket != noone) {
		with (socket) {
			if (!locked) {
				var index = inventory_find_item_index_by_id(global.player_weapon_inventory, global.dragged_weapon.struct.list_id);
				var insert_index = -1;
				if (index >= 0 && global.player_weapon_inventory[| index].quantity == 1) {
					insert_index = index;
				}
				inventory_remove_item(global.player_weapon_inventory, global.dragged_weapon.struct.list_id, 1);
				assign_weapon(global.dragged_weapon.struct, insert_index);
				audio_play_sound(snd_interface_install, 30, false);
				with(o_manage_ship_pane) {
					refresh();
				}
			}
			done = true;
			break;
		}
	}
	if (!done) {
		with (o_weaponcard) {
			if (active && mouse_collision_gui() && id != global.dragged_weapon.id) {
				var temp = global.player_weapon_inventory[| pos];
				var temppos = pos;
				global.player_weapon_inventory[| pos] = global.player_weapon_inventory[| global.dragged_weapon.pos];
				pos = global.dragged_weapon.pos;
				global.dragged_weapon.pos = temppos;
				global.player_weapon_inventory[| pos] = temp;
				with(o_manage_ship_pane) {
					refresh();
				}
				audio_play_sound(snd_interface_pressbutton1, 30, false);
				break;
			}
		}
	}
	global.dragged_weapon = noone;
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;