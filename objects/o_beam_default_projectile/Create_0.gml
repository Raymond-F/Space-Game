/// @description Insert description here
// You can write your code in this editor
event_inherited();
lifespan = 60;
endx = 0;
endy = 0;
setup = false;
xpf = 0;
ypf = 0;// x and y drift per frame
start_fx_index = random(3);
end_fx_index = random(3);
type = weapon_type.beam;
explosion_timer = irandom_range(1, 4);