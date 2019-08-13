/// @description Insert description here
// You can write your code in this editor

// Make the HUD visible again and unfreeze the camera
with(obj_hud) {isVisible = true;}
with(obj_camera) {curObject = obj_player;}
// Return the Game State back to normal
global.gameState = GAME_STATE.IN_GAME;
// Destroy the background blur
if (blurID != noone){
	instance_destroy(blurID);
	blurID = noone;	
}
// Resume all audio that was playing before the player picked up the item
if (audio_is_playing(fanfare)) {audio_stop_sound(fanfare);}
audio_resume_all();