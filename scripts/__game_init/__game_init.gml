// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// This function initializes all the base flags in the game to their default values
function initialize_flags(){
	flag_set("flag_test", 0);
	flag_set("flag_test_quest", 0);
}

function initialize_item_tooltips() {
	var tt = ds_map_create();
	
	ds_map_add_unique(tt, "supplies", "Food, water, and other basic needs. Your crew consumes, at baseline, one unit of supplies per ten crew per cycle. If you run out, your crew will be unhappy.");
	ds_map_add_unique(tt, "fuel", "Fusion fuel used to power a shipboard impulse drive. You need this to move, or do pretty much anything.");
	ds_map_add_unique(tt, "alloys", "A mix of alloys good for shipbuilding and other industrial tasks. Valuable, both as a trade good and to patch up holes in your ship.");
	ds_map_add_unique(tt, "precious metals", "An assortment of valuable metals like gold and palladium. This fetches a very high price, but isn't good for much to a captain.");
	ds_map_add_unique(tt, "electronics", "Wires, conductors, circuitboards, you name it. Probably useful in some situations and also fetches a decent price.");
	ds_map_add_unique(tt, "raw iron", "Iron ore pulled from local comets. This can be refined into alloys by some settlements and can fetch a nice price there.");
	ds_map_add_unique(tt, "raw ice", "Unprocessed water ice harvested from local comets. Water is the source of all life, and so this is unsurprisingly in high demand despite being relatively common in the Kaib.");
	ds_map_add_unique(tt, "natural fibers", "Plant fibers grown and harvested in large agri-pods aboard settlement platforms. Not as strong as synthetic stuff, but significantly more comfortable and aesthetically pleasing.");
	ds_map_add_unique(tt, "synthetic fibers", "Textiles made in a processing plant. Usually made from plastics and assorted volatiles, these offer high tensile strength and durability for their cost. However, they tend to be rather unflattering and stiff for personal uses.");
	
	return tt;
}