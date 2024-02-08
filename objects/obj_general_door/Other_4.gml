// Check if the player is next to the door on the room's start. If so, it will be automatically assumed they
// travelled through this door when warping into the room, and as such it will start open and play a closing
// animation, which is just the reverse of the opening animation.
var _x = lengthdir_x(1, image_angle);
var _y = lengthdir_y(1, image_angle);
var _xx = _x * 24;
var _yy = _y * 24;
if (place_meeting(x + _xx, y + _yy, PLAYER)){
	stateFlags |= (ENTT_PAUSE_ANIM | DOOR_CLOSING);
	imageIndex	= spriteLength - 1;
	animSpeed	= -DOOR_OPEN_ANIM_SPEED;
	
	// The door doesn't exist in the frozen entities list within the "Screen Fade" instance, so the door must
	// be added here if required (Allows the door to close behind Samus since she just traveled through it).
	with(SCREEN_FADE) {ds_list_add(prevAnimationFlags, [other.id, false]);}
}

// 
var _centerX = -(_yy + (4 * _x));
var _centerY = _xx + (4 * _y);

// 
audioOffsetX = _centerX;
audioOffsetY = _centerY;

// 
lightOffsetX = _centerX;
lightOffsetY = _centerY;

// FOR DOORS WITH LOCKS ONLY -- Check if the flag tied to the door has already been set. If so, switch this door
// to a general door as it is now considered unlocked.
if (object_index == obj_general_door || !event_get_flag(flagID))
	return;
lightComponent.set_properties(LGHT_ACTIVE_RADIUS, HEX_LIGHT_BLUE, LGHT_ACTIVE_STRENGTH);
flagID = EVENT_FLAG_INVALID;