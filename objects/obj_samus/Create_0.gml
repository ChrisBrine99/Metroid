/// @description Variable Initialization

#region SINGLETON CHECK

if (global.playerID != noone){
	if (global.playerID.object_index == object_index){
		instance_destroy(self);
		return;
	}
	instance_destroy(global.playerID);
}
global.playerID = id;

#endregion

#region EDITING INHERITED VARIABLES

// Call the par_entity's create event
event_inherited();
// First, set the initial state that Samus is in
set_cur_state(state_samus_intro);
// Then, set initial values for the other necessary characteristics from the parent object
set_max_hitpoints(99, true, false);									// Max Hitpoints
set_velocity_speed(0.3, 0.25);										// Direcitonal velocities
set_max_move_speed(2.1, 8, true);									// Maximum hspd and vspd
entity_create_light(0, 0, 40, 40, 1, make_color_rgb(84, 84, 84));	// Creating ambient light source

// Set the weakness to projectiles of type Enemy for Samus
ds_list_add(projectileWeakness, Weapon.Enemy);

// Set the time Samus is invincible for after getting hit by an enemy/enemy projectile. Also, set her hit
// script to her recoil state.
timeToRecover = 60; // One second of invicibility after getting hit
hitScript = state_samus_hurt;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Keyboard input variables
keyRight = false;
keyLeft = false;
keyUp = false;
keyDown = false;
keyAuxUp = false;
keyAuxDown = false;
keyJumpStart = false;
keyJumpEnd = false;
keyWeapon = false;

// Character sprite variables //////////////////////////////////////////////////////

// Standing sprite variables
sprStandStart =			spr_power_stand0;
sprStandFwd =			spr_power_stand1;
sprStandUp =			spr_power_stand2;

// Walking sprite variables
sprWalkFwd =			spr_power_walk0;
sprWalkFwdShoot =		spr_power_walk1;
sprWalkUp =				spr_power_walk2;

// Jumping sprite variables
sprJumpSpin =			spr_power_jump0;
sprJumpFwd =			spr_power_jump1;
sprJumpUp =				spr_power_jump2;
sprJumpDown =			spr_power_jump3;

// Crouching sprite variable
sprCrouchFwd =			spr_power_crouch1;

// Morphball sprite variable
sprEnterMorphball =		spr_power_morphball0;
sprMorphball =			spr_power_morphball1;
sprSpiderball =			spr_power_morphball2;

////////////////////////////////////////////////////////////////////////////////////

// Keeps track of the left and right inputs for Samus's movement. The result of keyRight - keyLeft will 
// result in movement in the proper direction; relative to the key being held down, currently.
inputDirection = 0;

// Each of these values relate to the maximum jump height of Samus when she is outside of and inside of
// morphball mode, respectively. Both values are increased by the acquisition of the High Jump Boots.
jumpSpeed = NORM_JUMP_SPEED;
jumpSpeedMorph = NORM_JUMP_SPEED_MORPH;

// Variables relating to aiming Samus's arm cannon in one of the three valid direction: forward, upward, and
// downward. On top of that, a flag exists to let Samus know when she is actively shooting from her arm
// cannon, which will set the walking/jump sprites/states accordingly. Another flag also exists to disable
// the use of weaponry depending on the player's current state.
aimDirection = AIM_FORWARD;
canUseWeapon = true;
isShooting = false;
shootTimer = 0;

// Stores the scripts that will be called when the player uses their weapon (Beam, Missile, or Bomb). Below
// that are the current indices for the equipped weapon/bomb.
cannonScripts = ds_list_create();
ds_list_add(cannonScripts, weapon_powerbeam);
bombScripts = ds_list_create();
ds_list_add(bombScripts, weapon_bomb);
curBeam = 0;
curBomb = 0;

// A timer that keeps track of the "frames" that a directional key (keyRight or keyLeft) is held while Samus
// is in her crouching state. After that timer hits 10, (10 = 1/6th of a second) SAmus will return to her
// default state.
standTimer = 0;

#endregion