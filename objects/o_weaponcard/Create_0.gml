/// @description Insert description here
// You can write your code in this editor

// Finds the first unoccupied socket of this object's class or larger
find_first_unoccupied_socket = function() {
	for (var i = 0; i < ds_list_size(par.sockets); i++) {
		var socket = par.sockets[|i];
		if (socket.contained == noone) {
			return socket;
		}
	}
	return noone;
}

par = noone;
pos = -1; // position in module list this corresponds to
name = "";
quantity = 1;
sprite = s_cargo_placeholder;
y_cutoff = [99999, 0]; // Point at which this card becomes inactive: [> top, <bottom]
active = true;
struct = noone;
invalid = false;

tooltip_delay = 30;
tooltip_timer = tooltip_delay;
mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;