// Spawning in the wallfire boss
if (global.event[0] == false){
	var obj = instance_create_depth(304, -64, 300, obj_wallfires);
	obj.image_xscale = -1;
	var obj2 = instance_create_depth(16, -64, 300, obj_wallfires);
	global.curSong = -1;
	global.offset = 0;
	exit;
}

// Item Room BG Music's offset
global.curSong = music_itemRoom;
global.offset = 0;