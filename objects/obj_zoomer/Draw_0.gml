image_angle = floor(direction / 90.0) * 90.0;
if (movement == MOVE_DIR_LEFT){
	if (direction == 315.0)			{image_angle = 360.0;}
	else if (direction == 135.0)	{image_angle = 180.0;}
	image_angle -= 180.0;
}

entity_draw();
image_angle = 0.0;