// Determine which of the four cardinal directions to set the zoomer's rendering angle at relative to which of
// the eight possible directions it is currently moving in.
if (direction == DIRECTION_NORTH || direction == DIRECTION_SOUTH){
	image_angle = direction;
	if (movement == MOVE_DIR_LEFT) // Flip the Zoomer to prevent moving along walls with its head.
		image_angle -= 180.0;
} else if (direction >= DIRECTION_NORTH && direction < DIRECTION_SOUTH){
	image_angle = DIRECTION_EAST;
} else{
	image_angle = DIRECTION_WEST;
}

// Flip the Zoomer by half a circle to prevent it from moving along its head instead of the right way up.
if (movement == MOVE_DIR_RIGHT && image_angle != direction)
	image_angle += 180.0;

// Draw the Zoomer with the proper orientation before it is flipped back to a default of 0.0 to prevent any
// issues with its movement logic as the collision mask moves along with the image angle.
entity_draw();
image_angle = DIRECTION_EAST;