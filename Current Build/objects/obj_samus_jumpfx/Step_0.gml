/// @description Makes the fx fade away smoothly
// You can write your code in this editor

// Check if the pause menu has been opened
if (instance_exists(obj_pause_menu) || global.itemCollected){
	exit;
}

alpha -= 0.1;
// Spawning another fade effect if Samus is still jumping
if (alpha == 0.2){
	if (obj_samus.jumpspin){
		instance_create_depth(obj_samus.x, obj_samus.y, depth, obj_samus_jumpfx);
	}
}
// Destroy the effect object once it's invisible to the player
if (alpha <= 0 || obj_samus.isShooting){
	instance_destroy(self);	
}