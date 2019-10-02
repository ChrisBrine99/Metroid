/// @description Remove the Menu Border and Reset the Game State
// You can write your code in this editor

if (exitingMenu){
	instance_destroy(obj_menu_border);
	global.gameState = GAME_STATE.IN_GAME;
	with(obj_hud) {isVisible = true;}
}

// Call the parent object's destroy event
event_inherited();