#region Macros that are useful/related to par_enemy and its children

// Determines the chance of missile ammo being dropped by the enemy when it drops ammo upon death. The remaining amount
// out of one is the chance of a power bomb charge dropping instead.
#macro	MISSILE_DROP_CHANCE		0.75

// Determines the base percentage chance that a small energy orb will be dropped instead of a large energy orb. This 
// chance is altered depending on the percentage of energy Samus has remaining relative to her current maximum. The
// remainder of 1.0 minus this value is th chance of dropped a large energy orb.
#macro	SM_ENERGY_DROP_CHANCE	0.85

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Initializing unique variables

// Stores the percentage drop chances (Ranging from 0.0 to 1.0 == 0% to 100% chance) for energy (small and large), aeion, 
// and ammunition (missiles and power bombs), respectively. The enemy will check in the order: energy, aeion, and ammo, 
// upon defeat, so if the previous value(s) equal or surpass 1.0; the remaining checks will be ignored. Another thing to 
// note is that the aeion and ammo drops are converted into a 50/50 chance at spawning an energy orb if Samus doesn't have 
// access to her missile launcher/power bomb and aeion powers, respectively.
energyDropChance = 0.0;
aeionDropChance = 0.0;
ammoDropChance = 0.0;

#endregion

#region Utility function initializations



#endregion