/// @description Insert description here
// You can write your code in this editor
if(!faded_in || fading_out) {
	fade += 0.02;
	if(fade >= 1) {
		if(!faded_in) {
			faded_in = true;
			combat_init();
			global.previous_context = global.context;
			global.context = context.battle;
		}
		else {
			global.context = global.previous_context;
			global.previous_context = context.battle;
			final_fade = true;
			fading_out = false;
			with(o_ship) instance_destroy();
			with(par_weapon) instance_destroy();
			with(o_engineburn) instance_destroy();
			with(par_projectile) instance_destroy();
			with(o_shield) instance_destroy();
			with(o_moveline) instance_destroy();
			with(o_weapon_hud) instance_destroy();
			// Enable zone map objects again
			zonemap_activate_objects();
			// Clear combat audio
			audio_stop_all();
			start_ambience();
		}
	}
} else {
	fade = max(fade-0.02, 0);
	if(final_fade && fade <= 0) {
		instance_create(GUIW/2 - sprite_get_width(s_inventory_pane)/2, GUIH/2 - sprite_get_height(s_inventory_pane)/2, o_loot_pane);
		instance_destroy();
	}
}
if(faded_in && !fading_out && !final_fade) {
	moveline_timer--;
	if(moveline_timer <= 0) {
		instance_create(irandom_range(50, VIEW_WIDTH-50), 0, o_moveline);
		moveline_timer = irandom_range(10, 25);
	}
}
if(faded_in && !final_fade && (player.hull_current <= 0 || enemy.hull_current <= 0)) {
	end_of_battle_timer--;
}
if(end_of_battle_timer == 0 && !fading_out) {
	fading_out = true;
}

// Break shield
if(PRESSED(ord("B"))) {
	enemy.shield_current = 0;
}
if(PRESSED(ord("E"))) {
	instance_create(VIEW_WIDTH/2, VIEW_HEIGHT/2, o_explosion);
}
// Kill enemy ship
if(PRESSED(ord("D"))) {
	enemy.shield_current = 0;
	enemy.hull_current = 0;
}