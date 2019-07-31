/// @description Updating the currently equipped weapon's icon on the HUD
// You can write your code in this editor

var weaponIcons, bombIcons, ammo, maxAmmo;
weaponIcons = [spr_powerbeam_icon, spr_icebeam_icon, spr_wavebeam_icon, spr_spazerbeam_icon, spr_plasmabeam_icon, spr_powerbeam_icon, spr_powerbeam_icon];
bombIcons = [spr_powerbeam_icon, spr_powerbeam_icon];

with(obj_player){
	if (!inMorphball){
		// Initialize the ammo arrays with values based on Samus's missile counts
		ammo = [0, 0, 0, 0, 0, numMissiles, numSMissiles];
		maxAmmo = [0, 0, 0, 0, 0, maxMissiles, maxSMissiles];
		// Update the GUI variables
		global.curAmmo = ammo[curWeaponIndex];
		global.maxAmmo = maxAmmo[curWeaponIndex];
		global.iconSpr = weaponIcons[curWeaponIndex];	
	} else{
		// Find out if the player has bombs and/or power bombs unlocked
		var hasBombs, length;
		hasBombs = false;
		length = array_length_1d(isBombUnlocked);
		for (var i = 0; i < length; i++){
			if (isBombUnlocked[i]){
				hasBombs = true;
				break;
			}
		}
		// Only bother initializing IF the player has bombs unlocked
		if (hasBombs){
			// Initialize the ammo arrays with values based on Samus's bomb counts
			ammo = [0, numPBombs];
			maxAmmo = [0, maxPBombs];
			// Update the GUI variables
			global.curAmmo = ammo[curBombIndex];
			global.maxAmmo = maxAmmo[curBombIndex];
			global.iconSpr = bombIcons[curBombIndex];
		} else{
			global.curAmmo = 0;
			global.maxAmmo = 0;
			global.iconSpr = spr_locked_weapon_icon;
		}
	}
}