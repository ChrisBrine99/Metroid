/// @description Insert description here
// You can write your code in this editor

image_xscale += 0.1;
image_yscale += 0.1;

// Shake the camera
scr_shake_camera(5, 5);

// Door collision
if (instance_exists(obj_door)){
	var door = instance_nearest(x, y, obj_door);
	if (!door.open && (door.type == 0 || door.type == 7)){
		door.open = true;
		if (door.type == 7) global.pDoor[door.index] = true;
	}
}

if (image_xscale >= 4){
	instance_destroy(self);
}
else if (image_xscale >= 3){
	if (alpha > 0) 
		alpha -= 0.1;	
}