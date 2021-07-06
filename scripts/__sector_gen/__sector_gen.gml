// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function zone(_id, _list, _x, _y) constructor {
	zone_id = _id;
	list = _list;
	xpos = _x;
	ypos = _y;
	cnx = ds_list_create(); //connections
	boundary = 50; //boundary from edges of map
	
	static destroy = function(){
		ds_list_destroy(cnx);
	}
	
	static get_nearest = function(){
		var nearest, nearest_dist;
		if(list[|0].zone_id == zone_id){
			nearest = list[|1];
			nearest_dist = point_distance(xpos, ypos, nearest.xpos, nearest.ypos);
		}
		else {
			nearest = list[|0];
			nearest_dist = point_distance(xpos, ypos, nearest.xpos, nearest.ypos);
		}
		for(var i = 0; i < ds_list_size(list); i++){
			var new_dist = point_distance(xpos, ypos, list[|i].xpos, list[|i].ypos);
			if(nearest != self && new_dist < nearest_dist) {
				nearest = list[|i];
				nearest_dist = new_dist;
			}
		}
		return nearest;
	}
	
	static get_distance_to_nearest = function(){
		var n = get_nearest(list);
		return point_distance(xpos, ypos, n.xpos, n.ypos);
	}
	
	//wiggle by a random amount. This is done lots of times to space out the zones. Wiggles away from nearest neighbor.
	static wiggle = function(_w, _h){
		var count = 0;
		var starting_distance = get_distance_to_nearest();
		var tempx = xpos, tempy = ypos;
		do {
			xpos = tempx;
			ypos = tempy;
			var xchange, ychange;
			do {
				xchange = irandom_range(-15, 15);
				ychange = irandom_range(-15, 15);
			} until (xpos + xchange > boundary && xpos + xchange < (_w - boundary) &&
					 ypos + ychange > boundary && ypos + ychange < (_h - boundary));
		    count++;
			xpos += xchange;
			ypos += ychange;
		} until (count > 50 || get_distance_to_nearest() > starting_distance);
		if (count > 50) {
			xpos = tempx;
			ypos = tempy;
		}
	}
	
	//connect two zones
	static connect = function(_other){
		if(ds_list_find_index(cnx, _other) < 0){
			ds_list_add(cnx, _other);
			ds_list_add(_other.cnx, self);
		}
	}
	
	//get the nearest unconnected zone
	static get_nearest_unconnected = function(){
		var nearest, nearest_dist;
		//always start on a zone that isn't in the connections list
		for(var i = 0; i < ds_list_size(list); i++){
			var z = list[|i];
			if(z.zone_id == zone_id || ds_list_find_index(cnx, z) >= 0){
				continue;
			}
			nearest = list[|i];
			nearest_dist = point_distance(xpos, ypos, nearest.xpos, nearest.ypos);
			break;
		}
		for(var i = 0; i < ds_list_size(list); i++){
			var new_dist = point_distance(xpos, ypos, list[|i].xpos, list[|i].ypos);
			if(nearest != self && 
			new_dist < nearest_dist && 
			ds_list_find_index(cnx, list[|i]) < 0) {
				nearest = list[|i];
				nearest_dist = new_dist;
			}
		}
		return nearest;
	}
	
	//generate a connection to the nearest unconnected zone within a certain max range
	//returns true if a connection is made, else returns false
	static connect_to_nearest = function(_max){
		var nearest = get_nearest_unconnected();
		if(point_distance(xpos, ypos, nearest.xpos, nearest.ypos) < _max){
			connect(nearest);
			return true;
		}
		else return false;
	}
	
}

//accessors for zones
function zone_getx(z){
	return variable_struct_get(z, "xpos");
}
function zone_gety(z){
	return variable_struct_get(z, "ypos");
}
function zone_getcnx(z){
	return variable_struct_get(z, "cnx");
}

//returns the smallest distance that exists between any two zones on the map
function get_nearest_neighbors(_list) {
	var nearest = 999999;
	for(var i = 0; i < ds_list_size(_list); i++) {
		//var dist = script_execute(variable_struct_get(_list[|i], "get_distance_to_nearest"));
		var dist = _list[|i].get_distance_to_nearest();
		if(dist < nearest){
			nearest = dist;
		}
	}
	return nearest;
}

//returns the largest distance between any zone and its nearest zone
function get_largest_isolation(_list) {
	var largest = 0;
	for(var i = 0; i < ds_list_size(_list); i++) {
		var dist = _list[|i].get_distance_to_nearest();
		if(dist < nearest){
			nearest = dist;
		}
	}
	return largest;
}

//returns the nearest zone to an arbitrary point
function get_nearest_zone(_list, _x, _y){
	var nearest, nearest_dist;
	if(ds_list_size(_list) == 0){
		return noone;
	}
	nearest = _list[|0];
	nearest_dist = point_distance(_x, _y, nearest.xpos, nearest.ypos);
	for(var i = 1; i < ds_list_size(_list); i++){
		var new_dist = point_distance(_x, _y, _list[|i].xpos, _list[|i].ypos);
		if(new_dist < nearest_dist) {
			nearest = _list[|i];
			nearest_dist = new_dist;
		}
	}
	return nearest;
}

function try_generate_map() {
	var _boundary = 50;
	var _map_width = 1280;
	var _map_height = 720;
	var _minimum_distance = 100; //minumum distance between two zones
	var _maximum_isolation = 500; //maximum distance a zone can be from its nearest neighbor
	var _maximum_connection_distance = 200;
	var zone_list = ds_list_create();
	var num_zones = irandom_range(30, 40);
	//scatter zones across the map
	for (var i = 0; i < num_zones; i++){
		var xcheck, ycheck;
		var zone = noone;
		do {
			xcheck = irandom_range(_boundary, _map_width - _boundary);
			ycheck = irandom_range(_boundary, _map_height - _boundary);
			zone = get_nearest_zone(zone_list, xcheck, ycheck);
		} until (zone == noone || point_distance(xcheck, ycheck, zone.xpos, zone.ypos) > _minimum_distance);
		ds_list_add(zone_list, new zone(i, zone_list, xcheck, ycheck));
	}
	//generate "easy" connections
	for (var i = 0; i < num_zones; i++){
		var zone = zone_list[|i];
		while(zone.connect_to_nearest(_maximum_connection_distance)){};
	}
	return zone_list;
}

function generate_sector(){
	var map = ds_list_create();
	var success = false;
	//verify a flood fill reaches all nodes. If not we can just regenerate!
	do {
		ds_list_destroy(map);
		map = try_generate_map();
		var discovered_nodes = ds_list_create();
		for(var i = 0; i < ds_list_size(map); i++){
			var cnx = map[|i].cnx;
			for(var j = 0; j < ds_list_size(cnx); j++){
				if(ds_list_find_index(discovered_nodes, cnx[|j]) < 0){
					ds_list_add(discovered_nodes, cnx[|j]);
				}
			}
		}
		if(ds_list_size(discovered_nodes) == ds_list_size(map)){
			success = true;
		}
	} until (success);
	return map;
}