/// @description  usertag_add(start_trigger, argument_count, end, script)
/// @param start_trigger
/// @param  argument_count
/// @param  end
/// @param  script
function usertag_add(argument0, argument1, argument2, argument3) {

	/*
	    start_trigger - start of tag, ex: "<image:"
	    argument_count - number of used arguments, write -1 to unlimited arguments
	    end - end of tag, ex: ">"
	    script - script that will be executing
	*/

	// for example: 
	//               usertag_add('<image:', 3, '>', scr_tag_image)

	/*
	    scr_tag_image:
	        return ts_image(asset_get_index(argument0[| 0]), argument0[| 1], argument0[| 2])
        
	    // argument0 - list with arguments
    
    
	        example of string and argument list:
        
	    txt='Hello <image:s_world|32|32|>'
	    argument0: ds_list with those values: ["s_world", 32, 32]
	    "|" - a character after each argument, even last
    
	    start_trigger cant be part of other start_trigger, for example:
	        usertag_add('<Img', 1, '>', scr_img)        \__  NOT
	        usertag_add('<Imgext', 3, '>', scr_img_ext) /    RIGHT
        
	        usertag_add('<Img', 1, '>', scr_img)        \__  IT IS
	        usertag_add('<extImg', 3, '>', scr_img_ext) /    RIGHT
	*/

	var l=ds_list_create();
	ds_list_add(l, argument0, argument1, argument2, argument3)
	ds_list_add(global.ts_usertags, l)



}
