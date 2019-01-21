// Starting area BG Music's offset
global.curSong = music_area1;
global.offset = 9.098;

if (global.event[1] == true){
	for (var i = 0; i < 4; i++)
		instance_create_depth(1168 + (i * 16), 80, 300, obj_event_block);
}