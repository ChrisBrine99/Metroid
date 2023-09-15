#region Macro initialization

// Macro for the timer in frames (60 = 1 real-world second) that it takes for a bomb to detonate whenever
// deployed by Samus and for the value that timer must ge below in order to speed up the blinking animation.
#macro	BOMB_EXPLOSION_TIME		50
#macro	ANIM_SPEEDUP_TIME		15

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Use the inherited hitpoint variables as a timer that will result in the bomb exploding after said hitpoint
// value reaches or goes below 0. The "maxHitpoints" variable stores the total time it takes for the bomb to
// detonate; used for comparing against the time remaining in order to speed up the bomb animation after a
// certain point.
maxHitpoints	= BOMB_EXPLOSION_TIME;
hitpoints		= maxHitpoints;
// Apply a unique light source to the bomb.
object_add_light_component(x, y, 0, 0, 30, HEX_LIGHT_BLUE, 0.7);

#endregion

#region Unique variable initialization

// Much like par_collectible, the bomb will have its light flicker at the rate of its animation loop; getting
// brighter for the bright image and dimmer for the dimmer image of the bomb, repsectively. These variables
// will store the initial radius and strength of the light so it can be increased and returned to it for said
// flickering effect.
baseRadius = 30;
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
	entity_set_sprite(spr_player_bomb, spr_empty_mask);
	stateFlags |= ENTT_DRAW_SELF | ENTT_LOOP_ANIM;
}

#endregion

#region State function initializations

/// @description The bomb's sole state function. It will count down its life timer until it goes below zero.
/// Once that condition has been met, the bomb will create its explosion object and flag itself for deletion.
/// Also, once the timer goes below 25% its initial value, the sprite animation will speed up considerably.
state_default = function(){
	hitpoints -= DELTA_TIME;
	if (hitpoints <= 0){
		// Create the explosion object, and the call its initialization function or else the explosion will
		// exist, but not be visible or functional in the game world.
		var _id = instance_create_object(x, y, obj_player_bomb_explode, depth);
		with(_id) {initialize(state_default);}
		
		// Remove the state from this object and let the game know to destroy it at the start of the next frame.
		object_set_next_state(NO_STATE);
		stateFlags |= ENTT_DESTROYED;
		visible = false;
	}
	
	// Increasing the speed of the bomb's animation to signify it's close to exploding. Also applying the
	// flashing to the light sources that will link up with the two-frame animation for the bomb.
	if (hitpoints < ANIM_SPEEDUP_TIME && animSpeed == 1)
		animSpeed = 3;
	var _imageIndex		= floor(imageIndex);
	var _baseRadius		= baseRadius;
	var _baseStrength	= baseStrength;
	with(lightComponent){
		if (_imageIndex == 1)	{set_properties(_baseRadius * 1.5, color, _baseStrength * 1.5);}
		else					{set_properties(_baseRadius, color, _baseStrength);}
	}
}

#endregion