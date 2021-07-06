/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_yellow);
//draw lines
for(var i = 0; i < ds_list_size(sector); i++){
	var z = sector[|i];
	var xx = zone_getx(z);
	var yy = zone_gety(z);
	var cnx_list = zone_getcnx(z);
	for(var j = 0; j < ds_list_size(cnx_list); j++){
		var z2 = cnx_list[|j];
		draw_line_width(xx, yy, zone_getx(z2), zone_gety(z2), 2);
	}
}
//draw dots
draw_set_color(c_white);
draw_align_center();
for(var i = 0; i < ds_list_size(sector); i++){
	var z = sector[|i];
	var xx = zone_getx(z);
	var yy = zone_gety(z);
	draw_circle(xx, yy, 3, false);
	draw_text(xx, yy-15, "(" + string(xx) + "," + string(yy) + ")");
}