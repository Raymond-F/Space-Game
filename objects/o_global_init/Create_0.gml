/// @description Insert description here
// You can write your code in this editor
ts_init();
global.controller = noone;
global.debug = false;
room_goto(room_next(room));
randomize();
global.sprite_map = initialize_sprite_map();
global.pix = 0;