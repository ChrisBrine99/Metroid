/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 13;
maxVspd = 13;
damage = 16;

// Enable the Plasma Beam to pass through walls and entities
destroyOnWallCollide = false;
destroyOnEntityCollide = false;

// Altering the ambient light's color
ambLight.lightCol = c_red;