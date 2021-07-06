// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro HELD keyboard_check
#macro PRESSED keyboard_check_pressed
#macro RELEASED keyboard_check_released
#macro MHELD mouse_check_button
#macro MPRESSED mouse_check_button_pressed
#macro MRELEASED mouse_check_button_released

#macro CAM view_camera[0]
#macro XVIEW camera_get_view_x(view_camera[0])
#macro YVIEW camera_get_view_y(view_camera[0])
#macro VIEW_LEFT camera_get_view_x(view_camera[0])
#macro VIEW_RIGHT camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])
#macro VIEW_TOP camera_get_view_y(view_camera[0])
#macro VIEW_BOTTOM camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])
#macro VIEW_WIDTH camera_get_view_width(view_camera[0])
#macro VIEW_HEIGHT camera_get_view_height(view_camera[0])
#macro MOUSE_GUIX device_mouse_x_to_gui(0)
#macro MOUSE_GUIY device_mouse_y_to_gui(0)
#macro GUIW display_get_gui_width()
#macro GUIH display_get_gui_height()

function instance_create(_x, _y, _obj){
	return instance_create_depth(_x,_y,0,_obj);
}
function draw_align_center() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
}
function draw_align_reset() {
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}