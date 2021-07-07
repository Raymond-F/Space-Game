// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//option for the player to select. Contains text and a link to another node.
//if the link is empty, it closes the dialogue instead.
function dsys_option(_text, _link) constructor {
	text = _text;
	link = _link;
}

//a node of dialogue, including main text and all option objects
//options is generally going to be an array.
function dsys_node(_name, _text, _options) constructor {
	name = _name; //used to hash the node into a map
	text = _text;
	options = [];
	speaker = "Person";
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
		options = [dsys_option("<UNDEFINED OPTION ARRAY>", "")];
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
	while(line < array_length(arr)){
		var s = arr[line];
		if(state == GET_TYPE){
			INPUT_TYPE = s;
			state = GET_INPUT;
			line++;
		}
		else {
			if (string_get_first_word(INPUT_TYPE) == "GAIN") {
				
			}
			else if (string_get_first_word(INPUT_TYPE) == "LOSE") {
				
			}
			else if (INPUT_TYPE == "OPTION"){
				var opt_text = s;
				var opt_link = "";
				do {
					line++;
					s = arr[line];
					var command = string_get_first_word(s);
					switch (command) {
						case "SHOWGAIN" : break;
						case "SHOWLOSS" : break;
						case "EXIT" : break;
						default : {
							if (string_char_at(command, 1) == "$") {
								opt_link = string_copy(command, 2, string_length(command)-1);
							}
						}
					}
				} until (s == "" || s == "OPTION" || line >= array_length(arr)-1);
				options[array_length(options)] = new dsys_option(opt_text, opt_link);
			}
			state = GET_TYPE;
		}
	}
	var n = new dsys_node(name, text, options);
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
	for(var i = 0; i < array_length(window.options); i++){
		var opt = window.options[i];
		var button = instance_create(0,0,o_dialogue_optionbutton);
		button.text = opt.text;
		button.link = opt.link;
		button.parent = window;
		button.index = i;
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