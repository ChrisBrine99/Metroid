/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Initial all of the variables contained in the parent object
event_inherited();
// Stop the item ball from regenerating and from playing the destruction effect
createDestroyEffect = false;
timeSpentInactive = -1;
// Then, set the weaknesses of the block to all of Samus's projectiles and weaponry
ds_list_add(projectileWeakness, Weapon.PowerBeam, 
								Weapon.IceBeam, 
								Weapon.WaveBeam, 
								Weapon.SpazerBeam, 
								Weapon.PlasmaBeam, 
								Weapon.Bomb, 
								Weapon.PowerBomb, 
								Weapon.Missile, 
								Weapon.SuperMissile);

#endregion

#region UNIQUE VARIABLE INITIALIZATION
#endregion