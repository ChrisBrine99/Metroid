// Don't allow for the execution of a room warp's step event if it isn't the one that the player collided with.
if (!isWarping) {return;}

// Grab the screen fade's current alpha level in order to check if it's reached full opacity. Otherwise, a room
// change cannot occur and the room wrap will be forced to wait until the next frame(s) to perform it.
var _alpha = 0;
with(SCREEN_FADE) {_alpha = alpha;}

// Check if the screen has completely faded into the color of the fade effect. If so, the room change will
// occur and the player will be moved to the position set by this warp instance; updating the camera's position
// as well to match.
if (_alpha == 1){
	if (room_exists(targetRoom)) {room_goto(targetRoom);}
	var _targetX = targetX;
	var _targetY = targetY;
	with(PLAYER){
		x = _targetX;
		y = _targetY;
		camera_set_position(x, y);
	}
}