/// @description Insert description here
// You can write your code in this editor
if (!setup) {
	setup = true;
	ship_speed = 1;
	travel_angle = direction_get_angle(dir);
	var xbase = (VIEW_RIGHT + VIEW_LEFT) / 2;
	var ybase = (VIEW_TOP + VIEW_BOTTOM) / 2;
	var dist = (dir == DIR_EAST || dir == DIR_WEST) ? VIEW_WIDTH*5 / 9 : VIEW_HEIGHT * 5 / 9;
	xbase -= lengthdir_x(dist, travel_angle);
	ybase -= lengthdir_y(dist, travel_angle);
	ship_x = xbase;
	ship_y = ybase;
}


timer--;

if (timer <= 0) {
	global.camera.locked = false;
	global.current_zone = global.target_zone;
	zone_create(global.sector_map[? global.target_zone], false);
	audio_stop_sound(sound);
	audio_play_sound(snd_transition_arrive, 50, false);
	instance_destroy();
}

if (random(1) < speedline_chance) {
	var xx, yy;
	switch (dir) {
		case DIR_EAST: xx = VIEW_RIGHT; yy = irandom_range(VIEW_TOP, VIEW_BOTTOM); break;
		case DIR_WEST: xx = VIEW_LEFT; yy = irandom_range(VIEW_TOP, VIEW_BOTTOM); break;
		case DIR_NORTH: yy = VIEW_TOP; xx = irandom_range(VIEW_LEFT, VIEW_RIGHT); break;
		case DIR_SOUTH: yy = VIEW_BOTTOM; xx = irandom_range(VIEW_LEFT, VIEW_RIGHT); break;
	}
	var line = instance_create(xx, yy, o_speedline_transition);
	line.origin_dir = dir;
}

ship_x += lengthdir_x(ship_speed, travel_angle);
ship_y += lengthdir_y(ship_speed, travel_angle);
if (dir == DIR_EAST || dir == DIR_WEST) {
	ship_speed += 0.02;
} else {
	ship_speed += 0.01;
}
if (timer < 120) {
	if (dir == DIR_EAST || dir == DIR_WEST) {
		ship_speed += 0.15;
	} else {
		ship_speed += 0.075;
	}
} else if (timer < 150) {
	if (dir == DIR_EAST || dir == DIR_WEST) {
		ship_speed += 0.12;
	} else {
		ship_speed += 0.06;
	}
} else if (timer < 180) {
	if (dir == DIR_EAST || dir == DIR_WEST) {
		ship_speed += 0.09;
	} else {
		ship_speed += 0.045;
	}
}

if (timer < 120) {
	pitch += 0.01;
	audio_sound_pitch(sound, pitch);
}