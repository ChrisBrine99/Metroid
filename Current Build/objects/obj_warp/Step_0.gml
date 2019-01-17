/// @description Check if Samus has collided with the warp
// You can write your code in this editor

if (global.energy == 0 && global.eTanks == 0){
	return;	
}

if (place_meeting(x,y,obj_samus)){
    if (!isWarping){
        isWarping = true;
		scr_create_fade(global.camX, global.camY, c_black, 1, true);
		global.isPaused = true;
    }
    if (instance_exists(obj_fade)){
        //Checking if the fade has gone to opaque
        if (obj_fade.setAlpha == 1){
            //Warp to the set room
            obj_samus.x = targetX;
            obj_samus.y = targetY - lengthdir_y((obj_samus.sprite_height / 2), obj_samus.gravDir);
            room = targetRoom;
        }
    }
}