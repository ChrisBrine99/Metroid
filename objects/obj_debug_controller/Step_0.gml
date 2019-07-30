/// @description Insert description here
// You can write your code in this editor

#region Keyboard Inputs

var keySongSwitch;
keySongSwitch = keyboard_check_pressed(ord("M"));

#endregion

#region Switching Music Tracks

if (keySongSwitch){
	switch(global.curSong){
		case music_area1:
			global.curSong = music_area2;
			global.offset = 9.046;
			global.loopLength = 81.399;
			break;
		case music_area2:
			global.curSong = music_area1;
			global.offset = 9.359;
			global.loopLength = 60.51;
			break;
		default:
			global.curSong = -1;
			break;
	}
}

#endregion

#region Handling the Menu Transition

var isVisible;
isVisible = obj_camera.isVisible;

// Fading the Debug Menu in and out
if (isVisible && !fadeDestroy){
	alpha += 0.2;
	if (alpha > 1){
		alpha = 1;	
	}
} else{
	alpha -= 0.2;
	if (alpha < 0){
		alpha = 0;	
		if (fadeDestroy) {instance_destroy(self);}
	}
}

#endregion