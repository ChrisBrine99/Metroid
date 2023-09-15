#region Macro initialization

// Macro for the timer in frames (60 = 1 real-world second) that it takes for a power bomb to detonate whenever
// deployed by Samus.
#macro	PBOMB_EXPLOSION_TIME	30

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Use the inherited hitpoint variables as a timer that will result in the bomb exploding after said hitpoint
// value reaches or goes below 0. The "maxHitpoints" variable stores the total time it takes for the bomb to
// detonate; used for comparing against the time remaining in order to speed up the bomb animation after a
// certain point.
maxHitpoints	= 30;
hitpoints		= maxHitpoints;
// Apply a unique light source to the power bomb.
object_add_light_component(x, y, 0, 0, 60, HEX_LIGHT_YELLOW, 0.7);

#endregion

#region Unique variable initialization

// Much like par_collectible, the bomb will have its light flicker at the rate of its animation loop; getting
// brighter for the bright image and dimmer for the dimmer image of the bomb, repsectively. These variables
// will store the initial radius and strength of the light so it can be increased and returned to it for said
// flickering effect.
baseRadius	 = 75;
baseStrength = 0.7;

#endregion

#region Object initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
__initialize = initialize;
/// @description Initializes the bomb object; setting its state, flipping the bit to enable its rendering,
/// and setting its sprite.
/// @param {Function}	state
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_player_power_bomb, spr_empty_mask);
	stateFlags |= ENTT_DRAW_SELF | ENTT_LOOP_ANIM;
}

#endregion

#region State function initializations

/// @description The power bomb's sole state function, which functions identically to the regular bomb's state
/// aside from the removal of the animation speed's increase near the detonation of it.
state_default = function(){
	hitpoints -= DELTA_TIME;
	if (hitpoints <= 0){
		// Create the explosion object, and the call its initialization function or else the explosion will
		// exist, but not be visible or functional in the game world.
		var _id = instance_create_object(x, y, obj_player_power_bomb_explode, depth);
		with(_id) {initialize(state_default);}
		
		// Remove the state from this object and let the game know to destroy it at the start of the next frame.
		object_set_next_state(NO_STATE);
		stateFlags |= ENTT_DESTROYED;
		visible = false;
	}
}

#endregion