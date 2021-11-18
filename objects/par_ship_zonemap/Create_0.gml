/// @description Insert description here
// You can write your code in this editor
tx = x;
ty = y;
hex = get_hex(x, y);
depth = -20;
sensor_range = 5;
jump_range = 3; // Will be calculated later
pathable_hexes = [];
visible_hexes = [];

exit_burst = true;

faction = factions.civilian;