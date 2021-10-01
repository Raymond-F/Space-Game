// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// Opens a given settlement's settlement window
function open_settlement_window(loc){
	var win = instance_create(0, 0, o_settlement_pane);
	win.location = loc;
	win.title = loc.struct.name;
}