/// @description Insert description here
// You can write your code in this editor
if (!setup) {
	setup = true;
	switch(type) {
		case location_type.settlement: {
			sprite_index = s_zonemap_settlement_small_icon;
		} break;
		case location_type.pirate_base: {
			sprite_index = s_zonemap_pirate_base_small;
		} break;
		case location_type.event: {
			sprite_index = s_zonemap_event_unknown;
		} break;
		case location_type.derelict: {
			sprite_index = s_zonemap_derelict;
		} break;
		case location_type.comet: {
			sprite_index = s_zonemap_comet;
		} break;
	}
	depth = -y - 1;
}