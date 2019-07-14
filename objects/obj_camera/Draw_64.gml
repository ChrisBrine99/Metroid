/// @description Draw the in-game HUD
// You can write your code in this editor

// Draw everything for the HUD below this comment ////////////////////////////////////////////////

if (alpha > 0){
	draw_set_alpha(alpha);
	
	//with(test_block){
	//	draw_text(5, 5, "isDestroyed = " + string(isDestroyed) + "\ncheckForCollision = " + string(checkForCollision) + "\ndestroyTimer: " + string(destroyTimer));	
	//}
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

//////////////////////////////////////////////////////////////////////////////////////////////////