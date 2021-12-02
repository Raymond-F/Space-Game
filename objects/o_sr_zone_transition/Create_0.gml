/// @description Insert description here
// You can write your code in this editor
setup = false;
timer = 300;
dir = DIR_NORTH;

flash_alpha = 1.2;

speedline_chance = 0.1;

ship_x = 0;
ship_y = 0;
ship_speed = 0;
travel_angle = 0;

sound = audio_play_sound(snd_transition_travel, 50, true);
pitch = 1;