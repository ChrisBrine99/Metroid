/// @description Initializing Samus's variables
// You can write your code in this editor

#region Setting the playerID variable to this instance's ID if no other player exists already

if (global.playerID != noone){
	if (global.playerID.object_index == obj_player){
		instance_destroy(self);	
	}
}
global.playerID = id;

#endregion

#region Altering the Default Entity Variables

// Call the entity create event
scr_entity_create(2.1, 7, 0.3, -5, 0.25, 270);

// Editing the cur/maxHitpoints and cur/maxLives variables
maxHitpoints = 99;				// The max amount of "Energy" for Samus
curHitpoints = maxHitpoints;
maxLives = 0;					// The total "Energy Tanks" Samus currently has
curLives = 0;

// The variable that calculates how much damage Samus takes from attacks
damageRes = 1;					// 1 = 100%, 0.5 = 50%, etc.

#endregion

#region Unique Variables for the Player

// Some variables for currently equipped projectile and what has been unlocked yet
curWeaponIndex = 0;
isWeaponUnlocked = [true, false, false, false, false, false, false];

// Indexes for the various projectile weapons Samus can obtain:
//		0 = Power Beam
//		1 = Ice Beam
//		2 = Wave Beam
//		3 = Spazer Beam
//		4 = Plasma Beam
//		5 = Missiles
//		6 = Super Missiles

// Some variables for currently equipped bomb and what has been unlocked yet
curBombIndex = 0;
isBombUnlocked = [false, false];

// Indexes for the various bombs Samus can obtain:
//		0 = Bombs
//		1 = Power Bombs

// Samus's current ammo for her Missiles, Super Missiles, and Power Bombs
numMissiles = 0;
maxMissiles = 0;
numSMissiles = 0;
maxSMissiles = 0;
numPBombs = 0;
maxPBombs = 0;

// The maximum fire rate of Samus's various weapons (Measured in frames)
powerBeamFR = 1;
iceBeamFR = 6;
waveBeamFR = 15;
spazerBeamFR = 25;
plasmaBeamFR = 30;
missileFR = 20;	
sMissileFR = 50;
fireRateTimer = 0;				// The timer that is used for fire rates
shootStateTimer = 20;			// The timer for how long Samus has her beam out for shooting

// Some state variables for Samus
hasStarted = false;				// When false, Samus will be standing still while facing foreward
facingRight = true;				// Determines the direction that Samus will be facing
jumpspin = false;				// If true, Samus will be somersaulting in the air
crouching = false;				// If true, the player is currently crouching 
inMorphball = false;			// If true, Samus is in her morphball mode
isShooting = false;				// If true, Samus is firing a bullet from her arm cannon
missilesEquipped = false;		// If true, the player current has their missiles equipped

// If true, the up or down key will no longer be "pressed"
hasPressedUp = false;
hasPressedDown = false;

// The time in frames it will take for Samus to stand up when crouching and hitting left or right
standTimerMax = 8;
standTimer = standTimerMax;

// The timer for the footstep sound effect
footstepTimerMax = 12;
footstepTimer = footstepTimerMax;

// Allows the morphball to bounce
vspdRecoil = 0;

// The variable to hold the instance of Samus's ambient light source
ambLight = noone;

// Create the in-game HUD
instance_create_depth(0, 0, 15, obj_hud);

// Play her little intro fanfare
fanfarePlayed = false;

// Set Samus's sprites
alarm[0] = 1;

// Lock the camera onto her
with(obj_camera) {curObject = obj_player;}
scr_camera_relock();

instance_create_depth(0, 0, 10, obj_map);

#endregion