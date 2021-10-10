/// @description Insert description here
// You can write your code in this editor
if (global.dragged_module == noone && mouse_collision_gui()) {
	if (MPRESSED(mb_right)) {
		if (contained != noone) {
			audio_play_sound(snd_interface_install, 30, false);
		}
		unassign_module();
	} else if (MPRESSED(mb_left) && contained != noone && !locked) {
		global.dragged_module = id;
	}
}

if (global.dragged_module == id && MRELEASED(mb_left)) {
	var done = false;
	var dragged_contained = contained;
	with (o_modulesocket) {
		if (id != global.dragged_module.id && mouse_collision_gui()) {
			if (!locked && class >= global.dragged_module.contained.class && (contained == noone || global.dragged_module.class >= contained.class)) {
				global.dragged_module.contained = noone;
				var my_contained = contained;
				contained = noone;
				assign_module(dragged_contained);
				with (global.dragged_module) {
					assign_module(my_contained);
				}
				audio_play_sound(snd_interface_install, 30, false);
			} else {
				audio_play_sound(snd_interface_deadclick, 30, false);
			}
			done = true;
			break;
		}
	} if (!done) {
		var in_collider = false;
		if (instance_exists(o_modulecard_list_dropbox)) {
			with (o_modulecard_list_dropbox) {
				if (point_in_rectangle(MOUSE_GUIX, MOUSE_GUIY, coords[0], coords[1], coords[2], coords[3])) {
					in_collider = true;
				}
			}
		}
		if (in_collider) {
			unassign_module();
			audio_play_sound(snd_interface_install, 30, false);
		}
	}
	global.dragged_module = noone;
}