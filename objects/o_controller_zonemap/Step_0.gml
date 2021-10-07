/// @description Insert description here
// You can write your code in this editor

// Don't interact with the map when an interface is up
if (instance_exists(par_interface)) {
	exit;
}

// Debug stuff
if (PRESSED(vk_f4)) {
	// Go to nearest settlement
	with (o_zonemap_location) {
		if (type == location_type.settlement) {
			other.targeted_hex = hex;
			other.set_player_dest();
			other.targeted_hex = noone;
			break;
		}
	}
}

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
	var s = audio_play_sound(snd_pulsestart, 30, false);
	audio_sound_pitch(s, random_range(0.6, 0.8));
} else if (MPRESSED(mb_left)) {
	/*if (selected_hex != noone && selected_hex.vision == true) {
		if (selected_hex == targeted_hex) {
			set_player_dest();
			targeted_hex = noone;
		} else {
			targeted_hex = selected_hex;
		}
	}*/
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