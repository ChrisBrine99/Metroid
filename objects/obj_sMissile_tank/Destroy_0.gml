/// @description Modifying Player Variables
// You can write your code in this editor

if (!hasCollected){
	with(obj_player){
		numSMissiles += 2;
		maxSMissiles += 2;
		isWeaponUnlocked[6] = true;
	}
}