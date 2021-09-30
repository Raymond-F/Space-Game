// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// This function initializes all the base flags in the game to their default values
function initialize_flags(){
	flag_set("flag_test", 0);
	flag_set("flag_test_quest", 0);
}

function initialize_tooltips() {
	var tt = ds_map_create();
	
	ds_map_add_unique(tt, "supplies", "Food, water, and other basic needs. Your crew consumes, at baseline, one unit of supplies per ten crew per cycle. If you run out, your crew will be unhappy.");
	ds_map_add_unique(tt, "fuel", "Fusion fuel used to power a shipboard impulse drive. You need this to move, or do pretty much anything.");
	ds_map_add_unique(tt, "alloys", "A mix of alloys good for shipbuilding and other industrial tasks. Valuable, both as a trade good and to patch up holes in your ship.");
	ds_map_add_unique(tt, "precious metals", "An assortment of valuable metals like gold and palladium. This fetches a very high price, but isn't good for much to a captain.");
	ds_map_add_unique(tt, "electronics", "Wires, conductors, circuitboards, you name it. Probably useful in some situations and also fetches a decent price.");
	
	return tt;
}