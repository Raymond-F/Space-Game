/// @description  ts_init()
function ts_init() {

	/*
	    initialization some variables
	*/

	global.ts_usertag_use=0

	enum ts
	{
	    text=-1,
	    image=0,
	    halign=1,
	    valign=2,
	    colour=3,
	    font=4,
	    outline=5,
	    space=6,
	    unline=7,
	    link=8,
	    shadow=9,
	    shake=10,
	    wave=11,
	    script=12,
	    glow=13,
	    standart=-1,
	    original=-2,
	    img_scale=0,
	    img_fullscale=1,
	    img_partscale=2,
	    img_part=3,
	    in=0,
	    out=1,
	    part=2
	}

	global.ts_j=0
	global.ts_ww=0
	global.ts_symb_effects=0

	global.ts_flist=ds_list_create()
	global.ts_varmap=ds_map_create()

	global.ts_usertags=ds_list_create()




}
