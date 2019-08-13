/// @description provides an object with the variables necessary for calculating and handling dynamic alpha values
/// within its draw event. 
/// NOTE -- This script will only execute when placed in the object's create event

// Don't allow this script to execute if it is being called outside of the create event of an object
if (event_type != ev_create){
	return;	
}

// Initialize the required variables
alpha = 0;				// The level of the object's transparency (1 = opaque, 0 = transparent)
alphaChangeVal = 0.1;	// The speed that the object will fade in and out at
fadingIn = true;		// If false, the object will begin fading out
destroyOnZero = false;	// If true, the object will destroy itself once it is invisible after fading out
freezeOnPause = false;	// If true, the object will freeze when the game is paused