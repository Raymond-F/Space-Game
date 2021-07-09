// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//option for the player to select. Contains text and a link to another node.
//if the link is empty, it closes the dialogue instead.
function dsys_option(_text, _link, _costs, _gains, _conds, _reqs) constructor {
	text = _text;
	link = _link;
	costs = _costs;
	gains = _gains;
	conds = _conds; //conditions have the format [TYPE_MACRO, val1, comparator, val2]
	reqs = _reqs;
}

//a node of dialogue, including main text and all option objects
//options is generally going to be an array.
function dsys_node(_name, _text, _options, _costs, _gains, _flags, _localflags) constructor {
	name = _name; //used to hash the node into a map
	text = _text;
	options = [];
	speaker = "Person";
	costs = _costs;
	gains = _gains;
	flags = _flags;
	localflags = _localflags;
	if(is_array(_options)){
		options = array_create(array_length(_options));
		for(var i = 0; i < array_length(_options); i++){
			options[i] = _options[i];
		}
	}
	else if (is_struct(_options)){
		options = [_options];
	}
	else {
		options = [dsys_option("<UNDEFINED OPTION ARRAY>", "", [], [])];
	}
}

// a fully formed dialogue object. This contains a map of node names to dialogue nodes,
// allowing the dialogue to load any node given its name string.
function dsys_dialogue(_node_array) constructor {
	map = ds_map_create();
	for(var i = 0; i < array_length(_node_array); i++) {
		var node = _node_array[i];
		ds_map_add(map, node.name, node);
	}
	
	static destroy = function() {
		ds_map_destroy(map);
	}
}

function dsys_parse_nodes_from_file(fname){
	fname = "dialogue\\" + fname; //set to correct directory
	if(!file_exists(fname)){
		show_debug_message("ERROR: could not open file with filename: " + fname);
		return noone;
	}
	var file = file_text_open_read(fname);
	if(file < 0){
		return noone;
	}
	var nodes = [];
	var ncount = 0;
	while(!file_text_eof(file)){
		var line = "";
		var node = [];
		var count = 0;
		do {
			line = file_text_readln(file);
			if(line != "\r\n"){
				line = string_delete(line, string_length(line)-1, 2);
				node[count] = line;
				count++;
			}
		} until (line == "\r\n" || file_text_eof(file));
		nodes[ncount] = node;
		ncount++;
	}
	//we should now have an array of each node object.
	file_text_close(file);
	return nodes;
}

function dsys_parse_node_from_array(arr){
	var GET_TYPE = 0;
	var GET_INPUT = 1;// for state machine
	var INPUT_TYPE = "";
	var state = GET_TYPE;
	var name = arr[0];
	var text = arr[1]; //the first two lines are always the node name and the text
	var line = 2;
	var options = [];
	var costs = [];
	var gains = [];
	var flags = [];
	var localflags = [];
	while(line < array_length(arr)){
		var s = arr[line];
		if(state == GET_TYPE){
			INPUT_TYPE = s;
			state = GET_INPUT;
			line++;
		}
		else {
			if (string_get_first_word(INPUT_TYPE) == "GAIN") {
				var tokens = string_tokenize(INPUT_TYPE);
				var gain = [tokens[1], int64(tokens[2])];
				gains[array_length(gains)] = gain;
			}
			else if (string_get_first_word(INPUT_TYPE) == "LOSE") {
				var tokens = string_tokenize(INPUT_TYPE);
				var cost = [tokens[1], int64(tokens[2])];
				costs[array_length(costs)] = cost;
			}
			else if (string_get_first_word(INPUT_TYPE) == "SETFLAG") {
				var tokens = string_tokenize(INPUT_TYPE);
				var flag = [tokens[1], int64(tokens[2])];
				flags[array_length(flags)] = flag;
			}
			else if (string_get_first_word(INPUT_TYPE) == "SETFLAGLOCAL") {
				var tokens = string_tokenize(INPUT_TYPE);
				var flag = [tokens[1], int64(tokens[2])];
				localflags[array_length(flags)] = flag;
			}
			else if (INPUT_TYPE == "OPTION"){
				var opt_text = s;
				var opt_link = "";
				var opt_costs = [];
				var opt_gains = [];
				var opt_conds = [];
				var opt_reqs = [];
				do {
					line++;
					s = arr[line];
					var tokens = string_tokenize(s);
					var command = tokens[0];
					switch (tokens[0]) {
						case "REQUIRE" : {
							var req = [tokens[1], int64(tokens[2])];
							opt_reqs[array_length(opt_reqs)] = req;
						}
						case "SHOWGAIN" : {
							var gain = [tokens[1], int64(tokens[2])];
							opt_gains[array_length(opt_gains)] = gain;
						} break;
						case "SHOWLOSS" : {
							var cost = [tokens[1], int64(tokens[2])];
							opt_costs[array_length(opt_costs)] = cost;
						} break;
						case "SHOWIF" : {
							var cond = [CONDTYPE_RESOURCE, tokens[1], tokens[2], int64(tokens[3])];
							opt_conds[array_length(opt_conds)] = cond;
						} break;
						case "SHOWIFFLAG" : {
							var cond = [CONDTYPE_FLAG, tokens[1], tokens[2], int64(tokens[3])];
							opt_conds[array_length(opt_conds)] = cond;
						} break;
						case "EXIT" : break;
						default : {
							if (string_char_at(command, 1) == "$") {
								opt_link = string_copy(command, 2, string_length(command)-1);
							}
						} break;
					}
				} until (s == "" || s == "OPTION" || line >= array_length(arr)-1);
				options[array_length(options)] = 
						new dsys_option(opt_text, opt_link, opt_costs, opt_gains, opt_conds, opt_reqs);
			}
			state = GET_TYPE;
		}
	}
	var n = new dsys_node(name, text, options, costs, gains, flags, localflags);
	return n;
}

