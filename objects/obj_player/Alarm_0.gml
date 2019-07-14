/// @description Setting Samus's Sprites and Damage Resistances
// You can write your code in this editor

if (!global.item[ITEM.VARIA_SUIT] && !global.item[ITEM.GRAVITY_SUIT]){
	// Standing Sprites
	sprStand0 = spr_power_stand0;
	sprStand1 = spr_power_stand1;
	sprStand1m = spr_power_stand1m;
	sprStand2 = spr_power_stand2;
	sprStand2m = spr_power_stand2m;
	
	// Walking Sprites
	sprWalk0 = spr_power_walk0;
	sprWalk1 = spr_power_walk1;
	sprWalk1m = spr_power_walk1m;
	sprWalk2 = spr_power_walk2;
	sprWalk2m = spr_power_walk2m;
	
	// Jumping Sprites
	sprJump0 = spr_power_jump0;
	sprJump0a = spr_power_jump0a;
	sprJump0b = spr_power_jump0b;
	sprJump1 = spr_power_jump1;
	sprJump1m = spr_power_jump1m;
	sprJump2 = spr_power_jump2;
	sprJump2m = spr_power_jump2m;
	sprJump3 = spr_power_jump3;
	sprJump3m = spr_power_jump3m;
	
	// Crouching Sprites
	sprCrouch1 = spr_power_crouch1;
	sprCrouch1m = spr_power_crouch1m;
	
	// Morphball Sprites
	sprMorphball1 = spr_power_morphball1;
	
	// Set the Damage Resistance
	damageRes = 1;
} else if (global.item[ITEM.VARIA_SUIT] && !global.item[ITEM.GRAVITY_SUIT]){
	// Standing Sprites
	sprStand0 = spr_varia_stand0;
	sprStand1 = spr_varia_stand1;
	sprStand1m = spr_varia_stand1m;
	sprStand2 = spr_varia_stand2;
	sprStand2m = spr_varia_stand2m;
	
	// Walking Sprites
	sprWalk0 = spr_varia_walk0;
	sprWalk1 = spr_varia_walk1;
	sprWalk1m = spr_varia_walk1m;
	sprWalk2 = spr_varia_walk2;
	sprWalk2m = spr_varia_walk2m;
	
	// Jumping Sprites
	sprJump0 = spr_varia_jump0;
	sprJump0a = spr_varia_jump0a;
	sprJump0b = spr_varia_jump0b;
	sprJump1 = spr_varia_jump1;
	sprJump1m = spr_varia_jump1m;
	sprJump2 = spr_varia_jump2;
	sprJump2m = spr_varia_jump2m;
	sprJump3 = spr_varia_jump3;
	sprJump3m = spr_varia_jump3m;
	
	// Crouching Sprites
	sprCrouch1 = spr_varia_crouch1;
	sprCrouch1m = spr_varia_crouch1m;
	
	// Morphball Sprites
	sprMorphball1 = spr_varia_morphball1;
	
	// Set the Damage Resistance
	damageRes = 0.5;
} else if (global.item[ITEM.GRAVITY_SUIT]){
	// Standing Sprites
	sprStand0 = spr_gravity_stand0;
	sprStand1 = spr_gravity_stand1;
	sprStand1m = spr_gravity_stand1m;
	sprStand2 = spr_gravity_stand2;
	sprStand2m = spr_gravity_stand2m;
	
	// Walking Sprites
	sprWalk0 = spr_gravity_walk0;
	sprWalk1 = spr_gravity_walk1;
	sprWalk1m = spr_gravity_walk1m;
	sprWalk2 = spr_gravity_walk2;
	sprWalk2m = spr_gravity_walk2m;
	
	// Jumping Sprites
	sprJump0 = spr_gravity_jump0;
	sprJump0a = spr_gravity_jump0a;
	sprJump0b = spr_gravity_jump0b;
	sprJump1 = spr_gravity_jump1;
	sprJump1m = spr_gravity_jump1m;
	sprJump2 = spr_gravity_jump2;
	sprJump2m = spr_gravity_jump2m;
	sprJump3 = spr_gravity_jump3;
	sprJump3m = spr_gravity_jump3m;
	
	// Crouching Sprites
	sprCrouch1 = spr_gravity_crouch1;
	sprCrouch1m = spr_gravity_crouch1m;
	
	// Morphball Sprites
	sprMorphball1 = spr_gravity_morphball1;
	
	// Set the Damage Resistance
	damageRes = 0.25;	
}