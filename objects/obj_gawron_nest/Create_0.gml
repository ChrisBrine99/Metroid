#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Initialize function override

/// @description Initialization function for the Yodare Nest which functions identically to how the Yumbo Nest
/// initializes itself--aside from the spawner characteristics of the nests. The "__initialize" function is 
/// created within "obj_yumbo_nest", which is the parent object for all other "spawner" type enemy objects, so 
/// its creation isn't required.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state); // Borrows the function pointer to "par_enemy" initialize function instead of the Yumbo Nest's initialize function.
	entity_set_sprite(spr_gawron_nest, -1);
	create_general_collider();
	
	// Set up weakness flags such that the Gawron Nest is only weak to missiles.
	weaknessFlags  |= ENMY_REGMISSILE_WEAK | ENMY_SUPMISSILE_WEAK | 
						ENMY_ICEMISSILE_WEAK | ENMY_SHKMISSILE_WEAK;
	
	// Set up the nest so it only spawns a single Gawron at any given time; offset down by 16 pixels so it
	// is hidden by the environment when it spawns into the world.
	objToSpawn		= obj_gawron;
	spawnOffsetY	= 16;
	maxInstances	= 1;
	timeToSpawn		= 75.0;
	spawnTimer		= timeToSpawn * 0.5;
	spawnRadius		= 0.0; // As long as it's on screen it can spawn Gawron.
}

#endregion

// Initialize the Yodare Nest using its own initialize function and not the one found in its parent.
initialize(state_default);