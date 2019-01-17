/// @description Creates a fading transition effect.
/// @param posX
/// @param posY
/// @param color
/// @param setDepth
/// @param doorFade

var obj, xPos, yPos, color, setDepth, doorFade;
xPos = argument0;
yPos = argument1;
color = argument2;
setDepth = argument3;
doorFade = argument4;

// Make sure a fade effect object doesn't already exist
if (!instance_exists(obj_fade)){
	obj = instance_create_depth(xPos, yPos, setDepth, obj_fade);
	obj.color = color;
	obj.doorFade = doorFade;
}