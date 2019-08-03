/// @description Check for Collision With the Player
// You can write your code in this editor

// Check if the warp can transition to the next room
if (isWarping){
	if (fadeID != noone){
		if (fadeID.alpha == 1){
			// Clear out all ds lists that are on persistent objects
			ds_list_clear(global.lightSources);
			ds_list_clear(global.entities);
			// Put the player in the correct area
			var tX, tY;
			tX = targetX;
			tY = targetY;
			with(obj_player){
				x = tX;
				y = tY;
				// Re-add the necessary instances to their respective ds lists
				ds_list_add(global.lightSources, ambLight);
				ds_list_add(global.entities, id);
			}
			// Move to the next room
			room_goto(targetRoom);
			// Setup and Update the Camera's view
			with(obj_camera) {alarm[2] = 1;}
		}
	}
}