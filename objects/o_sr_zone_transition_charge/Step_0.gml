/// @description Insert description here
// You can write your code in this editor
for (var i = 0; i < ds_list_size(motes); i++) {
	var coord = motes[| i];
	var xx = coord[0];
	var yy = coord[1];
	if (point_distance(xx, yy, buildup_center[0], buildup_center[1]) <= mote_speed) {
		ds_list_delete(motes, i);
		i--;
		continue;
	}
	var dir = point_direction(xx, yy, buildup_center[0], buildup_center[1]);
	xx += lengthdir_x(mote_speed, dir);
	yy += lengthdir_y(mote_speed, dir);
	motes[| i] = [xx, yy];
}
if (timer > 30 && random(1) < mote_chance) {
	var a = random(360);
	var arr = [buildup_center[0] + lengthdir_x(32, a), buildup_center[1] + lengthdir_y(32, a)];
	ds_list_add(motes, arr);
}
mote_chance += mote_increment;
buildup_size++;
timer--;
if (timer == 0) {
	global.camera.locked = true;
	with(o_controller_zonemap) {
		zone_transition(global.sector_map[? global.target_zone]);
	}
	audio_stop_sound(snd_transition_charge);
	audio_play_sound(snd_transition_jump, 50, false);
	instance_destroy();
}