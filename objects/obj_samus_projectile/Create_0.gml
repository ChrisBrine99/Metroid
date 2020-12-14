/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

event_inherited();
// Create the ambient light source
entity_create_light(0, 0, 15, 15, 1, c_white);

#endregion

#region UNIQUE VARIABLE INITIALIZATION

projectileAnimates = false;
curFrame = 0;
spriteSpeed = 0;
spriteNumber = 0;

#endregion