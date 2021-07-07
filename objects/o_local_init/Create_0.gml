/// @description Insert description here
// You can write your code in this editor
global.pix = 300;

setup = false;
instance_create(0,0,o_controller);
instance_create(0,0,o_gui);
sector = -1;
var nodes = dsys_parse_nodes_from_file("test0.txt");
var parsed_node = dsys_parse_node_from_array(nodes[0]);
var dialogue = dsys_create_dialogue("test0.txt");
dsys_initialize_window("test0.txt");