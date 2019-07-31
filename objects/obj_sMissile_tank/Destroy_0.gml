/// @description Modifying Player Variables
// You can write your code in this editor

if (!hasCollected){
	with(obj_player){
		numSMissiles += 2;
		maxSMissiles += 2;
		isWeaponUnlocked[6] = true;
		// Update the HUD if the player has super missiles equipped
		if (curWeaponIndex == 6){
			with(obj_hud) {alarm[0] = 1;}	
		}
	}
}