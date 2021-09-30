// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum option_link_type {
	dialogue,
	battle
}

//option for the player to select. Contains text and a link to another node.
//if the link is empty, it closes the dialogue instead.
function dsys_option(_text, _link, _link_type, _costs, _gains, _conds, _reqs, _rand_costs, _rand_gains, _skilltest_info) constructor {
	text = _text;
	link = _link;
	link_type = _link_type;
	costs = _costs;
	gains = _gains;
	conds = _conds; //conditions have the format [TYPE_MACRO, val1, comparator, val2]
	reqs = _reqs;
	rand_costs = _rand_costs;
	rand_gains = _rand_gains;
	skilltest_info = _skilltest_info; //format [attribute, success_chance]
	postbattle_file = "";
	postevent_location = noone; // What kind of location to make after the event, if it's an event
}

//a node of dialogue, including main text and all option objects
//options is generally going to be an array.
function dsys_node(_name, _text, _options, _costs, _gains, _flags, _localflags, _rcosts, _rgains) constructor {
	name = _name; //used to hash the node into a map
	text = _text;
	options = [];
	speaker = "Person";
	costs = _costs;
	gains = _gains;
	flags = _flags;
	localflags = _localflags;
	rand_costs = _rcosts;
	rand_gains = _rgains;
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
		options = [dsys_option("<UNDEFINED OPTION ARRAY>", "", option_link_type.dialogue, [], [], [], [], [], [], [])];
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
		repeat (ds_map_size(map)) {
			var n = map[? ds_map_find_first(map)];
			for (var i = 0; i < array_length(n.options); i++) {
				delete n.options[i];
			}
			delete n;
		}
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
			if(line != "\r\n" && line != "\n"){
				while(string_char_at(line, string_length(line)) == "\r" || string_char_at(line, string_length(line)) == "\n"){
					line = string_delete(line, string_length(line), 1);
				}
				node[count] = line;
				count++;
			}
		} until (line == "\r\n" || line == "\n" || file_text_eof(file));
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
	var rgains = [];
	var rcosts = [];
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
			else if (string_get_first_word(INPUT_TYPE) == "GAINRANDOM") {
				var tokens = string_tokenize(INPUT_TYPE);
				var lbound = tokens[2];
				var ubound = tokens[3];
				var val = irandom_range(int64(lbound), int64(ubound));
				var rgain = [tokens[1], val];
				rgains[array_length(rgains)] = rgain;
			} 
			else if (string_get_first_word(INPUT_TYPE) == "LOSE") {
				var tokens = string_tokenize(INPUT_TYPE);
				var cost = [tokens[1], int64(tokens[2])];
				costs[array_length(costs)] = cost;
			}
			else if (string_get_first_word(INPUT_TYPE) == "LOSERANDOM") {
				var tokens = string_tokenize(INPUT_TYPE);
				var lbound = tokens[2];
				var ubound = tokens[3];
				var val = irandom_range(int64(lbound), int64(ubound));
				var rcost = [tokens[1], val];
				rcosts[array_length(rcosts)] = rcost;
			} 
			else if (string_get_first_word(INPUT_TYPE) == "SETFLAG") {
				var tokens = string_tokenize(INPUT_TYPE);
				var flag = [tokens[1], int64(tokens[2])];
				flags[array_length(flags)] = flag;
			}
			else if (string_get_first_word(INPUT_TYPE) == "SETFLAGLOCAL") {
				var tokens = string_tokenize(INPUT_TYPE);
				var flag = [tokens[1], int64(tokens[2])];
				localflags[array_length(localflags)] = flag;
			}
			else if (INPUT_TYPE == "OPTION"){
				var opt_text = s;
				var opt_link = "";
				var opt_postbattle = "";
				var opt_link_type = option_link_type.dialogue;
				var opt_costs = [];
				var opt_gains = [];
				var opt_conds = [];
				var opt_reqs = [];
				var opt_rcosts = [];
				var opt_rgains = [];
				var opt_rand_links = [];
				var opt_skilltest = [];
				var opt_skilltest_info = [];
				var opt_success_link = "";
				var opt_failure_link = "";
				var opt_postloc = noone;
				do {
					line++;
					s = arr[line];
					var tokens = string_tokenize(s);
					var command = tokens[0];
					switch (tokens[0]) {
						case "REQUIRE" : {
							var req = [tokens[1], int64(tokens[2])];
							opt_reqs[array_length(opt_reqs)] = req;
						} break;
						case "SHOWGAIN" : {
							var gain = [tokens[1], int64(tokens[2])];
							opt_gains[array_length(opt_gains)] = gain;
						} break;
						case "SHOWRANDOMGAIN" : {
							var lbound = tokens[2];
							var ubound = tokens[3];
							var val = irandom_range(int64(lbound), int64(ubound));
							var rgain = [tokens[1], val];
							//add the random amount to both randomgains (for propagation) and normal gains (for formatting/display)
							opt_rgains[array_length(opt_rgains)] = rgain;
							opt_gains[array_length(opt_gains)] = rgain;
						} break;
						case "SHOWLOSS" : {
							var cost = [tokens[1], int64(tokens[2])];
							opt_costs[array_length(opt_costs)] = cost;
						} break;
						case "SHOWRANDOMLOSS" : {
							var lbound = tokens[2];
							var ubound = tokens[3];
							var val = irandom_range(int64(lbound), int64(ubound));
							var rcost = [tokens[1], val];
							opt_rcosts[array_length(opt_rgains)] = rcost;
							opt_costs[array_length(opt_costs)] = rcost;
						} break;
						case "SHOWIF" : {
							var cond = [CONDTYPE_RESOURCE, array_subset(tokens, 1, array_length(tokens)-1)];
							opt_conds[array_length(opt_conds)] = cond;
						} break;
						case "SHOWIFFLAG" : {
							var cond = [CONDTYPE_FLAG, array_subset(tokens, 1, array_length(tokens)-1)];
							opt_conds[array_length(opt_conds)] = cond;
						} break;
						case "KEYATTRIBUTE" : {
							var skilltest = [tokens[1], int64(tokens[2])];
							opt_skilltest = skilltest;
						} break;
						case "CREATELOC" : {
							switch(tokens[1]) {
								case "derelict": opt_postloc = location_type.derelict; break;
								case "comet": opt_postloc = location_type.comet; break;
								default: break;
							}
						} break;
						case "FIGHT" : {
							opt_link_type = option_link_type.battle;
							opt_link = tokens[1]; // Links to the battle file
							if (array_length(tokens) > 2) {
								opt_postbattle = tokens[2];
							}
						} break;
						case "EXIT" : break;
						default : {
							switch (string_char_at(command, 1)){
								case "$" : {
									opt_link = string_copy(command, 2, string_length(command)-1);
								} break;
								case "%" : {
									var link_choice = string_copy(command, 2, string_length(command)-1);
									var weight = tokens[1];
									array_push_back(opt_rand_links, [link_choice, int64(weight)]);
								} break;
								case "+" : {
									opt_success_link = string_copy(command, 2, string_length(command)-1);
								} break;
								case "-" : {
									opt_failure_link = string_copy(command, 2, string_length(command)-1);
								} break;
							}
						} break;
					}
				} until (s == "" || s == "OPTION" || line >= array_length(arr)-1);
				//choose a random link from available, if this is a randomized outcome
				if(opt_link == "") {
					//select a random link from the list to go to
					if(array_length(opt_rand_links) > 0){
						// normalize weights
						var total_weight = 0;
						for(var i = 0; i < array_length(opt_rand_links); i++){
							total_weight += opt_rand_links[i][1];
						}
						var modifier = total_weight/100;
						if(modifier == 0){
							show_error("ERROR: Random links for option cannot have total weight of 0", true);
						}
						for(var i = 0; i < array_length(opt_rand_links); i++){
							opt_rand_links[i][1] = opt_rand_links[i][1]/modifier;
						}
						//determine random choice
						var roll = irandom_range(1, 100);
						var running_weight = 0;
						for(var i = 0; i < array_length(opt_rand_links); i++){
							running_weight += opt_rand_links[i][1];
							if(roll < running_weight){
								opt_link = opt_rand_links[i][0];
								break;
							}
						}
						if(opt_link == ""){
							show_debug_message("WARNING: Random selection did not evaluate to anything.");
						}
					}
					//select a random success or failure
					else if(opt_success_link != "" || opt_failure_link != ""){
						if(opt_success_link == "" || opt_failure_link == ""){
							show_debug_message("WARNING: Both success link and failure links must be supplied to option template.");
							opt_link = (opt_success_link == "" ? opt_failure_link : opt_success_link);
						}
						else if (array_length(opt_skilltest) != 2) {
							show_debug_message("WARNING: Skilltest array must be array of length 2 in format [attribute, target]");
							opt_link = opt_success_link;
						}
						else {
							var roll = random(1);
							var perc = skilltest_get_percentage(opt_skilltest[0], opt_skilltest[1]);
							opt_skilltest_info = [opt_skilltest[0], perc];
							opt_link = (roll < perc ? opt_success_link : opt_failure_link);
						}
					}
				}
				var new_opt = new dsys_option(opt_text, opt_link, opt_link_type, opt_costs, opt_gains, opt_conds, opt_reqs, opt_rcosts, opt_rgains, opt_skilltest_info);
				new_opt.postbattle_file = opt_postbattle;
				new_opt.postevent_location = opt_postloc;
				array_push(options, new_opt);
			}
			state = GET_TYPE;
		}
	}
	var n = new dsys_node(name, text, options, costs, gains, flags, localflags, rcosts, rgains);
	return n;
}

