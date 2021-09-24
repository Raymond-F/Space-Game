/// @description Insert description here
// You can write your code in this editor
global.pix = 300;
global.crew = 20;
global.supplies = 10;
global.fuel = 100;
global.gunnery = 15;
global.maneuvering = 15;
global.leadership = 15;
global.tech = 15;
global.guts = 15;
global.wits = 15;
global.will = 15;
global.charm = 15;
setup = false;
instance_create(0,0,o_controller);
instance_create(0,0,o_gui);
zone_create(global.sector_map[? global.current_zone]);
// instance_create(VIEW_WIDTH/2, VIEW_HEIGHT/2, o_testshield);
// instance_create(0,0,o_testarc);