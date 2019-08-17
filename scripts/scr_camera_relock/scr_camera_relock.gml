/// @description Locks the camera back onto the player object after a brief moment where the camera needed
/// to move independently for an effect. (Ex. a massive explosion)

with(obj_camera){
	// Tell the camera to lock back onto the player object
	isLocked = true;
	
	// Instancely lock the camera back to the player's position
	x = curObject.x;
	y = curObject.y;
}