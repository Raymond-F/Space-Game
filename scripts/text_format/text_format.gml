/// @description  text_format(text, [font, w])
/// @param text
/// @param *font
/// @param *w
/// @param *step
function text_format() {

	var text=argument[0], font, maxw, a=array_create(0), q=ds_queue_create(), mw=0, mh=0, W=0, H=0, a_n=1, step = 0;

	if argument_count>=2
	    font=argument[1]
	if argument_count>=3
	    maxw=argument[2]
	if argument_count > 3
		step = argument[3]
    
	var hlgn=0, vlgn=1, elements=0;
	a[0]=""

	for(var i=0; i<ds_list_size(global.ts_flist); i+=2)
	    text=string_replace_all(text, global.ts_flist[| i], global.ts_flist[| i+1])
    
	draw_set_font(font)
	for(var i=1; i<=string_length(text); i++)
	{
	    if string_copy(text, i, 6)="<<tag#"
	    {
	        i+=6
	        var tag=real(ts_argument(text, i));
	            i=ts_next(text, i)
	        a[a_n]=tag; a_n++
        
	        if tag=ts.halign
	        {
	            hlgn=real(ts_argument(text, i))
	                i=ts_next(text, i)
                            
	            i+=1
	            a_n--
	        }
	        else
	        if tag=ts.link
	        {
	            var link=ts_argument(text, i);
	                i=ts_next(text, i)
	            var link_moveon=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var link_press=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=link;a_n++
	            a[a_n]=link_moveon;a_n++
	            a[a_n]=link_press;a_n++
	        }
	        else
	        if tag=ts.shake
	        {
	            var shake=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=shake;a_n++
	        }
	        if tag=ts.glow
	        {
	            var color=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=color;a_n++
	        }
	        else
	        if tag=ts.script
	        {
	            var scriptind=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var script=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=scriptind;a_n++
	            a[a_n]=script;a_n++
	        }
	        else
	        if tag=ts.wave
	        {
	            var wave_spd=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var wave=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=wave_spd;a_n++
	            a[a_n]=wave;a_n++
	        }
	        else
	        if tag=ts.shadow
	        {
	            var shadow=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var shadow_x=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var shadow_y=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var shadow_c=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var shadow_a=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=shadow; a_n++
	            a[a_n]=shadow_c;a_n++
	            a[a_n]=shadow_a;a_n++
	            a[a_n]=shadow_x;a_n++
	            a[a_n]=shadow_y;a_n++
	        }
	        else
	        if tag=ts.unline
	        {
	            var lw=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var col=real(ts_argument(text, i));
	                i=ts_next(text, i)
                
	            i+=1
            
	            a[a_n]=lw;a_n++
	            a[a_n]=col;a_n++
	        }
	        else
	        if tag=ts.space
	        {
	            var space_w=real(ts_argument(text, i));
	                i=ts_next(text, i)
            
	            mw+=space_w
	            i+=1
	            a[a_n]=space_w; a_n++
	        }
	        else
	        if tag=ts.valign
	        {
	            vlgn=real(ts_argument(text, i))
	                i=ts_next(text, i)
                            
	            i+=1
	            a_n--
	        }
	        else
	        if tag=ts.colour
	        {
	            var ncolour=real(ts_argument(text, i));
	                i=ts_next(text, i)
                            
	            i+=1
            
	            a[a_n]=ncolour; a_n++ 
	        }
	        else
	        if tag=ts.outline
	        {
	            var outline=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var outline_c=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var outline_w=real(ts_argument(text, i));
	                i=ts_next(text, i)
                            
	            i+=1
            
	            a[a_n]=outline; a_n++ 
	            a[a_n]=outline_c; a_n++ 
	            a[a_n]=outline_w; a_n++ 
	        }
	        else
	        if tag=ts.font
	        {
	            var newfont=real(ts_argument(text, i));
	                i=ts_next(text, i)
            
	            i+=1
            
	            a[a_n]=newfont; a_n++ 
	            draw_set_font(newfont)
	        }
	        else
	        if tag=ts.image
	        {
	            var spr =real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var type=real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var w   =real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var h   =real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var X   =real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var Y   =real(ts_argument(text, i));
	                i=ts_next(text, i)
	            var xscale=1,
	                yscale=1;
                
	            i+=1
	            elements++
                
	            if h=ts.original h=sprite_get_height(spr)
	            if w=ts.original w=sprite_get_width(spr)
	            if h=ts.standart h=string_height(string_hash_to_newline("A"))
	            if w=ts.standart
	            {
	                yscale=h/sprite_get_height(spr)
	                xscale=yscale
	                w=sprite_get_width(spr)*xscale
	            }
            
	            if maxw!=-1 w=min(maxw, w)
            
	            if type=ts.img_scale
	            {
	                xscale=min(w/sprite_get_width(spr), h/sprite_get_height(spr))
	                yscale=xscale
	                w=sprite_get_width(spr)*xscale
	                h=sprite_get_height(spr)*yscale
	            }
	            else 
	            if type=ts.img_fullscale
	            {
	                xscale=w/sprite_get_width(spr)
	                yscale=h/sprite_get_height(spr)
	                w=sprite_get_width(spr)*xscale
	                h=sprite_get_height(spr)*yscale
	            }
	            else
	            if type=ts.img_partscale
	            {
	                xscale=max(w/sprite_get_width(spr), h/sprite_get_height(spr))
	                yscale=xscale
	            }
            
	            if maxw!=-1
	            if mw+w>=maxw
	            {
	                a_n--
	                mw-=ts_smoothspace(a, a_n-1)
	                var na=array_create(a_n); 
	                for(var j=0; j<a_n; j++)
	                    na[j]=a[j]
					mh += step * (ds_queue_size(q) > 0) * (ds_queue_size(q) > 0)
	                ds_queue_enqueue(q, H, mh, mw, vlgn, hlgn, na, elements, 1)
	                H+=mh
	                mh=0
	                mw=0
	                a[0]=ts.image
	                a_n=1
	                elements=1
	            }
            
	            mh=max(mh, h)
	            mw+=w
	            W=max(mw, W)
            
	            a[a_n]=spr; a_n++
            
	            if type=ts.img_scale or type=ts.img_fullscale
	                {a[a_n]=ts.in; a_n++}
	            else if type=ts.img_partscale
	                {a[a_n]=ts.out; a_n++}
	            else
	                {a[a_n]=ts.part; a_n++}
                
	            a[a_n]=w; a_n++
	            a[a_n]=h; a_n++
	            a[a_n]=X; a_n++
	            a[a_n]=Y; a_n++
	            a[a_n]=xscale; a_n++
	            a[a_n]=yscale; a_n++
	        }
	        a[a_n]=""
	        a_n++
	    }
	    else
	    if string_copy(text, i, 7)="<<line#"
	    {
	        i+=7
	        var na=array_create(a_n); 
        
	        mw-=ts_smoothspace(a, a_n-1)
        
	        for(var j=0; j<a_n; j++)
	            na[j]=a[j]
			mh += step * (ds_queue_size(q) > 0)
	        ds_queue_enqueue(q, H, mh, mw, vlgn, hlgn, na, elements, 0)
	        var cval=ts_argument(text, i);
	            i=ts_next(text, i)
        
	        if cval!="back" 
	            H+=mh+real(cval)
	        mh=0
	        mw=0
	        a[0]=""
	        a_n=1
	        i+=1
	        elements=0
        
	    }
	    else
	    {
	        var word="", psymb="";
        
	        for(i=i; i<=string_length(text); i++)
	        {
	            var starti=i, br=0;
	            if global.ts_usertag_use // find and executing usertags
	            {
	                for(var j=0; j<ds_list_size(global.ts_usertags); j++)
	                {
	                    var ctag=ds_list_find_value(global.ts_usertags, j),
	                        ctrig=ctag[| 0], clen=string_length(ctrig), 
	                        endword=ctag[| 2], endlen=string_length(endword);
                        
	                    if string_copy(text, i, clen)=ctrig
	                    {
	                        i+=clen
	                        var carglist=ds_list_create(), acount=ctag[| 1];
	                        if acount>=0
	                            repeat acount
	                            {
	                                ds_list_add(carglist, ts_argument(text, i))
	                                i=ts_next(text, i)
	                            }
	                        else
	                            {
	                                var carg=ts_argument(text, i, endword);
	                                while carg!=endword and i<=string_length(text)
	                                {
	                                    ds_list_add(carglist, carg)
	                                    i=ts_next(text, i)
	                                    carg=ts_argument(text, i, endword)
	                                }
	                            }
	                        i+=endlen
	                        text=string_delete(text, starti, i-starti)
	                        text=string_insert(script_execute(ctag[| 3], carglist), text, starti)
	                        i=starti-1
	                        ds_list_destroy(carglist)
	                        br=1
	                        break
	                    }
	                }
	                if br
	                    break
	            }
	            //search for tags
	            if string_copy(text, i, 6)="<<tag#"
	            or string_copy(text, i, 7)="<<line#"
	            {
	                i-=1
	                break
	            }
	            else
	            {
	                var symb=string_char_at(text, i);
	                word+=symb
	                if symb=" " or symb="," or symb="(" or (symb=")" and psymb!="(")
	                or (symb="]" and psymb!="[") or symb="["
	                    break
	            }
	            psymb=symb
	        }
        
	        var wordw=string_width(string_hash_to_newline(word));
	        var ex=0;
        
	        if global.ts_ww //text wrapping
	            while mw+wordw>=maxw and !ex and maxw!=-1
	            {
	                var nword="", nsize=string_width(string_hash_to_newline("-"));
	                if string_length(word)<=4 break
	                for(var z=1; z<=string_length(word)-3; z++)
	                {
	                    var symb=string_char_at(word, z);
	                    if mw+nsize+string_width(string_hash_to_newline(symb))>=maxw or z=string_length(word)-3
	                    {
	                        if z<=2
	                        {
	                            ex=1
	                            break
	                        }
	                        if global.ts_j 
	                        {
	                            a_n++
	                            a[a_n-1]=nword+"-"
	                            elements++
	                        }
	                        else
	                            a[a_n-1]+=nword+"-"
                            
	                        var na=array_create(a_n); 
	                        for(var j=0; j<a_n; j++)
	                            na[j]=a[j]
							mh += step * (ds_queue_size(q) > 0)
	                        ds_queue_enqueue(q, H, mh, mw+nsize, vlgn, hlgn, na, elements, 1)
	                        elements=0
	                        H+=mh
	                        mh=0
	                        mw=0
	                        a[0]=""
	                        a_n=1
	                        word=symb+string_delete(word, 1, z)
	                        wordw=string_width(string_hash_to_newline(word))
	                        break
	                    }
	                    nword+=symb
	                    nsize+=string_width(string_hash_to_newline(symb))
	                }
	                if ex break
	            }
        
	        if mw+wordw>=maxw and maxw!=-1
	        {
	            mw-=ts_smoothspace(a, a_n-1)
	            var na=array_create(a_n); 
	            for(var j=0; j<a_n; j++)
	                na[j]=a[j]
				mh += step * (ds_queue_size(q) > 0)
	            ds_queue_enqueue(q, H, mh, mw, vlgn, hlgn, na, elements, 1)
	            H+=mh
	            mh=0
	            mw=0
	            a[0]=""
	            a_n=1
	            elements=0
	        }
        
	        if a_n!=1 or word!=" "
	        {
	            if global.ts_j=1
	            {
	                a_n++
	                a[a_n-1]=word
	                elements++
	            }
	            else
	                a[a_n-1]+=word
	            mw+=string_width(string_hash_to_newline(word))
	        }
	        mh=max(mh, string_height(string_hash_to_newline("A")))
	        W=max(W, mw)
	    }
	}

	var na=array_create(a_n); 
	for(var j=0; j<a_n; j++)
	    na[j]=a[j]
	mh += step * (ds_queue_size(q) > 0)
	ds_queue_enqueue(q, H, mh, mw, vlgn, hlgn, na, elements, 0)
	ds_queue_enqueue(q, 0, 0, 0, 0, 0, 0, 0, 0)
	H+=mh
	if maxw!=-1 W=maxw

	var l=ds_list_create();
	l[| 0]=W
	l[| 1]=H
	l[| 2]=q

	return l;





}
