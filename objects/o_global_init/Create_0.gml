/// @description Insert description here
// You can write your code in this editor
ts_init();
global.controller = noone;
global.debug = false;
room_goto(room_next(room));
randomize();
global.sprite_map = initialize_sprite_map();
draw_set_circle_precision(64);
//bookkeeping
global.zone_width = 100;
global.zone_height = 50;
global.current_zone = 1;
global.player = noone;
global.player_x = irandom_range(30, 70)
global.player_y = irandom_range(20, 30)
global.camera_constraints = [0, 0, 99999, 99999];
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
//data structures
global.sector_map = sector_map_init();
global.flags = ds_map_create();
initialize_flags();
global.shiplist = initialize_shipinfo();
global.itemlist_modules = initialize_itemlist_modules();
global.itemlist_weapons = initialize_itemlist_weapons();
global.itemlist_cargo = initialize_itemlist_cargo();
global.player_ship = initialize_default_player_ship();
sector_map_init();
initialize_default_player_inventory();
player_ship_save();
player_ship_load();
//other flags
global.battle_file = "testbattle.txt";
global.loot_file = "testloot.txt";

enum context {
	zone_map,
	sector_map,
	battle
}
global.context = context.sector_map;
global.previous_context = context.sector_map;

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