function dsys_create_dialogue(filename) {
	var nodes = dsys_parse_nodes_from_file(filename);
	if(nodes == noone){
		return noone;
	}
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
	if (dialogue == noone){
		return;
	}
	var manager = instance_create(0, 0, o_dialogue_manager);
	manager.dialogue = dialogue;
	dsys_set_node(manager, "START", noone);
}

/***
window - the window object to be set
node_name - the unique identifier string of the node
ref - the option object which referred this node. This can be null/noone
***/
function dsys_set_node(window, node_name, ref) {
	var node = ds_map_find_value(window.dialogue.map, node_name);
	window.text = node.text;
	window.speaker = node.speaker;
	window.options = node.options;
	window.gains = node.gains;
	window.costs = node.costs;
	window.flags = node.flags;
	window.localflags = node.localflags;
	var referred_costs = [];
	var referred_gains = [];
	//refer randomized costs from button
	if(ref >= 0 && instance_exists(ref)){
		referred_costs = ref.rand_costs;
		referred_gains = ref.rand_gains;
		for(var i = 0; i < array_length(referred_costs); i++){
			array_push_back(window.costs, referred_costs[i]);
		}
		for(var i = 0; i < array_length(referred_gains); i++){
			array_push_back(window.gains, referred_gains[i]);
		}
	}
	//grab any randomized costs that were not previewed
	if(array_length(referred_costs) == 0 && array_length(referred_gains) == 0){
		for(var i = 0; i < array_length(node.rand_costs); i++){
			array_push_back(window.costs, node.rand_costs[i]);
		}
		for(var i = 0; i < array_length(node.rand_gains); i++){
			array_push_back(window.gains, node.rand_gains[i]);
		}
	}
	window.cost_string = format_costs_window(window.costs);
	window.gain_string = format_gains_window(window.gains);
	dsys_modify_resources(window.costs, window.gains);
	dsys_set_flags(window, window.flags, window.localflags);
	with(o_dialogue_optionbutton){
		instance_destroy();
	}
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

function format_optionbutton(_opt, _index, _window){
	var button = instance_create(0,0,o_dialogue_optionbutton);
	button.text = _opt.text;
	button.link = _opt.link;
	button.link_type = _opt.link_type;
	button.postbattle_file = _opt.postbattle_file;
	button.gains = _opt.gains;
	button.costs = _opt.costs;
	button.rand_costs = _opt.rand_costs;
	button.rand_gains = _opt.rand_gains;
	button.conds = _opt.conds;
	button.reqs = _opt.reqs;
	button.cost_string = format_costs(button.costs);
	button.gain_string = format_gains(button.gains);
	button.parent = _window;
	button.index = _index;
	button.postevent_location = _opt.postevent_location;
	//check whether the button will be pressable
	button.active = true;
	button.fails_requirement = false;
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
			button.fails_requirement = true;
		}
	}
	button.show = true;
	for(var i = 0; i < array_length(button.conds); i++){
		var cond = button.conds[i];
		button.show = button.show && evaluate_conditional(cond[1], cond[0]);
	}
	button.reqs_string = "";
	button.reqs_string += format_reqs(button.reqs);
	button.activity_string = "";
	if(!button.active){
		if(button.fails_requirement){
			button.activity_string += ts_colour(C_WARNING) + " (Not enough resources)";
		}
	}
	button.skilltest_string = "";
	if(array_length(_opt.skilltest_info) == 2){
		var successchance = _opt.skilltest_info[1];
		var dcolor = color_interpolate(C_SKILLTEST_FAILURE, C_SKILLTEST_SUCCESS, successchance); //change later with color interpolation
		button.skilltest_string = ts_colour(C_DIALOGUE_TOOLTIP) + "[" + fetch_sprite_atex(_opt.skilltest_info[0]) + ts_colour(dcolor) + string(floor(successchance * 100)) + "%" + ts_colour(C_DIALOGUE_TOOLTIP) + "] ";
	}
	button.link_type_string = "";
	if (button.link_type == option_link_type.battle) {
		button.link_type_string = "[FIGHT]";
	} else if (button.link == "") {
		button.link_type_string = "[END]";
	}
	return button;
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

