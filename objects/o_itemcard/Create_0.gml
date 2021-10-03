/// @description Insert description here
// You can write your code in this editor
par = noone;
pos = -1; // position in inventory list this corresponds to
name = "";
quantity = 1;
sprite = s_cargo_placeholder;
y_cutoff = [99999, 0]; // Point at which this card becomes inactive: [> top, <bottom]
active = true;
current_target = noone;
transfer_target = noone;
struct = noone;

value = 100;
// If selling is true, this will add its value to the player's PIX total.
selling = false;
// If buying is true, this will be subtracted from the player's PIX total. It will also prevent the player from
// buying additional when they do not have enough money.
buying = false;

tooltip_delay = 60;
tooltip_timer = tooltip_delay;
mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;