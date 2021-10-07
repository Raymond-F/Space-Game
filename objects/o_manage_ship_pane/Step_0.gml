/// @description Insert description here
// You can write your code in this editor
scroll_cd = max(scroll_cd-1, 0);

if(mouse_wheel_down()) {
	var count = ds_list_size(global.player_module_inventory);
	if (count > items_displayed + scroll) {
		scroll++;
		with(o_modulecard) {
			y -= sprite_height;
			if(y < y_cutoff[1]) {
				active = false;
			} else if (y < y_cutoff[0]) {
				active = true;
			}
		}
		scroll_cd = scroll_cd_max;
	}
}

if(mouse_wheel_up()) {
	if (scroll > 0) {
		scroll--;
		with(o_modulecard) {
			y += sprite_height;
			if(y > y_cutoff[0]) {
				active = false;
			} else if (y > y_cutoff[1]) {
				active = true;
			}
		}
		scroll_cd = scroll_cd_max;
	}
}

if (PRESSED(vk_escape)) {
	if (!ship_has_drive(global.editing_ship)) {
		tooltip_make_generic("Your ship must have a drive module.");
		audio_play_sound(snd_interface_deadclick, 30, false);
	} else {
		settlement_reactivate_pane();
		instance_destroy();
		keyboard_clear(vk_escape);
	}
}