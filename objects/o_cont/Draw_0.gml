draw_set_valign(fa_right)
draw_set_halign(fa_bottom)
draw_set_font(f_norm)

draw_text(room_width, room_height, string_hash_to_newline(string(room+1)+"/13#press ENTER#to next example#or TAB to pre."))

if keyboard_check_pressed(vk_enter)
    if room!=room_last room_goto_next()
if keyboard_check_pressed(vk_tab)
    if room!=0 room_goto_previous()

