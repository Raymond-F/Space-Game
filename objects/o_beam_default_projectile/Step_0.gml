/// @description Insert description here
// You can write your code in this editor
event_inherited();
if (target.shield_current > 0) {
	damage_shield(id, target.shield_object);
} else {
	damage_hull(id, target);
	explosion_timer--;
	if(explosion_timer <= 0){
		with(instance_create(tx, ty, o_explosion)) {
			x += random_range(-5, 5);
			y += random_range(-5, 5);
		}
		explosion_timer = irandom_range(6, 10);
	}
}

tx += xpf;
ty += ypf;

lifespan--;
if (lifespan <= 0) {
	instance_destroy();
}