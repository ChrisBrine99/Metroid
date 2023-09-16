#region Macro value initializations

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the "stateFlags" variable. They represent substates for bits that are	   //
//	unique to all destructible objects, which are similar to standard colliders aside from the fact that   //
//	they can be destroyed by Samus or the environment.													   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DEST_USE_EFFECTS		0x00200000	// Toggles use of destruction/rebuild effect for the object.
#macro	DEST_HIDDEN				0x00400000	// Enables ability to hide the object behind a tile within the room's tileset.
// NOTE -- Bits 0x00800000 and greater are already in use by default static entity substate flags.

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check for these general Destructible substates.			   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DEST_CAN_USE_EFFECTS	(stateFlags & DEST_USE_EFFECTS)
#macro	DEST_IS_HIDDEN			(stateFlags & DEST_HIDDEN)

// ------------------------------------------------------------------------------------------------------- //
//	Values here represent the time in "frames" (60 units == 1 second) that a destructible will remain in   //
//	its "destroyed" (Isn't the same as flipping the ENTT_DESTROYED bit to one) state until it regenerates. //
//	The value -255.0 means the block will not regenerate and will flip that substate bit to one.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DEST_RESPAWN_INFINITE  -255.0	//	inf
#macro	DEST_RESPAWN_GENERAL	600.0	//	10.0s
#macro	DEST_RESPAWN_BOMB		1200.0	//	20.0s
#macro	DEST_RESPAWN_WEIGHT		30.0	//	 0.5s
#macro	DEST_RESPAWN_SCREWATK	450.0	//	 7.0s

// ------------------------------------------------------------------------------------------------------- //
//	Stores the length of the regeneration effect's animation in frames/images within the sprite.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DEST_REGEN_ANIM_EFFECT	4

// ------------------------------------------------------------------------------------------------------- //
//	Values that store the minimum distance both horizontally and vertically that Samus needs to meet or	   //
//	be within relative to the destructible before it can be "destroyed" by her Screw Attack ability.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DEST_SCREWATK_XBOUNDS	16
#macro	DEST_SCREWATK_YBOUNDS	24

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Make the entity visible within the room and set its state bits up so it draws the sprite that is set for 
// any child destructible object. Also, set the sprite index so it doesn't trigger the drawing code for the
// object until "entity_set_sprite" is called. Otherwise, the game will crash trying to draw an invalid sprite.
stateFlags	   |= ENTT_DRAW_SELF | DEST_USE_EFFECTS;
sprite_index	= NO_SPRITE;
visible			= true;

#endregion

#region Unique variable initializations

// Stores the pointer value for a destruction or rebuilding effect that may exist for when a destructible
// transitions between its standard and "destroyed" states, respectively.
effectID = noone;

// This variable pair is used for any destructible blocks that are hidden within the game's world. They will
// store the required tile set and tile information to render that tile on top of them until they are no longer
// hidden.
tileset		= -1;
tiledata	= -1;
// Note -- TILEMAP LOGIC STILL NEEDS TO BE IMPLEMENTED!!

// The top value stores the block's unique time in "frames" (One frame is equal to 1/60th of a second of real 
// time) before the block will attempt to respawn itself after being destroyed. Setting this value to the macro 
// "RESPAWN_TIMER_INFINITE" will cause the block to destroy itself for the duration of the room's existence. 
// Finally, the bottom value simply tracks the time elapsed since the block was considered "destroyed".
timeToRespawn	= 0.0;
respawnTimer	= 0.0;

#endregion

#region Utility function initializations

/// @description The function that should be called whenever a valid projectile, entity, or explosion has triggered
/// a collision between itself and a destructible object that is affected by it. It will create an instance of
/// a struct that is used for animating the block's destruction while also temporarily disabling collision and
/// sprite rendering for the block in question.
destructible_destroy_self = function(){
	// Update the state flags for the block so that it is no longer visible or interactable (Collision) with
	// the player object. These states are reversed if the block can rebuild itself.
	stateFlags &= ~(ENTT_DRAW_SELF | DEST_HIDDEN);
	stateFlags |= ENTT_DESTROYED;
	mask_index	= spr_empty_mask;
	
	// Don't process destructible effect logic if the instance in question doesn't have effect enabled.
	if (!DEST_CAN_USE_EFFECTS) {return;}
	
	// Copy over the coordinates and instance ID for the destructible so it can be copied over to the effect
	// instance all at once instead of needing to jump back and forth to get the same data.
	var _x	= x;
	var _y	= y;
	var _id = id;
	
	// Create the "obj_destructible_effect" struct; storing its instance ID in the "effectID" variable so it
	// can be managed by the block that created it. The required information is copied over and the effect
	// is set up to animate normally.
	effectID = instance_create_struct(obj_destructible_effect);
	with(effectID){
		x			= _x;
		y			= _y;
		parentID	= _id;
		imageIndex	= 0;	// Ensures the animation plays forward.
		animSpeed	= 1.0;
	}
}

/// @description A function that is basically the reverse of the above function with a few added factors to
/// consider during the "rebuilding" phase. It automatically cleans up the effect struct's pointer data and
/// resets the block to its normal state if possible (The block will no longer be hidden until the player
/// leaves the room and comes back again).
destructible_rebuild_self = function(){
	// Remove the effect struct that plays the block destruction animation in reverse in order to have it
	// "rebuild" itself before instantly reappearing in the world.
	instance_destroy_struct(effectID);
	delete effectID; effectID = noone;
	
	// In order to properly rebuild, a collision check is done with the area occupied by the block and any
	// dynamic entities. If there is an entity within the space, the block will be unable to rebuild and will
	// instead destroy itself again for its required duration. It will repeat this until no collisions are
	// found in the block's space.
	mask_index = -1;	// Sets the collision mask to match the current sprite's collision data.
	if (place_meeting(x, y, par_dynamic_entity)){
		destructible_destroy_self();
		return;
	}
	stateFlags |= ENTT_DRAW_SELF;
}

#endregion