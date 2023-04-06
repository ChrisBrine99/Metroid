//with(CAMERA.camera) {reset_view_offset_target(4, 4);}

if (numMissiles == maxMissiles) {return;}

temp += DELTA_TIME * 0.5;
if (temp > 1.0){
	temp -= 1.0;
	numMissiles++;
}