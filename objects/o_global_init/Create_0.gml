/// @description Insert description here
// You can write your code in this editor
ts_init();
global.controller = noone;
global.debug = false;
room_goto(room_next(room));
randomize();
global.sprite_map = initialize_sprite_map();
//resources
global.pix = 0;
global.crew = 0;
global.supplies = 0;
global.fuel = 0;
//attributes
global.gunnery = 0;
global.maneuvering = 0;
global.leadership = 0;
global.tech = 0;
global.guts = 0;
global.wits = 0;
global.will = 0;
global.charm = 0;
global.flags = ds_map_create();
initialize_flags();