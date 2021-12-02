/// @description Insert description here
// You can write your code in this editor
function combat_init() {
	player = combat_create_ship(global.player_ship, true);
	if (global.local_ship == noone) {
		enemy = combat_create_ship(load_ship_from_file(battle_file), false);
	} else {
		enemy = combat_create_ship(global.local_ship.ship_struct, false);
	}
	player.opponent = enemy;
	player.targ_y = player.y;
	//Set up per-ship variables
	player.y += VIEW_HEIGHT;
	for(var i = 0; i < array_length(player.hardpoints) ; i++) {
		if (player.hardpoints[i] == noone) {
			continue;
		}
		player.hardpoints[@ i].y += VIEW_HEIGHT;
	}
	enemy.opponent = player;
	enemy.targ_y = enemy.y;
	enemy.y += VIEW_HEIGHT;
	for(var i = 0; i < array_length(enemy.hardpoints) ; i++) {
		if (enemy.hardpoints[i] == noone) {
			continue;
		}
		enemy.hardpoints[@ i].y += VIEW_HEIGHT;
	}
	if(player.entrance_delay < enemy.entrance_delay) {
		enemy.entrance_delay += 20;
	} else {
		player.entrance_delay += 20;
	}
	//Set up position for HUD objects
	var player_weapons = player.hardpoints;
	var enemy_weapons = enemy.hardpoints;
	var wep_hud_start_y = 110;
	for(var i = 0; i < array_length(player_weapons); i++) {
		if (player_weapons[i] == noone) continue;
		player_weapons[i].hud.x = 10;
		player_weapons[i].hud.y = wep_hud_start_y + (4 + sprite_get_height(s_weapon_hud)) * i;
	}
	for(var i = 0; i < array_length(enemy_weapons); i++) {
		if (enemy_weapons[i] == noone) continue;
		enemy_weapons[i].hud.x = GUIW - 10 - sprite_get_width(s_weapon_hud);
		enemy_weapons[i].hud.y = wep_hud_start_y + (4 + sprite_get_height(s_weapon_hud)) * i;
	}
	//Make hanger-on objects
	with(instance_create(player.x, player.y, o_shield)) {
		other.player.shield_object = id;
		par = other.player;
	}
	with(instance_create(enemy.x, enemy.y, o_shield)) {
		other.enemy.shield_object = id;
		par = other.enemy;
	}
	for (var i = 0; i < array_length(player.engines); i++) {
		var eng = instance_create(player.x + player.engines[i][0], player.y + player.engines[i][1], o_engineburn);
		eng.par = player;
		eng.image_xscale = player.engines[i][2];
		eng.image_yscale = eng.image_xscale;
	}
	for (var i = 0; i < array_length(enemy.engines); i++) {
		var eng = instance_create(enemy.x + enemy.engines[i][0], enemy.y + enemy.engines[i][1], o_engineburn);
		eng.par = enemy;
		eng.image_xscale = enemy.engines[i][2];
		eng.image_yscale = eng.image_xscale;
	}
	
	// Disable zone map objects temporarily
	zonemap_deactivate_objects();
}

battle_file = global.battle_file;
fade = 0;
faded_in = false;
fading_out = false;
final_fade = false;
depth = -1;
moveline_timer = irandom_range(10, 20);
end_of_battle_timer = 300;
audio_sound_gain(global.ambience_id, 0, 1000);