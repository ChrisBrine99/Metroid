/// @description Initializing Variables
// You can write your code in this editor

// Default size and color variables (CAN BE ALTERED)
xRad = 70;
yRad = 70;
lightCol = c_white;

/*// IMPORTANT NOTE:
//		When the light emitter is drawing a rectangle, it will use the xRad and yRad just like it
//		does when drawing a sphere. So, this means that the position of the light will be in the center
//		of this object (Just like the sphere).

// Keeps track of what type of light shape to be used when drawing
lightType = LIGHT.SPHERE;*/
// Drawing rectangles as light sources is impossible for the time being

// Enables/Disables the lights ability to be drawn on the screen
canDraw = true;

// Add this light to the ds_list of light sources
alarm[0] = 1;