/// @description Modifying Player Variables
// You can write your code in this editor

if (!hasCollected){
	with(obj_player){
		numMissiles += 5;
		maxMissiles += 5;
		isWeaponUnlocked[5] = true;
		// Update the HUD if the player has missiles equipped
		if (curWeaponIndex == 5){
			with(obj_hud) {alarm[0] = 1;}	
		}
	}
}