/// @description Makes the camera shake like mad (Good for big explosions or big enemies moving).
/// @param maxX
/// @param maxY

var maxX, maxY, randX, randY;
maxX = argument0;
maxY = argument1;

// Release the camera from being locked onto the player.
global.followPlayer = false;

// Make the camera go wild
randX = round(choose(-random(maxX), random(maxX)));
randY = round(choose(-random(maxY), random(maxY)));

with(obj_camera){
	x = curObject.x + randX;
	y = curObject.y + randY;
	
	// Stop the camera from going outside of the room
	scr_camera_bounds(0 - randX, 0 - randY, room_width + randX, room_height + randY);
}

// MAKE SURE TO LOCK THE CAMERA BACK ONTO THE PLAYER AFTER THE CAMERA SHAKING STOPS
// Use this to lock the camera again:
//			global.followPlayer = true;