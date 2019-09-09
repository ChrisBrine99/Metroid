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
					menuOption[numColumns, 0] = "Power Beam";
					optionDesc[numColumns, 0] = "My suit's standard weapon that was made by\nthe Chozo. It's damage is very low, but it\nis capable of opening blue doors.";
					menuSprite[numColumns, 0] = spr_powerbeam_icon;
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = 0;
					menuOptionExt[numColumns, 2] = 0;
					break;
				case 1: // Add the Ice Beam Icon to the Menu
					menuOption[numColumns, 0] = "Ice Beam";
					optionDesc[numColumns, 0] = "A more advanced beam capable of freezing\nmost enemies upon contact. Even still, it\ndeals low damage, while opening white doors.";
					menuSprite[numColumns, 0] = spr_icebeam_icon;
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = 0;
					menuOptionExt[numColumns, 2] = 0;
					break;
				case 2: // Add the Wave Beam Icon to the Menu
					menuOption[numColumns, 0] = "Wave Beam";
					optionDesc[numColumns, 0] = "A beam of pure energy that moves in a\nsine-shape. It has decent damage output\nand can open pink doorways.";
					menuSprite[numColumns, 0] = spr_wavebeam_icon;
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = 0;
					menuOptionExt[numColumns, 2] = 0;
					break;
				case 3: // Add the Spazer Beam Icon to the Menu
					menuOption[numColumns, 0] = "Spazer Beam";
					optionDesc[numColumns, 0] = "A powerful beam that splits into three\nprojectiles. It can open up areas locked\nbehind green doorways.";
					menuSprite[numColumns, 0] = spr_spazerbeam_icon;
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = 0;
					menuOptionExt[numColumns, 2] = 0;
					break;
				case 4: // Add the Plasma Beam Icon to the Menu
					menuOption[numColumns, 0] = "Plasma Beam";
					optionDesc[numColumns, 0] = "A dangerously powerful beam that cuts\nthrough all forms of matter. It allows me to\nopen up dark red doorways.";
					menuSprite[numColumns, 0] = spr_plasmabeam_icon;
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = 0;
					menuOptionExt[numColumns, 2] = 0;
					break;
				case 5: // Add the Missile Icon to the Menu
					menuOption[numColumns, 0] = "Missile Launcher";
					optionDesc[numColumns, 0] = "A modification to my arm cannon that allows\nit to fire missiles. These missiles are\npowerful and can open up red doors.";
					menuSprite[numColumns, 0] = spr_powerbeam_icon; // TODO -- Add missile icon
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = obj_player.numMissiles;
					menuOptionExt[numColumns, 2] = obj_player.maxMissiles;
					break;
				case 6: // Add the Super Missile Icon to the Menu
					menuOption[numColumns, 0] = "Super Missile Launcher";
					optionDesc[numColumns, 0] = "These missiles pack quite the punch; decimating\nenemies almost instantly. They can also\nopen up purple doorways blocking my path.";
					menuSprite[numColumns, 0] = spr_powerbeam_icon; // TODO -- Add super missile icon
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = obj_player.numSMissiles;
					menuOptionExt[numColumns, 2] = obj_player.maxSMissiles;
					break;
			}
			menuOptionExt[numColumns, 0] = i;
			if (obj_player.curWeaponIndex == i){
				curOption[X] = numColumns;
			}
			numColumns++;
		}
	}
} else{
	var length = array_length_1d(obj_player.isBombUnlocked);
	for (var i = 0; i < length; i++){
		if (obj_player.isBombUnlocked[i]){
			switch(i){
				case 0: // Add the Super Missile Icon to the Menu
					menuOption[numColumns, 0] = "Bombs";
					optionDesc[numColumns, 0] = "A deployable bomb for my morphball form. Its\ndamage is low, but it can blast away certain\nwalls and barricades.";
					menuSprite[numColumns, 0] = spr_powerbeam_icon; // TODO -- Add bomb icon
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = 0;
					menuOptionExt[numColumns, 2] = 0;
					break;
				case 1: // Add the Super Missile Icon to the Menu
					menuOption[numColumns, 0] = "Power Bombs";
					optionDesc[numColumns, 0] = "";
					menuSprite[numColumns, 0] = spr_powerbeam_icon; // TODO -- Add power bomb icon
					// Set the ammo variables to zero
					menuOptionExt[numColumns, 1] = obj_player.numPBombs;
					menuOptionExt[numColumns, 2] = obj_player.maxPBombs;
					break;
			}
			menuOptionExt[numColumns, 0] = i;
			if (obj_player.curBombIndex == i){
				curOption[X] = numColumns;	
			}
			numColumns++;
		}
	}
	// If nothing has been added to the menu, delete this object
	if (numColumns == 0){
		instance_destroy(self);
		return;
	}
}
// Set the number of rows in the menu to 1
numRows = 1;
activeMenu = true;

// Make the HUD invisible
with(obj_hud) {isVisible = false;}

// Set the current Game State
global.gameState = GAME_STATE.PAUSED;