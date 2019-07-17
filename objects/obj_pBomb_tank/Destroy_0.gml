/// @description Modifying Player Variables
// You can write your code in this editor

if (!hasCollected){
	with(obj_player){
		numPBombs += 2;
		maxPBombs += 2;
		isBombUnlocked[1] = true;
	}
}