// UNIQUE TO INACTIVE DOOR ONLY -- If the door was previously activated by the player, it will switch over to 
// its activated variant once the player enters the room containing said door.
if (event_get_flag(activeID)) {activate_door();}

// Call the object's inherited Room Start event, which will check to see if the closing animation needs to play
// for this door instance if the player went through it to get to the current room and also if the door has
// been unlocked by the player already, which switches that locked door into a general door.
event_inherited();