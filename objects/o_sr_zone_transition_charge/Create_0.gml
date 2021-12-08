/// @description Insert description here
// You can write your code in this editor
depth = -y - 500;
timer = 180;
start_timer = timer;
dir = DIR_NORTH;

mote_chance = 0.04;
mote_increment = 0.001;
mote_speed = 2;

var a = global.player.image_angle + 180;
var xx = global.player.x + lengthdir_x(24, a);
var yy = global.player.y + lengthdir_y(24, a);
buildup_center = [xx, yy];
buildup_size = 10;

motes = ds_list_create();