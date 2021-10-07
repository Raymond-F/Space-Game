/// @description Insert description here
// You can write your code in this editor
scroll_cd = max(scroll_cd-1, 0);

if(mouse_wheel_down()) {
	var count = ds_list_size(global.player_inventory);
	if (count > items_per_row * (3 + scroll)) {
		scroll++;
		with(o_itemcard) {
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
		with(o_itemcard) {
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
	instance_destroy();
	keyboard_clear(vk_escape);
}