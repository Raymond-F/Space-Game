/// @description Insert description here
// You can write your code in this editor
depth = par.depth - 10;

charge = min(charge + (1/60) * par.weapon_charge_multiplier, charge_max);

if(ai != noone) {
	ai();
}