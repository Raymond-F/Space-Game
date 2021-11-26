/// @description Insert description here
// You can write your code in this editor
ds_list_delete(global.ship_registry, ds_list_find_index(global.ship_registry, id));
var me = id;
with(o_zonemap_location) {
	for (var i = 0; i < array_length(patrols); i++) {
		if (patrols[i] == me) {
			patrols[i] = noone;
		}
	}
}