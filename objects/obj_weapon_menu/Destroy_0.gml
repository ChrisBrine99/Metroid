/// @description Quick Swapping if the menu isn't open
// You can write your code in this editor

if (!fullMenu){
	with(obj_player){
		if (!inMorphball){ // Swapping Beams
			var length = array_length_1d(isWeaponUnlocked);
			for (var i = curWeaponIndex + 1; i <= length; i++){
				// Returning back to the Power Beam
				if (i == length){
					curWeaponIndex = 0;
					fireRateTimer = 0;
					missilesEquipped = false;
					break;
				}
				// Checking for the next beam/missile that Samus can equip
				if (isWeaponUnlocked[i]){
					curWeaponIndex = i;
					fireRateTimer = 0;
					if (i == 5 || i == 6) {missilesEquipped = true;}
					else {missilesEquipped = false;}
					break;
				}
			}
		} else{
			// TODO -- Swapping Bombs	
		}
	}
} else{ // Equipping the selected beam/missile/bomb
	var index = weaponInfo[curIndex, 3];
	with(obj_player){
		if (!inMorphball){
			curWeaponIndex = index;
			fireRateTimer = 0;
			if (index == 5 || index == 6) {missilesEquipped = true;}
			else {missilesEquipped = false;}
		} else{
			// TODO -- Swapping Bombs	
		}
	}
}