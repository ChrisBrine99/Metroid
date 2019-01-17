/// @description Simple enemy AI that moves back and forth and switches directions every second or so. When 
/// samus is near, the yumbo will drop down to the player's level until Samus gets far enough away again.

// Call the parent step event
event_inherited();

image_speed = 1;
if (!canMove || frozen){
	image_speed = 0;
	return;
}

// Call the basic left/right movement script
scr_enemy_horizontal_movement();
x += hspd;

// Turning directions
turnTimer--;
if (turnTimer <= 0){
	turnTimer = 90;
	if (left){
		left = false;
		right = true;
	}
	else{
		left = true;
		right = false;
	}
}

// Flying down once Samus gets near
if (!down && !up){
	if (obj_samus.y - y <= 64){
		if (obj_samus.x >= x - 64 && obj_samus.x <= x + 64){ // Moving Down
			if (y == origY){
				down = true;
				up = false;
				vspd = maxVspd;
			}
		}
		else{
			if (y != origY){ // Moving Up
				up = true;
				down = false;
				vspd = -maxVspd;
			}
		}
	}
}
else if (down){ // Stopping Vertical Movement
	if (y >= obj_samus.y - 6){
		vspd = 0;
		down = false;
	}
}
else if (up){ // Stopping Vertical Movement As Well
	if (y <= origY){
		y = origY;
		vspd = 0;
		up = false;
	}
}
y += vspd;