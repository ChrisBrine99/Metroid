/// @description Provides an entity with the variables that are necessary for having correct animation speeds that
/// are independent of the current frame rate. Each animation on screen is handled 60 times a second no matter what.
/// NOTE -- This must use the create event in order to work correctly

// Don't allow this script to execute if it is being called outside of the create event of an object
if (event_type != ev_create){
	return;	
}

// Initialize the required variables
imgSpd = 1;				// Determines the speed that the image animates at
imgIndex = 0;			// The current frame of a sprite that is being displayed