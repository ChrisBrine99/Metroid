/// @description Drawing the rectangle to the screen
// You can write your code in this editor

draw_set_alpha(setAlpha);
draw_set_color(color);
draw_rectangle(global.camX, global.camY, global.camX + global.camWidth, global.camY + global.camHeight, false);
draw_set_alpha(1);

if (doorFade){
	if (setAlpha != 0){
		var xPos, yPos;
		xPos = global.camX + xOnScreen;
		yPos = global.camY + yOnScreen;
		draw_sprite_ext(obj_samus.sprite_index, obj_samus.image_index, xPos, yPos, obj_samus.image_xscale, obj_samus.image_yscale, 0, c_white, 1);
		if (setAlpha == 1){
			if (xTo != 0 && yTo != 0){
				xOnScreen += (xTo - xOnScreen) / 5;
				yOnScreen += (yTo - yOnScreen) / 5;
			}
			else{
				if (curRoom != room){
					if (instance_exists(obj_horizontal_camera_lock)){
						var hLock = obj_horizontal_camera_lock;
						obj_camera.xTo = hLock.xTo;
						obj_camera.x = hLock.xTo;
						global.camX = obj_camera.x - (global.camWidth / 2);
					}
					if (instance_exists(obj_vertical_camera_lock)){
						var vLock = obj_vertical_camera_lock;
						if ((obj_camera.y < vLock.yTo && vLock.upwardLock) || (obj_camera.y > vLock.yTo && !vLock.upwardLock)){
							obj_camera.yTo = vLock.yTo;
							obj_camera.y = vLock.yTo;
							global.camY = obj_camera.y - (global.camHeight / 2);
						}
					}
					obj_samus.visible = false;
					xTo = obj_samus.x - global.camX;
					if (obj_samus.facingRight) xTo--;
					else xTo++;
					yTo = obj_samus.y - global.camY;
				}
			}
		}
	}
}