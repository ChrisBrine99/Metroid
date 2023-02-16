// Check if the player is next to the door on the room's start. If so, it will be automatically assumed they
// travelled through this door when warping into the room, and as such it will start open and play a closing
// animation, which is just the reverse of the opening animation.
if (place_meeting(x + (24 * image_xscale), y, PLAYER)){
	imageIndex = spriteLength - 1;
	animSpeed = -1;
}

// FOR DOORS WITH LOCKS ONLY -- Check if the flag tied to the door has already been set. If so, switch this door
// to a general door as it is now considered unlocked.
if (object_index == obj_general_door || !event_get_flag(flagID)) {return;}
lightComponent.set_properties(64, HEX_LIGHT_BLUE, 0.7);
flagID = EVENT_FLAG_INVALID;