/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// The four variables used for every type of light source in the game. The first variable holds the size of 
// the light, which is used differently depending on the light's type. (Ex. X and Y radii for circles, but
// width and height for rectangular lights, etc.) The second variable is the strength of the light source;
// the lower the value the dimmer the light becomes. Next, the third is a data structure containing colors
// used by the light source. (Circles use one, rectangles use 4, etc.) Finally, drawFunction contains the
// script used to actually draw the light source.
size = [0, 0];
strength = 0;
colors = ds_list_create();
drawFunction = -1;

#endregion