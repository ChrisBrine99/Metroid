/// @description Draws the animation to the screen.
/// NOTE -- This script will only function if it is being caklled in the draw event
/// @param sprite
/// @param num
/// @param xPos
/// @param yPos
/// @param xScale
/// @param yScale
/// @param angle

var sprite, num, xPos, yPos, xScale, yScale, angle;
sprite = argument0;		// The object's current sprite
num = argument1;		// The sprite's current image being displayed
xPos = argument2;		// The x-position to display the sprite at
yPos = argument3;		// The y-position to display the sprite at
xScale = argument4;		// How stretched/compressed the image is along the x-axis
yScale = argument5;		// How stretched/compressed the image is along the y-axis
angle = argument6;		// The angle to display the image


// Don't draw the sprite if it isn't being drawn in the draw event
if (event_type != ev_draw){
	return;	
}

// Only draw the sprite if it is visible on the screen
if (x >= global.camX - abs(x - bbox_right) && y >= global.camY - abs(y - bbox_bottom) && x <= global.camX + global.camWidth + abs(x - bbox_left) && y <= global.camY + global.camHeight + abs(y - bbox_top)){
	draw_sprite_ext(sprite, floor(num), round(xPos), round(yPos), xScale, yScale, angle, c_white, 1);
	global.numDrawn++;
}