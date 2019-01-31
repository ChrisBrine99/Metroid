/// @description Handling Saving
// You can write your code in this editor

// Keyboard Variable
keySave = keyboard_check_pressed(global.key[9]); // Button to save the game

// Check if the player is above the platform
if (place_meeting(x, y - 1, obj_samus)){
	if (!isSaving && global.started){
		if (!hasSaved){
			obj_controller.displayTxt = "Press [Enter] to Save";
			obj_controller.displayTimer = 30;
		}
		else{
			obj_controller.displayTxt = "Save Complete";	
		}
		canSave = true;
	}
}
else{
	canSave = false;
	hasSaved = false;
}
	
if (canSave){
	if (!isSaving){ // Pressing enter to save the game
		if (keySave && !hasSaved){
			obj_samus.x = self.x + (sprite_width / 2);
			isSaving = true;
			obj_controller.displayTxt = "Saving...";
		}
	}
	else{ // Writing everything to a file
		obj_controller.displayTimer = obj_controller.displayTimerMax;
		if (obj_samus.canMove){
			global.started = false;
			obj_samus.canMove = false;
			obj_samus.right = true;
			obj_samus.left = false;
			obj_samus.image_xscale = 1;
			scr_save_game(global.fileName);
		}
		cooldownTimer--;
		if (cooldownTimer <= 0){
			cooldownTimer = 120;
			hasSaved = true;
			isSaving = false;
			global.started = true;
			obj_samus.canMove = true;
		}
	}
}