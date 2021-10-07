/// @description Insert description here
// You can write your code in this editor
if(entrance_delay == 1) {
	instance_create(0, 0, o_screenflash);
	var s = audio_play_sound(snd_combat_jumpin, 20, false);
	audio_sound_pitch(s, random_range(0.9, 1.1));
}
entrance_delay = max(entrance_delay - 1, 0);
if(entrance_delay == 0) {
	y = lerp(y, targ_y, 0.2);
}
if (hull_current <= 0 && !created_deathfx) {
	created_deathfx = true;
	with(instance_create(x, y, o_explosion_maker)) {
		par = other.id;
	}
}