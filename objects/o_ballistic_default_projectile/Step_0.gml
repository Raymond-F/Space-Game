/// @description Insert description here
// You can write your code in this editor
if (point_distance(x, y, tx, ty) < spd && hit) {
	x = tx;
	y = ty;
	damage_hull(id, target);
	instance_destroy();
}
else {
	x += lengthdir_x(spd, image_angle);
	y += lengthdir_y(spd, image_angle);
}
var shield = collision_point(x, y, o_shield, true, true);
if (instance_exists(par.opponent) && par.opponent.shield_current > 0 && shield != noone && shield.par != par) {
	while(collision_point(x, y, shield, true, false)) {
		x -= lengthdir_x(1, image_angle);
		y -= lengthdir_y(1, image_angle);
	}
	damage_shield(id, shield);
	instance_destroy();
}