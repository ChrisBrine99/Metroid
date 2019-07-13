/// @description Makes the camera shake like mad (Good for big explosions or big enemies moving).
/// @param maxX
/// @param maxY

var maxX, maxY, randX, randY;
maxX = argument0;
maxY = argument1;

// Make the camera go wild
randX = round(choose(-random(maxX), random(maxX)));
randY = round(choose(-random(maxY), random(maxY)));

// Exit if the camera shouldn't be moving
if (global.gameState != GAME_STATE.IN_GAME){
	return;	
}

with(obj_camera){
	// Temporarily unlocking the camera form the player
	isLocked = false;
	
	// Randomly moving the camera's position slightly to simulate shaking
	x = curObject.x + randX;
	y = curObject.y + randY;
	
	// Stop the camera from going outside of the room
	scr_camera_bounds(0 - randX, 0 - randY, room_width + randX, room_height + randY);
}

// MAKE SURE TO LOCK THE CAMERA BACK ONTO THE PLAYER AFTER THE CAMERA SHAKING STOPS
// Use this to lock the camera again:
//			with(obj_camera){
//				isLocked = true;
//			}