//takes a cost array and formats a string for the relevant option button to print
function format_costs(cost_array) {
	if(array_length(cost_array) == 0){
		return "";
	}
	order_costs_or_gains(cost_array);
	var text = ts_colour(C_DIALOGUE_TOOLTIP) + "[" + ts_colour(C_DIALOGUE) + "-" + ts_colour(C_COST);
	for(var i = 0; i < array_length(cost_array); i++) {
		if(i > 0){
			text += ts_colour(C_DIALOGUE_TOOLTIP) + "," + ts_colour(C_DIALOGUE) + "-" + ts_colour(C_COST);
		}
		var cost = cost_array[i];
		var res = cost[0];
		var amt = cost[1];
		text += fetch_sprite_atex(res) + string(amt);
	}
	text += ts_colour(C_DIALOGUE_TOOLTIP) + "]";
	return text;
}

//takes a gains array and formats a string for the relevant option button to print
function format_gains(gains_array) {
	if(array_length(gains_array) == 0){
		return "";
	}
	order_costs_or_gains(gains_array);
	var text = ts_colour(C_DIALOGUE_TOOLTIP) + "[" + ts_colour(C_DIALOGUE) + "+" + ts_colour(C_GAIN);
	for(var i = 0; i < array_length(gains_array); i++) {
		if(i > 0){
			text += ts_colour(C_DIALOGUE_TOOLTIP) + "," + ts_colour(C_DIALOGUE) + "+" + ts_colour(C_GAIN);
		}
		var gain = gains_array[i];
		var res = gain[0];
		var amt = gain[1];
		text += fetch_sprite_atex(res) + string(amt);
	}
	text += ts_colour(C_DIALOGUE_TOOLTIP) + "]";
	return text;
}

