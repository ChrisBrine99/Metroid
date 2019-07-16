/// @description Modifying Player Variables
// You can write your code in this editor

if (!hasCollected){
	with(obj_player){
		numMissiles += 5;
		maxMissiles += 5;
		isWeaponUnlocked[5] = true;
	}
}