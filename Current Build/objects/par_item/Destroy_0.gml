/// @description Setting the correct item variable to true
// You can write your code in this editor

if (!giveReward){
	return;	
}

switch(itemIndex){
	case 0: // Morphball
		global.morphball = true;
		break;
	case 1: // Bombs
		global.bombs = true;
		// Locking the door for the boss fight event
		instance_create_depth(16, 48, 200, obj_door);
		obj_door.type = -1;
		obj_door.closing = true;
		obj_door.image_index = 2;
		break;
	case 2: // Spiderball
		global.spiderBall = true;
		break;
	case 3: // Springball
		global.springBall = true;
		break;
	case 4: // High Jump
		global.highJump = true;
		obj_samus.jumpSpd = -7.4;
		break;
	case 5: // Space Jump
		global.spaceJump = true;
		break;
	case 6: // Screw Attack
		global.screwAttack = true;
		break;
	case 7: // Varia Suit
		global.variaSuit = true;
		// Changing the sprite variables
		if (!global.gravitySuit){
			scr_set_sprite_varia();
		}
		break;
	case 8: // Gravity Suit
		global.gravitySuit = true;
		scr_set_sprite_gravity();
		break;
	case 9: // Ice Beam
		if (!global.iceBeam){
			global.iceBeam = true;
			global.maxBeamIndex = 1;
		}
		break;
	case 10: // Wave Beam
		if (!global.waveBeam){
			global.waveBeam = true;
			global.maxBeamIndex = 2;
		}
		break;
	case 11: // Spazer Beam
		if (!global.spazerBeam){
			global.spazerBeam = true;
			global.maxBeamIndex = 3;
		}
		break;
	case 12: // Plasma Beam
		if (!global.plasmaBeam){
			global.plasmaBeam = true;
			global.maxBeamIndex = 4;
		}
		break;
	case 13: // Missile Tank
		if (subIndex >= 0 && subIndex < 50 && !global.missile[subIndex]){
			global.missile[subIndex] = true;
			if (global.missilesMax < 250){
				if (global.missilesMax == 0) global.maxEquipmentIndex = 1;
				global.missilesMax += 5;
				global.missiles += 5;
			}
		}
		break;
	case 14: // Super Missile Tank
		if (subIndex >= 0 && subIndex < 25 && !global.sMissile[subIndex]){
			global.sMissile[subIndex] = true;	
			if (global.sMissilesMax < 50){
				if (global.sMissilesMax == 0) global.maxEquipmentIndex = 2;
				global.sMissilesMax += 2;
				global.sMissiles += 2;
			}
		}
		break;
	case 15: // Power Bomb Tank
		if (subIndex >= 0 && subIndex < 25 && !global.pBomb[subIndex]){
			global.pBomb[subIndex] = true;	
			if (global.pBombsMax < 50){
				if (global.pBombs == 0) global.maxEquipmentIndex = 3;
				global.pBombsMax += 2;
				global.pBombs += 2;
			}
		}
		break;
	case 16: // Energy Tank
		if (subIndex >= 0 && subIndex < 12){
			global.eTank[subIndex] = true;	
			if (global.eTanksMax < 12){
				global.eTanksMax++;
				scr_update_energy(100);
			}
		}
		break;
}