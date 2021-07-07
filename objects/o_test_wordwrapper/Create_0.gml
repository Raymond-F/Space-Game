/// @description  CREATE
ts_init()
usertag_enable(true)
ts_wordwrapping(true)
ts_justify(true)

ts_add_keyword("[c]", ts_image(s_cherry))

width=500

txt=ts_halign(fa_center)+"CHERRY"+ts_line()+ts_halign(fa_left)+
    "Many cherries[c] are members of the subgenus Cerasus, which is distinguished by having the flowers in small corymbs of several together, and by having smooth fruit[c][c][c] with only a weak groove along one side, or no groove."+ts_line()+ts_halign(fa_center)+ts_image(s_cherrs, ts.original, ts.original)+ts_line()+ts_halign(fa_left)+
    "The English word cherry derives from Old Northern French or Norman cherise from the Latin cerasum, referring to an ancient Greek region, Kerasous near Giresun, Turkey, from which cherries were first thought to be exported to Europe."
    
txt_id=text_format(txt, f_norm, width)


