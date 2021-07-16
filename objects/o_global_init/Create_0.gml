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

/*
//code for testing the recursive evaluation function
flag_set("flag1", 1);
flag_set("flag2", 5);
flag_set("flag3", 5);
flag_set("flag4", 10);
flag_set("flag5", 0);
flag_set("flag6", 15);
var test_text = "flag1 LTE 0 OR ((flag2 EQ 5 AND flag3 NOT 5) OR (flag4 EQ 10 AND flag5 EQ 2) OR flag6 NOT 15)"
var output = evaluate_conditional(string_tokenize(test_text), CONDTYPE_FLAG);//should be false
var i = output;
var test_text2 = "flag1 EQ 1";
output = evaluate_conditional(string_tokenize(test_text2), CONDTYPE_FLAG);//should be true
i = output;
*/