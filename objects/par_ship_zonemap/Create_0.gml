/// @description Insert description here
// You can write your code in this editor
tx = x;
ty = y;
x_display = x;
y_display = y;
hex = get_hex(x, y);
hex.contained_ship = id;
depth = -20;
sensor_range = 5;
jump_range = 3; // Will be calculated later
pathable_hexes = [];
visible_hexes = [];
combat_power = 0;
active = true;
is_bounty_target = false;

exit_burst = true;

faction = factions.civilian;