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
global.current_turn = 0; // global current turn value. Increments 1 per player turn.
global.current_zone = 1;
global.zone_tags = [etags.always];
global.player = noone;
global.player_x = irandom_range(30, 70)
global.player_y = irandom_range(20, 30)
global.camera_constraints = [0, 0, 99999, 99999];
global.sensor_range = 5;
global.event_current_object = noone; // the object pertaining to the event currently happening.
global.settlement_list = ds_list_create(); // tracks all settlement structs.
global.pressed_button = noone; // Tracking for the last button pressed. Needed because GMS is weird about variable functions.
global.active_shop = noone; // Actively open shop.
global.dragged_module = noone; // Module being dragged in the management screen.
global.editing_ship = noone; // The ship being edited currently. Merged with the player ship on exit of management screen.
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
global.flags = ds_map_create();
initialize_flags();
initialize_shipinfo();
initialize_itemlist_modules();
initialize_itemlist_weapons();
initialize_itemlist_cargo();
global.event_list = initialize_event_list();
global.player_ship = initialize_default_player_ship();
global.item_tooltips = initialize_item_tooltips();
initialize_default_player_inventory();
global.sector_map = sector_map_init();
player_ship_save();
player_ship_load();
//other flags
global.battle_file = "testbattle.txt";
global.postbattle_file = "";
global.loot_file = "testloot.txt";

enum context {
	zone_map,
	sector_map,
	battle
}
global.context = context.zone_map;
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