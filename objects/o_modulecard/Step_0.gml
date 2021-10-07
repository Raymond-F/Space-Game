/// @description Insert description here
// You can write your code in this editor
if (mouse_x == mouse_xprevious && mouse_y == mouse_yprevious) {
	tooltip_timer = max(tooltip_timer-1, 0);
} else {
	tooltip_timer = tooltip_delay;
}

if (mouse_collision_gui()) {
	if (MPRESSED(mb_right)) {
		var socket = find_first_unoccupied_socket();
		if (socket == noone) {
			audio_play_sound(snd_interface_deadclick, 30, false);
		} else {
			if (struct.type == MODULETYPE_SHIELD && ship_has_shield(global.editing_ship)) {
				tooltip_make_generic("A ship may only have one shield module.");
				audio_play_sound(snd_interface_deadclick, 30, false);
			} else if (struct.type == MODULETYPE_DRIVE && ship_has_drive(global.editing_ship)) {
				tooltip_make_generic("A ship may only have one drive module.");
				audio_play_sound(snd_interface_deadclick, 30, false);
			} else if (struct.type == MODULETYPE_WEPSYS && ship_has_wepsys(global.editing_ship)) {
				tooltip_make_generic("A ship may only have one weapon system module.");
				audio_play_sound(snd_interface_deadclick, 30, false);
			} else {
				inventory_remove_item(global.player_module_inventory, struct.list_id, 1);
				with (socket) {
					assign_module(other.struct);
				}
				audio_play_sound(snd_interface_install, 30, false);
			}
		}
	}
} else {
	tooltip_timer = tooltip_delay;
}

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;