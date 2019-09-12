/// @description Creating the variable to hold the lighting system
// You can write your code in this editor

scale = floor(display_get_width() / global.camWidth);
surfWidth = global.camWidth * scale;
surfHeight = global.camHeight * scale;
global.lighting = surface_create(surfWidth, surfHeight);
// The current colors of the lighting system
curLightingCol = c_black;
// Regular Cave Color:		c_ltgray
// Color for water areas:	make_color_rgb(220, 220, 220);
// Color for hot areas:		make_color_rgb(0, 105, 230);
// Color for menus:			c_black

// Variables for the rectangle that can be draw on the screen with a nice gradient effect
rectCol = c_blue;		// Color for the lower portion of the rectangle
oRectCol = c_black;		// Color for the upper portion of the rectangle
drawRectangle = false;	// If true, the rectangle will be drawn on the screen
xPos = 0;				// The default coordinates and size of the rectangle:
yPos = 20;				//			(xPos, yPos, xPos + width, yPos + height) <- How coordinates are processed
width = global.camWidth;//			  x1	y1		  x2			y2
height = 160;


// The ds_list to hold every light source in the current room
global.lightSources = ds_list_create();
numDrawn = 0;