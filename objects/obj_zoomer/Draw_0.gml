// 
if (direction == DIRECTION_NORTH || direction == DIRECTION_SOUTH){
	image_angle = direction;
	if (movement == MOVE_DIR_LEFT)
		image_angle -= 180.0;
} else if (direction >= DIRECTION_NORTH && direction < DIRECTION_SOUTH){
	image_angle = DIRECTION_EAST;
} else{
	image_angle = DIRECTION_WEST;
}

// 
if (movement == MOVE_DIR_RIGHT && image_angle != direction)
	image_angle += 180.0;

entity_draw();
image_angle = DIRECTION_EAST;