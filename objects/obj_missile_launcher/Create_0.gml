#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Determines the "starting" capacity for Samus upon unlocking the Missile Launcher. If she has collected //
//	tanks prior to the actual launcher this value will be added to that pre-existing capacity from the	   //
//	other missile tanks.																				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	START_MISSILE_AMOUNT	10

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Missile Launcher and make sure its collision mask is completely disabled. 
// Then, set the proper values for the Missile Launcher's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_missile_launcher, spr_empty_mask);
flagBit = FLAG_MISSILES;
itemID	= ID_MISSILE_LAUNCHER;

// Setup the ambient light source to match the Missile Lanucher's color scheme.
baseRadius = 24;
baseStrength = 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_WHITE, baseStrength);

#endregion

#region



#endregion

#region Editing collection function

/// @description Override the default function to grants Samus a starting amount of 10 missiles on top of 
/// enabling use of those missiles due to "FLAG_MISSILES" being set.
collectible_apply_effects = function(){
	with(PLAYER) {update_maximum_missiles(START_MISSILE_AMOUNT);}
}

#endregion