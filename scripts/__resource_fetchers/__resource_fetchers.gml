// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function initialize_sprite_map(){
	var sm = ds_map_create();
	ds_map_add(sm, "pix", s_icon_pix);
	return sm;
}

function fetch_sprite(str) {
	return global.sprite_map[?str];
}

function fetch_sprite_atex(str) {
	return ts_image(fetch_sprite(str), ICON_WIDTH, ICON_HEIGHT);
}

function query_resource(str) {
	switch (str) {
		case "pix" : return global.pix; break;
		default: return -1;
	}
}

function modify_resource(str, amount) {
	switch (str) {
		case "pix" : global.pix += amount; break;
		default : break;
	}
}