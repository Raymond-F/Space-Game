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
		}
	}
}
else {
	fade = max(fade-0.02, 0);
	if(final_fade && fade <= 0) {
		instance_destroy();
	}
}
if(faded_in) {
	moveline_timer--;
	if(moveline_timer <= 0) {
		instance_create(irandom_range(50, VIEW_WIDTH-50), 0, o_moveline);
		moveline_timer = irandom_range(10, 25);
	}
}

// Break shield
if(PRESSED(ord("B"))) {
	enemy.shield_current = 0;
}
if(PRESSED(ord("E"))) {
	instance_create(VIEW_WIDTH/2, VIEW_HEIGHT/2, o_explosion);
}
if(PRESSED(ord("D"))) {
	enemy.shield_current = 0;
	enemy.hull_current = 0;
}