/// @description Insert description here
// You can write your code in this editor
pcontrol_timer = max(-1, pcontrol_timer-1);
if (pcontrol_timer == 0) {
	pcontrol = true;
}

selected_hex = mouse_get_hex();

if (!pcontrol) {
	// Skip condition
}
else if (MPRESSED(mb_right) && selected_hex != noone && selected_hex.vision == true) {
	targeted_hex = selected_hex;
	set_player_dest();
	targeted_hex = noone;
} else if (MPRESSED(mb_left)) {
	if (selected_hex != noone && selected_hex.vision == true) {
		if (selected_hex == targeted_hex) {
			set_player_dest();
			targeted_hex = noone;
		} else {
			targeted_hex = selected_hex;
		}
	}
} else if (PRESSED(vk_enter)) {
	with (o_zonemap_location) {
		if (hex == global.player.hex) {
			struct.interact();
			if (type == location_type.event) {
				global.event_current_object = id;
			}
			break;
		}
	}
}