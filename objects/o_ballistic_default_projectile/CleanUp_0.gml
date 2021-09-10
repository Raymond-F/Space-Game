/// @description Insert description here
// You can write your code in this editor
with (instance_create(x, y, o_projectile_hitfx)) {
	image_angle = other.image_angle;
	sprite_index = s_projectile_ballistic_hit;
	depth = other.depth - 10;
}