/// @description Insert description here
// You can write your code in this editor
ts_init();
global.controller = noone;
global.debug = false;
room_goto(room_next(room));
randomize();
global.sprite_map = initialize_sprite_map();
draw_set_circle_precision(64);
cursor_sprite = s_cursor;
window_set_cursor(cr_none);
//bookkeeping
global.player_name = "Player";
global.num_sector_rings = 5;
global.zone_width = 100;
global.zone_height = 50;
global.current_turn = 0; // global current turn value. Increments 1 per player turn.
global.current_zone = 1;
global.zone_tags = [etags.always];
global.player = noone;
global.player_x = irandom_range(30, 70)
global.player_y = irandom_range(20, 30)
global.camera_constraints = [0, 0, 99999, 99999];
global.event_current_object = noone; // the object pertaining to the event currently happening.
global.settlement_list = ds_list_create(); // tracks all settlement structs.
global.pressed_button = noone; // Tracking for the last button pressed. Needed because GMS is weird about variable functions.
global.active_settlement = noone;
global.active_shop = noone; // Actively open shop.
global.dragged_module = noone; // Module being dragged in the management screen.
global.dragged_weapon = noone; // Weapon being dragged in the management screen.
global.editing_ship = noone; // The ship being edited currently. Merged with the player ship on exit of management screen.
global.ui_layer = 0;
global.last_player_scan = -50;
global.player_scan_cooldown = 50;
global.ship_registry = ds_list_create(); // Registry of local non-player ship objects
global.local_ship = noone; // Local ship object for things like patrols to be fought.
global.target_zone = global.current_zone;
global.zone_transition_coords = [0, 0];
global.current_contract = noone;
global.cargo_current = 0; // Current occupied hold space in weight units
global.cargo_max = 0; // Maximum hold space in weight units
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
cargo_set_weight_values();
global.sector_map = sector_map_init();
player_ship_save();
player_ship_load();
//other flags
global.battle_file = "testbattle.txt";
global.postbattle_file = "";
global.loot_file = "testloot.txt";
global.loot_rolls = 0;
global.player_victory = true;

enum context {
	zone_map,
	sector_map,
	battle
}
global.context = context.zone_map;
global.previous_context = context.sector_map;

// faction stuff
enum factions {
	player,
	empire,
	rebel,
	kfed,
	pirate,
	civilian
}
global.faction_priority = [factions.empire, factions.rebel, factions.kfed, factions.pirate, factions.civilian];
enum faction_relation_level {
	reviled = 0,
	hostile = 1,
	unwelcome = 2,
	neutral = 3,
	liked = 4,
	trusted = 5,
	allied = 6
}
// The player has the relation of the highest threshold they meet with a faction.
global.faction_relation_thresholds = [-100, -80, -50, -20, 20, 50, 80];

global.faction_enemies = ds_map_create();
ds_map_add(global.faction_enemies, factions.empire, [factions.rebel, factions.pirate]);
ds_map_add(global.faction_enemies, factions.rebel, [factions.empire, factions.kfed, factions.pirate]);
ds_map_add(global.faction_enemies, factions.kfed, [factions.rebel, factions.pirate]);
ds_map_add(global.faction_enemies, factions.pirate, [factions.empire, factions.kfed, factions.rebel, factions.pirate, factions.civilian]);
ds_map_add(global.faction_enemies, factions.civilian, [factions.pirate]);
global.player_relations = ds_map_create();
ds_map_add(global.player_relations, factions.empire, 0);
ds_map_add(global.player_relations, factions.rebel, 0);
ds_map_add(global.player_relations, factions.kfed, 10);
ds_map_add(global.player_relations, factions.pirate, -80);
ds_map_add(global.player_relations, factions.civilian, 0);

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