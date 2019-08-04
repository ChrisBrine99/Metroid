/// @description Displays a message for the player on the screen using the obj_onScreen_prompt object. The text's
/// position, color, and alignment can all be altered, as well as the amount of time in frames that the text will
/// be visible for.
/// @param obj
/// @param xPos
/// @param yPos
/// @param text
/// @param col
/// @param oCol
/// @param alignment
/// @param time

var obj, xPos, yPos, text, col, oCol, alignment, time, instance;
obj = argument0;		// The type of screen prompt to create
xPos = argument1;		// X position of the message
yPos = argument2;		// Y position of the message
text = argument3;		// The message itself
col = argument4;		// The color of the message
oCol = argument5;		// The color of the message's outline
alignment = argument6;	// How the text will be aligned on screen (Left, Center, or Right)
time = argument7;		// The time in frames until the text fades
instance = noone;		// Holds the unique instance ID for the prompt

switch(obj){
	case obj_on_screen_prompt:
		// Delete the previous prompt if it exists
		if (instance_exists(obj)) {instance_destroy(obj);}
		// Create the prompt with all the user defined arguments
		instance = instance_create_depth(x, y, 45, obj);
		with(instance){
			self.xPos = xPos;
			self.yPos = yPos;
			displayTxt = text;
			displayTxtCol = col;
			displayTxtOCol = oCol;
			txtAlignment = alignment;
			displayTimer = time;
		}
		// Return the unique instance ID for the prompt
		return instance;
		break;
	default: // The object given wasn't a valid screen prompt
		return noone;
		break;
}