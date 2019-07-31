/// @description Initializing Samus's variables
// You can write your code in this editor

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
for (var i = 0; i < 9; i++){
	isWeaponUnlocked[i] = false;
}
// Indexes for the various projectile weapons Samus can obtain:
//		0 = Power Beam
//		1 = Ice Beam
//		2 = Wave Beam
//		3 = Spazer Beam
//		4 = Plasma Beam
//		5 = Missiles
//		6 = Super Missiles

// The Power Beam should be unlocked by default
isWeaponUnlocked[0] = true;

// Some variables for currently equipped bomb and what has been unlocked yet
curBombIndex = 0;
for (var ii = 0; ii < 2; ii++){
	isBombUnlocked[i] = false;	
}
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
standTimer = 8;

// Allows the morphball to bounce
vspdRecoil = 0;

// Holds the instance ID for the ambient light that is around Samus
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
ambLight.xRad = 35;
ambLight.yRad = 35;
ambLight.lightCol = c_ltgray;
ambLight.persistent = true;

// Create the in-game HUD
instance_create_depth(0, 0, 15, obj_hud);

// Set Samus's sprites
alarm[0] = 1;

#endregion