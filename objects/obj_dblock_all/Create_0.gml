/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Initial all of the variables contained in the parent object
event_inherited();
// First setup how long the block will be inactive for before it regenerates
timeSpentInactive = 600;	//	(60 = 1 second of real-time)
// Then, set the weaknesses of the block to all of Samus's projectiles and weaponry
ds_list_add(projectileWeakness, Weapon.All);

#endregion

#region UNIQUE VARIABLE INITIALIZATION
#endregion