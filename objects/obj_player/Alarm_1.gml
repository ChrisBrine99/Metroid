/// @description Playing Samus's intro fanfare/Create Her Ambient Light Source
// You can write your code in this editor

// Play the Fanfare
scr_play_sound(music_samus_appears, 1000, false, false);
fanfarePlayed = true;

// Holds the instance ID for the ambient light that is around Samus
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 35;
	yRad = 35;
	lightCol = c_gray;
	persistent = true;
}
flashingTime = 1;