//formats a set of requirements into a readable string
function format_reqs(req_array) {
	if(array_length(req_array) == 0){
		return "";
	}
	order_costs_or_gains(req_array);
	var text = ts_colour(C_DIALOGUE_TOOLTIP) + " [Need: ";
	for(var i = 0; i < array_length(req_array); i++) {
		var nextcolor = C_DIALOGUE;
		var req = req_array[i];
		var res = req[0];
		var amt = req[1];
		if(query_resource(res) < amt){
			nextcolor = C_COST;
		}
		if(i > 0){
			text += ts_colour(C_DIALOGUE_TOOLTIP) + ",";
		}
		text += ts_colour(nextcolor);
		text += fetch_sprite_atex(res) + string(amt);
	}
	text += ts_colour(C_DIALOGUE_TOOLTIP) + "]";
	return text;
}

//takes a cost array and formats a string for the relevant dialogue window to print
function format_costs_window(cost_array) {
	if(array_length(cost_array) == 0){
		return "";
	}
	order_costs_or_gains(cost_array);
	var text = ts_colour(C_COST) + "You lost:" + ts_colour(C_DIALOGUE_TOOLTIP) + "[" + ts_colour(C_DIALOGUE);
	for(var i = 0; i < array_length(cost_array); i++) {
		if(i > 0){
			text += ts_colour(C_DIALOGUE_TOOLTIP) + "," + ts_colour(C_DIALOGUE);
		}
		var cost = cost_array[i];
		var res = cost[0];
		var amt = cost[1];
		text += string(amt) + "x" + fetch_sprite_atex(res);
	}
	text += ts_colour(C_DIALOGUE_TOOLTIP) + "]";
	return text;
}

