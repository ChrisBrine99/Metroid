// If the entity has been destroyed, (AKA its "is destroyed" bit has been set to true at any point during the 
// current frame of execution AND its "is invincible" flag isn't set) it will be removed from the game here.
if (ENTT_IS_DESTROYED && !ENTT_IS_INVINCIBLE){
	instance_destroy_object(id);
	return;
}

// Update the values for the player's previous coordinates to reflect any movement during the last frame.
previousX = x;
previousY = y;