function dsys_create_dialogue(filename) {
	var nodes = dsys_parse_nodes_from_file(filename);
	var parsed_arr = array_create(array_length(nodes));
	for(var i = 0; i < array_length(parsed_arr); i++){
		parsed_arr[i] = dsys_parse_node_from_array(nodes[i]);
	}
	return new dsys_dialogue(parsed_arr);
}

function dsys_initialize_window(filename) {
	if(instance_exists(o_dialogue_manager)) {
		show_debug_message("WARNING: Attempted to open second dialogue window.");
		return; //don't open more than one dialogue window. Show debug since this shouldnt happen
	}
	var dialogue = dsys_create_dialogue(filename);
	var manager = instance_create(0, 0, o_dialogue_manager);
	manager.dialogue = dialogue;
	dsys_set_node(manager, "START");
}

function dsys_set_node(window, node_name) {
	with(o_dialogue_optionbutton){
		instance_destroy();
	}
	var node = ds_map_find_value(window.dialogue.map, node_name);
	window.text = node.text;
	window.speaker = node.speaker;
	window.options = node.options;
	window.gains = node.gains;
	window.costs = node.costs;
	window.flags = node.flags;
	window.localflags = node.localflags;
	window.cost_string = format_costs_window(window.costs);
	dsys_modify_resources(window.costs, window.gains);
	dsys_set_flags(window, window.flags, window.localflags);
	var hidden_buttons = 0;
	for(var i = 0; i < array_length(window.options); i++){
		var opt = window.options[i];
		var button = format_optionbutton(opt, i-hidden_buttons, window);
		if(!button.show) {
			instance_destroy(button);
			hidden_buttons++;
		}
	}
}

function dsys_modify_resources(_costs, _gains){
	for(var i = 0; i < array_length(_costs); i++){
		modify_resource(_costs[i][0], -1 * _costs[i][1]);
	}
	for(var i = 0; i < array_length(_gains); i++){
		modify_resource(_gains[i][0], _gains[i][1]);
	}
}

function dsys_set_flags(_window, _flags, _localflags){
	for(var i = 0; i < array_length(_flags); i++){
		var flag = _flags[i];
		flag_set(flag[0], flag[1]);
	}
	for(var i = 0; i < array_length(_localflags); i++){
		var flag = _localflags[i];
		flag_set(flag[0], flag[1]);
		ds_list_add(_window.local_flags, flag[0]);
	}
}

