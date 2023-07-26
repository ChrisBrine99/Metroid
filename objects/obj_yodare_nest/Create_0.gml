#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Initialize function override

/// @description Initialization function for the Yodare Nest
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state); // Borrows the function pointer to "par_enemy" initialize function instead of the Yumbo Nest's initialize function.
	entity_set_sprite(spr_yodare_nest, -1);
	create_general_collider();
	initialize_weak_to_missiles();
	objToSpawn		= obj_yodare;
	spawnOffsetY	= -20;
	maxInstances	= 1;
	timeToSpawn		= 45.0;
	spawnTimer		= timeToSpawn;	// Instantly spawn first Yodare.
}

#endregion

// Initialize the Yodare Nest using its own initialize function and not the one found in its parent.
initialize(state_default);