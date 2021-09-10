/// @description Insert description here
// You can write your code in this editor
wave1_timer--;
wave2_timer--;
wave3_timer--;
explosion_delay = max(explosion_delay - 1, 0);
if(wave1_timer <= 0 && wave1_count > 0 && explosion_delay == 0) {
	make_explosion_in_ship_bbox();
	wave1_count--;
	explosion_delay = irandom_range(2, 4);
}
if(wave2_timer <= 0 && wave2_count > 0 && explosion_delay == 0) {
	with(make_explosion_in_ship_bbox()) {
		image_xscale *= 1.25;
		image_yscale *= 1.25;
	}
	wave2_count--;
	explosion_delay = irandom_range(2, 4);
}
if(wave3_timer <= 0 && wave3_count > 0 && explosion_delay == 0) {
	with(make_explosion_in_ship_bbox()) {
		image_xscale *= 1.5;
		image_yscale *= 1.5;
	}
	wave3_count--;
	explosion_delay = irandom_range(2, 4);
}
if(wave3_count <= 0) {
	instance_destroy();
}