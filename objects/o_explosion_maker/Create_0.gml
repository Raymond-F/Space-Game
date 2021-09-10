/// @description Insert description here
// You can write your code in this editor
make_explosion_in_ship_bbox = function() {
	return instance_create(irandom_range(par.bbox_left, par.bbox_right),
			     irandom_range(par.bbox_top, par.bbox_bottom), o_explosion);
}

par = noone;
wave1_timer = irandom_range(30, 50);
wave1_count = irandom_range(6, 9);
wave2_timer = irandom_range(110, 140);
wave2_count = irandom_range(11, 14);
wave3_timer = irandom_range(200, 230);
wave3_count = irandom_range(17, 19);
explosion_delay = 0;