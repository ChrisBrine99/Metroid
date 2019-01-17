/// @description Updates Samus's current energy. (Use this script for anything that does damage or heals Samus)
/// @param amount

var amount;
amount = argument0;

// If Samus is getting damaged, the amount given should be negative.
global.energy += amount;

// If Samus's energy has depleted completely
if (global.energy < 0){
	if (global.eTanks > 0){ // Revert the energy back to 99; removing one energy tank for doing so.
		global.energy += global.maxEnergy + 1;
		global.eTanks--;
	}
	else{ // She has no energy tanks left; set energy to zero.
		obj_samus.canMove = false;
		global.energy = 0;
	}
}
else if (global.energy > global.maxEnergy){ // If Samus's energy has gone past 99 (the maximum amount of energy)
	if (global.eTanks < global.eTanksMax){ // Remove a full energy tank from the energy level; adding an energy tank for doing so.
		global.energy -= global.maxEnergy + 1;
		global.eTanks++;
	}
	else{ // If her energy tanks are full, set the energy to full as well
		global.energy = global.maxEnergy;	
	}
}

// Activates the game over process; creating Samus's death effect and playing her death sound
if (global.energy <= 0 && global.eTanks == 0){
	instance_create_depth(obj_samus.x, obj_samus.y, 50, obj_samus_death);
	audio_play_sound(snd_samus_die, 0, false);
	obj_controller.textAlpha = 1;
}