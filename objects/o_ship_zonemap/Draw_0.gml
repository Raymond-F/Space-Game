/// @description Insert description here
// You can write your code in this editor
if (!draw_setup) {
	draw_setup = true;
	switch(faction) {
		case factions.empire: sprite_index = s_zonemap_ship_empire; break;
		case factions.kfed: sprite_index = s_zonemap_ship_kfed; break;
		case factions.pirate: sprite_index = s_zonemap_ship_pirate; break;
		case factions.rebel: sprite_index = s_zonemap_ship_rebel; break;
		case factions.civilian: sprite_index = s_zonemap_ship_civilian; break;
	}
	image_speed = 0;
}
draw_self();