//takes a gain array and formats a string for the relevant dialogue window to print
function format_gains_window(gain_array) {
	if(array_length(gain_array) == 0){
		return "";
	}
	order_costs_or_gains(gain_array);
	var text = ts_colour(C_GAIN) + "You received:" + ts_colour(C_DIALOGUE_TOOLTIP) + "[" + ts_colour(C_DIALOGUE);
	for(var i = 0; i < array_length(gain_array); i++) {
		if(i > 0){
			text += ts_colour(C_DIALOGUE_TOOLTIP) + "," + ts_colour(C_DIALOGUE);
		}
		var gain = gain_array[i];
		var res = gain[0];
		var amt = gain[1];
		text += string(amt) + "x" + fetch_sprite_atex(res);
	}
	text += ts_colour(C_DIALOGUE_TOOLTIP) + "]";
	return text;
}

//find a resource in a nested array such as a cost or gain array
function find_resource(_arr, _str) {
	for(var _i = 0; _i < array_length(_arr); _i++) {
		if (_arr[_i][0] == _str){
			return _i;
		}
	}
	return -1;
}

//order a cost or gain array, first by set ordering for important stuff, then by alphabetical
function order_costs_or_gains(arr) {
	var lowest_unsorted_index = 0;
	var order_of_precedence = ["pix", "crew", "supplies", "fuel"];
	for(var i = 0; i < array_length(order_of_precedence); i++){
		var res_ind = find_resource(arr, order_of_precedence[i]);
		if(res_ind >= 0 && res_ind != lowest_unsorted_index) {
			array_swap(arr, lowest_unsorted_index, res_ind);
			lowest_unsorted_index++;
		}
	}
}

//determine if something is a conditional tuple, defined as exactly [checked_val, comparator, comparison_value]
function is_tuple(set) {
	if (array_length(set) == 3) {
		return true;
	}
	return false;
}

//get all tokens inside a parenthesized set, including the parentheses
function get_tokens_in_scope(set) {
	if(set[0] != "(") {
		return set;
	}
	else {
		var open_count = 0;
		var lastpos = -1;
		for(var i = 0; i < array_length(set); i++){
			var token = set[i];
			if (token == "(") {
				open_count++;
			}
			else if (token == ")") {
				//we are at the end of the scope if this nulls the last open paren in the stack
				open_count--;
				if(open_count == 0) {
					lastpos = i;
					break;
				}
			}
		}
		if(open_count > 0 || lastpos = -1) {
			show_debug_message("ERROR: Unclosed parentheses in set " + string(set));
		}
		return array_subset(set, 0, lastpos);
	}
}

//take an array of tokens and convert it into an array of those same tokens, but with parentheses made into their own tokens
function tokenize_parentheses(arr) {
	var tokens = ds_list_create();
	for(var i = 0; i < array_length(arr); i++){
		var val = arr[i];
		var parenstart = [];
		while(string_char_at(val, 1) == "(" || string_char_at(val, 1) == ")") {
			parenstart[array_length(parenstart)] = string_char_at(val, 1);
			val = string_delete(val, 1, 1);
		}
		var parenend = [];
		while(string_char_at(val, string_length(val)) == "(" || string_char_at(val, string_length(val)) == ")") {
			parenend[array_length(parenend)] = string_char_at(val, string_length(val));
			val = string_delete(val, string_length(val), 1);
		}
		for(var j = 0; j < array_length(parenstart); j++) {
			ds_list_add(tokens, parenstart[j]);
		}
		ds_list_add(tokens, val);
		for(var j = 0; j < array_length(parenend); j++) {
			ds_list_add(tokens, parenend[j]);
		}
	}
	//now "(flag, gt, val, OR, flag2, lt, val2)" will become "(, flag, ...., lt, val2, )"
	var ret = array_create(ds_list_size(tokens));
	for(var i = 0; i < ds_list_size(tokens); i++){
		ret[i] = tokens[|i];
	}
	return ret;
}

