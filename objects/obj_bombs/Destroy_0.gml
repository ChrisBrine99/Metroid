/// @description Unlock the Bomb in the player's inventory
// You can write your code in this editor

if (!hasCollected){
	with(obj_player) {isBombUnlocked[0] = true;}
	with(obj_hud) {alarm[0] = 1;}
}