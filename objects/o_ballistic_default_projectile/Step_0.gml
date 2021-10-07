/// @description Insert description here
// You can write your code in this editor
event_inherited();
if (point_distance(x, y, tx, ty) < spd && hit) {
	x = tx;
	y = ty;
	damage_hull(id, target);
	var s = audio_play_sound(choose(snd_combat_hullhit_bullet, snd_combat_hullhit_bullet2, snd_combat_hullhit_bullet3), 10, false);
	audio_sound_pitch(s, random_range(0.9, 1.1));
	instance_destroy();
}
else {
	x += lengthdir_x(spd, image_angle);
	y += lengthdir_y(spd, image_angle);
}
var shield = collision_point(x, y, o_shield, true, true);
if (instance_exists(par.opponent) && par.opponent.shield_current > 0 && shield != noone && shield.par != par) {
	while(collision_point(x, y, shield, true, false)) {
		x -= lengthdir_x(1, image_angle);
		y -= lengthdir_y(1, image_angle);
	}
	damage_shield(id, shield);
	audio_play_sound(snd_combat_shieldhit, 10, false);
	instance_destroy();
}