/// @description Sets the color, brightness, contrast, and saturation of the lighting inside of whatever room
/// calls this function. MAKE SURE TO ONLY USE THIS IN THE CREATION CODE OF A GIVEN ROOM.
/// @param color[r/g/b]
/// @param brightness
/// @param contrast
/// @param saturation

function set_lighting(_color, _brightness, _contrast, _saturation) {
	with(global.effectID){
		lightColor = _color;
		lightBrightness = _brightness;
		lightContrast = _contrast;
		lightSaturation = _saturation;
	}
}