function format_optionbutton(_opt, _index, _window){
	var button = instance_create(0,0,o_dialogue_optionbutton);
	button.text = _opt.text;
	button.link = _opt.link;
	button.gains = _opt.gains;
	button.costs = _opt.costs;
	button.conds = _opt.conds;
	button.reqs = _opt.reqs;
	button.cost_string = format_costs(button.costs);
	button.gain_string = format_gains(button.gains);
	button.parent = _window;
	button.index = _index;
	//check whether the button will be pressable
	button.active = true;
	for(var i = 0; i < array_length(button.costs); i++){
		var cost = button.costs[i];
		var res = cost[0];
		var amt = cost[1];
		if (query_resource(res) < amt){
			button.active = false;
		}
	}
	for(var i = 0; i < array_length(button.reqs); i++){
		var req = button.reqs[i];
		var res = req[0];
		var amt = req[1];
		if (query_resource(res) < amt){
			button.active = false;
		}
	}
	button.show = true;
	for(var i = 0; i < array_length(button.conds); i++){
		var cond = button.conds[i];
		if(cond[0] == CONDTYPE_RESOURCE){
			button.show = button.show && compare(query_resource(cond[1]), cond[2], cond[3]);
		}
		else if(cond[0] == CONDTYPE_FLAG){
			button.show = button.show && compare(flag_get(cond[1]), cond[2], cond[3]);
		}
	}
	button.activity_string = "";
	if(!button.active){
		button.activity_string = ts_colour(C_WARNING) + "(Not enough resources)";
	}
	return button;
}

// helper function that tokenizes a command string into an array of words
function string_tokenize(str) {
	var arr = [];
	while(true){
		var word = string_get_first_word(str);
		str = string_copy(str, string_length(word)+2, string_length(str)-string_length(word));
		arr[array_length(arr)] = word;
		// When we've reached the last word, string_get_first_word will return the given string
		if(word == str){
			return arr;
		}
	}
}

//helper function to validate input typing and yell at you if you did it wrong
function dsys_validate(tokens, validation) {
	if(!is_array(tokens) || !is_array(validation)){
		show_error("ArgumentError: Expected tokenized array for function dsys_validate", true);
	}
	else if(array_length(tokens) != array_length(validation)) {
		show_error("ArgumentError: Length mismatch in function dsys_validate", true);
	}
	for(var i = 0; i < array_length(tokens); i++){
		if(validation[i] == INT) {
			if(!is_int64(tokens[i])) {
				show_error("TypeError: Expected type INTEGER for argument " + string(i), true);
			}
		}
		else if(validation[i] == STR) {
			if(!is_string(tokens[i])) {
				show_error("TypeError: Expected type STRING for argument " + string(i), true);
			}
		}
	}
}

// helper function to get first word of a string
function string_get_first_word(str) {
	var space_index = string_pos(" ", str);
	if(space_index == 0){
		return str;
	}
	else return string_copy(str, 1, space_index-1);
}

//takes a cost array and formats a string for the relevant option button to print
function format_costs(cost_array) {
	if(array_length(cost_array) == 0){
		return "";
	}
	var text = ts_colour(C_COST);
	for(var i = 0; i < array_length(cost_array); i++) {
		if(i > 0){
			text += ts_colour(C_DIALOGUE) + "," + ts_colour(C_COST);
		}
		var cost = cost_array[i];
		var res = cost[0];
		var amt = cost[1];
		text += fetch_sprite_atex(res) + string(amt);
	}
	return text;
}

//takes a gains array and formats a string for the relevant option button to print
function format_gains(gains_array) {
	if(array_length(gains_array) == 0){
		return "";
	}
	var text = ts_colour(C_DIALOGUE) + "You will get:" + ts_colour(C_GAIN);
	for(var i = 0; i < array_length(gains_array); i++) {
		if(i > 0){
			text += ","
		}
		var gain = gains_array[i];
		var res = gain[0];
		var amt = gain[1];
		text += fetch_sprite_atex(res) + string(amt);
	}
	return text;
}

//takes a cost array and formats a string for the relevant dialogue window to print
function format_costs_window(cost_array) {
	if(array_length(cost_array) == 0){
		return "";
	}
	var text = ts_colour(C_COST) + "You lost:" + ts_colour(C_DIALOGUE);
	for(var i = 0; i < array_length(cost_array); i++) {
		if(i > 0){
			text += ",";
		}
		text += " ";
		var cost = cost_array[i];
		var res = cost[0];
		var amt = cost[1];
		text += string(amt) + "x" + fetch_sprite_atex(res);
	}
	return text;
}

//compare values based on 3 items: the two things to compare on the outer values and the comparator string inside
function compare(val1, comparator, val2) {
	switch(comparator) {
		case "EQ": return val1 == val2; break;
		case "GT": return val1 > val2; break;
		case "GTE": return val1 >= val2; break;
		case "LT": return val1 < val2; break;
		case "LTE": return val1 <= val2; break;
		case "NOT": return val1 != val2; break;
		default: return false;
	}
}