//specific function to recursively evaluate conditionals with OR and AND support
//example string "SHOWIFFLAG ((flag1 GTE 1 OR flag2 LTE 5) AND flag3 EQ 6) AND (flag4 NOT 4 OR flag5 NOT 1)"
//can split this into something like: 
//IMPORTANT: takes in tokens MINUS the keyword, e.g. SHOWIF
//type refers to the type of evaluation - CONDTYPE_FLAG or CONDTYPE_RESOURCE
function recursively_evaluate(set, type) {
	if(array_length(set) < 3) {
		show_debug_message("WARNING: Malformed conditional - expected at least 3 arguments in [sub]set.");
	}
	if(is_tuple(set)){
		if(type == CONDTYPE_FLAG){
			return compare(flag_get(set[0]), set[1], int64(set[2]));
		}
		else if(type == CONDTYPE_RESOURCE){
			return compare(query_resource(set[0]), set[1], int64(set[2]));
		}
		else {
			show_debug_message("WARNING: Malformed type in recursive evaluation - expected CONDTYPE_FLAG or CONDTYPE_RESOURCE");
		}
	}
	//if this starts with a parentheses, it could be separate scoped sets
	else if (set[0] == "(") {
		var scoped_tokens = get_tokens_in_scope(set);
		if(array_length(scoped_tokens) == array_length(set)){
			//the set is surrounded in (now) erroneous parentheses, which can be removed and the function called again
			var array_less_paren = array_subset(set, 1, array_length(set)-2);
			return recursively_evaluate(array_less_paren, type);
		}
		else {
			//conjoiner should come immediately after a set
			var conj = set[array_length(scoped_tokens)];
			//copy the rest of the set then recur
			var other_set = array_subset(set, array_length(scoped_tokens)+1, array_length(set)-1);
			if (conj == "OR") {
				return recursively_evaluate(scoped_tokens, type) || recursively_evaluate(other_set, type);
			}
			else if (conj == "AND") {
				return recursively_evaluate(scoped_tokens, type) && recursively_evaluate(other_set, type);
			}
			else {
				show_debug_message("ERROR: Expected valid conjoiner but got " + conj + ".");
				return false;
			}
		}
	}
	//since it is longer than 3 items, and doesn't start with parentheses we can assume the start is an unenclosed tuple
	else {
		if(array_length(set) < 5) {
			show_debug_message("ERROR: Expected at least one token after tuple splitting.");
			return false;
		}
		var first_set = array_subset(set, 0, 2);
		var conj = set[3];
		var second_set = array_subset(set, 4, array_length(set)-1);
		if (conj == "OR") {
			return recursively_evaluate(first_set, type) || recursively_evaluate(second_set, type);
		}
		else if (conj == "AND") {
			return recursively_evaluate(first_set, type) && recursively_evaluate(second_set, type);
		}
		else {
			show_debug_message("ERROR: Expected valid conjoiner but got " + conj + ".");
			return false;
		}
	}
}

function evaluate_conditional(set, type) {
	set = tokenize_parentheses(set);
	return recursively_evaluate(set, type);
}

// helper function that tokenizes a command string into an array of words
function string_tokenize(str) {
	var arr = [];
	while(true){
		var word = string_get_first_word(str);
		str = string_copy(str, string_length(word)+2, string_length(str)-string_length(word));
		// When we've reached the last word, string_get_first_word will be empty
		if(word == ""){
			return arr;
		}
		arr[array_length(arr)] = word;
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

//compare values based on 3 items: the two things to compare on the outer values and the comparator string inside
function compare(val1, comparator, val2) {
	switch(comparator) {
		case "EQ": return val1 == val2; break;
		case "GT": return val1 > val2; break;
		case "GTE": return val1 >= val2; break;
		case "LT": return val1 < val2; break;
		case "LTE": return val1 <= val2; break;
		case "NOT": return val1 != val2; break;
		default: show_debug_message("WARNING: Malformed comparator - expected comparison token (e.g. EQ)"); return false;
	}
}

//get the string between the first instance of two different substrings
function string_get_between(str, sub1, sub2) {
	var sub1pos = string_pos(sub1, str);
	var sub2pos = string_pos(sub2, str);
	if(sub1pos == sub2pos || sub1pos < 0 || sub2pos < 0){
		return "";
	}
	else if(sub1pos > sub2pos){
		var temp = sub1pos;
		var temp2 = sub1;
		sub1pos = sub2pos;
		sub2pos = temp;
		sub1 = sub2;
		sub2 = temp2;
	}
	var sub1end = sub1pos+string_length(sub1);
	var between = string_copy(str, sub1end, sub2pos - sub1end);
	return between;
}