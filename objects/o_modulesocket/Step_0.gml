/// @description Insert description here
// You can write your code in this editor
if (mouse_collision_gui() && MPRESSED(mb_right)) {
	if (contained != noone) {
		audio_play_sound(snd_interface_install, 30, false);
	}
	unassign_module();
}