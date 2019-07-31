/// @description Load in the Full Menu
// You can write your code in this editor

if (global.gameState != GAME_STATE.IN_GAME){
	instance_destroy(self);
	return;
}

// Finding out which icons are present for the player
if (!obj_player.inMorphball){
	var length = array_length_1d(obj_player.isWeaponUnlocked);
	for (var i = 0; i < length; i++){
		if (obj_player.isWeaponUnlocked[i]){
			switch(i){
				case 0: // Add the Power Beam Icon to the Menu
					weaponInfo[menuSize, 0] = spr_powerbeam_icon;
					weaponInfo[menuSize, 1] = "Power Beam";
					weaponInfo[menuSize, 2] = "";
					// Set the ammo variables to zero
					weaponInfo[menuSize, 4] = 0;
					weaponInfo[menuSize, 5] = 0;
					break;
				case 1: // Add the Ice Beam Icon to the Menu
					weaponInfo[menuSize, 0] = spr_icebeam_icon;
					weaponInfo[menuSize, 1] = "Ice Beam";
					weaponInfo[menuSize, 2] = "";
					// Set the ammo variables to zero
					weaponInfo[menuSize, 4] = 0;
					weaponInfo[menuSize, 5] = 0;
					break;
				case 2: // Add the Wave Beam Icon to the Menu
					weaponInfo[menuSize, 0] = spr_wavebeam_icon;
					weaponInfo[menuSize, 1] = "Wave Beam";
					weaponInfo[menuSize, 2] = "";
					// Set the ammo variables to zero
					weaponInfo[menuSize, 4] = 0;
					weaponInfo[menuSize, 5] = 0;
					break;
				case 3: // Add the Spazer Beam Icon to the Menu
					weaponInfo[menuSize, 0] = spr_spazerbeam_icon;
					weaponInfo[menuSize, 1] = "Spazer Beam";
					weaponInfo[menuSize, 2] = "";
					// Set the ammo variables to zero
					weaponInfo[menuSize, 4] = 0;
					weaponInfo[menuSize, 5] = 0;
					break;
				case 4: // Add the Plasma Beam Icon to the Menu
					weaponInfo[menuSize, 0] = spr_plasmabeam_icon;
					weaponInfo[menuSize, 1] = "Plasma Beam";
					weaponInfo[menuSize, 2] = "";
					// Set the ammo variables to zero
					weaponInfo[menuSize, 4] = 0;
					weaponInfo[menuSize, 5] = 0;
					break;	
				case 5: // Add the Missile Icon to the Menu
					weaponInfo[menuSize, 0] = spr_powerbeam_icon;
					weaponInfo[menuSize, 1] = "Missile Launcher";
					weaponInfo[menuSize, 2] = "";
					// Show the total missiles the player has in the quick menu
					weaponInfo[menuSize, 4] = obj_player.numMissiles;
					weaponInfo[menuSize, 5] = obj_player.maxMissiles;
					break;
				case 6: // Add the Super Missile Icon to the Menu
					weaponInfo[menuSize, 0] = spr_powerbeam_icon;
					weaponInfo[menuSize, 1] = "Super Missile Launcher";
					weaponInfo[menuSize, 2] = "";
					// Show the total super missiles the player has in the quick menu
					weaponInfo[menuSize, 4] = obj_player.numSMissiles;
					weaponInfo[menuSize, 5] = obj_player.maxSMissiles;
					break;
			}
			weaponInfo[menuSize, 3] = i;
			if (obj_player.curWeaponIndex == i){
				curIndex = menuSize;	
			}
			menuSize++;
		}
	}
} else{
	var length = array_length_1d(obj_player.isBombUnlocked);
	for (var i = 0; i < length; i++){
		if (obj_player.isBombUnlocked[i]){
			switch(i){
				case 0: // Add the Bomb Icon to the Menu
					weaponInfo[menuSize, 0] = spr_powerbeam_icon;
					weaponInfo[menuSize, 1] = "Bombs";
					weaponInfo[menuSize, 2] = "";
					break;
				case 1: // Add the Power Bomb Icon to the Menu
					weaponInfo[menuSize, 0] = spr_powerbeam_icon;
					weaponInfo[menuSize, 1] = "Power Bombs";
					weaponInfo[menuSize, 2] = "";
					// Show the total power bombs the player has in the quick menu
					weaponInfo[menuSize, 4] = obj_player.numPBombs;
					weaponInfo[menuSize, 5] = obj_player.maxPBombs;
					break;
			}
			weaponInfo[menuSize, 3] = i;
			if (obj_player.curBombIndex == i){
				curIndex = menuSize;	
			}
			menuSize++;
		}
	}
	// If nothing has been added to the menu, delete this object
	if (menuSize == 0){
		instance_destroy(self);
		return;
	}
}

// Make the HUD invisible
with(obj_hud) {isVisible = false;}

// Set the current Game State
global.gameState = GAME_STATE.PAUSED;