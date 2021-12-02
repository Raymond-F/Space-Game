/// @description Insert description here
// You can write your code in this editor
event_inherited();

action_delay = max(-1, action_delay-1);
if (action_delay == 0) {
	switch (action) {
		case player_actions.nothing : break;
		case player_actions.hail: zonemap_hail_ship(global.local_ship); break;
		case player_actions.attack: combat_setup(); break;
	}
}