/// @description  text_create(text, font, maxw)
/// @param text
/// @param font
/// @param maxw
/// @param *step
function text_create() {
	var l=ds_list_create();

	var step = 0;
	if (argument_count > 3)
		step = argument[3];

	l[| 0]=argument[0]
	l[| 1]=-1
	l[| 2]=0
	l[| 3]=argument[1]
	l[| 4]=argument[2]
	l[| 5]=step

	return l;



}
