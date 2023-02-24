// Check if the player is next to the door on the room's start. If so, it will be automatically assumed they
// travelled through this door when warping into the room, and as such it will start open and play a closing
// animation, which is just the reverse of the opening animation.
var _x = lengthdir_x(1, direction);
var _y = lengthdir_y(1, direction);
if (place_meeting(x + (24 * _x), y + (24 * _y), PLAYER)){
	imageIndex = spriteLength - 1;
	animSpeed = -1;
}

// 
var _offsetX = x - (24 * _y) + (4 * _x);
var _offsetY = y + (24 * _x) + (4 * _y);
lightComponent.set_position(_offsetX, _offsetY);
show_debug_message("Direction: {2}\nX: {0}, Y: {1}", _offsetX - x, _offsetY - y, direction);

// FOR DOORS WITH LOCKS ONLY -- Check if the flag tied to the door has already been set. If so, switch this door
// to a general door as it is now considered unlocked.
if (object_index == obj_general_door || !event_get_flag(flagID)) {return;}
lightComponent.set_properties(LIGHT_DEFAULT_RADIUS, GENERAL_LIGHT_COLOR, LIGHT_DEFAULT_STRENGTH);
flagID = EVENT_FLAG_INVALID;