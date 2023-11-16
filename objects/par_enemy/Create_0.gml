#region Macros that are useful/related to par_enemy and its children

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the "stateFlags" variable. These represent states and properties that don't //
//  need to be tied to a specific function due to these states being allowed across multiple main states.  //																						   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENMY_AILMENT_ACTIVE		0x00080000
#macro	ENMY_DROP_ITEM			0x00100000
// NOTE -- Bits 0x00200000 and greater are already in use by default dynamic entity substate flags.

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check if an Enemy is using one of these substates.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENMY_HAS_AILMENT		(stateFlags & ENMY_AILMENT_ACTIVE)
#macro	ENMY_CAN_DROP_ITEM		(stateFlags & ENMY_DROP_ITEM)

// ------------------------------------------------------------------------------------------------------- //
//	Values for bits within the "weaknessFlags" variable. They store a one (1) or a zero (0) to determine   //
//	whether or not a given beam/missile/bomb/ability that Samus has available to her will damage the enemy //
//	instance or not. The ability to inflict ailments on an enemy is also determines by bits stored within  //
//	the same variable.																					   //
// ------------------------------------------------------------------------------------------------------- //

// --- Beam Weakness Flags --- //
#macro	ENMY_POWBEAM_WEAK		0x00000001
#macro	ENMY_ICEBEAM_WEAK		0x00000002
#macro	ENMY_WAVBEAM_WEAK		0x00000004
#macro	ENMY_PLSBEAM_WEAK		0x00000008
#macro	ENMY_CHRBEAM_WEAK		0x00000010
// --- Missile Weakness Flags --- //
#macro	ENMY_REGMISSILE_WEAK	0x00000020
#macro	ENMY_SUPMISSILE_WEAK	0x00000040
#macro	ENMY_ICEMISSILE_WEAK	0x00000080
#macro	ENMY_SHKMISSILE_WEAK	0x00000100
// --- Bomb Weakness Flags --- //
#macro	ENMY_REGBOMB_WEAK		0x00000200
#macro	ENMY_POWBOMB_WEAK		0x00000400
// --- Screw Attack Weakness Flag --- //
#macro	ENMY_SCREWATK_WEAK		0x00000800
// --- Ailment Weakness Flags --- //
#macro	ENMY_STUN_WEAK			0x00001000
#macro	ENMY_SHOCK_WEAK			0x00002000
#macro	ENMY_FREEZE_WEAK		0x00004000

// Macros for the ailments based on their priority; where the higher number will overwrite the previous one
// should it be inflicted while the enemy is already affected by some lower priority ailment.

// ------------------------------------------------------------------------------------------------------- //
//	Values for the various ailments that can potentially be inflicted on an enemy. The higher indexes have //
//	a greater priority than the lower ones. This means a "stunned" enemy will become "frozen" if hit by	   //
//	an ice-based weapon, but it can't go from "frozen" to "stunned" due to the latter having a lower	   //
//	priority by comparison.																				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	AIL_NONE				0
#macro	AIL_STUNNED				1
#macro	AIL_SHOCKED				2
#macro	AIL_FROZEN				3

// ------------------------------------------------------------------------------------------------------- //
//	Values that represent how long an enemy will be inflicted by its respective ailment. The units are	   //
//	equivalent to roughly 60.0 per real-world second.													   //
// ------------------------------------------------------------------------------------------------------- //

#macro	STUN_DURATION			30.0
#macro	SHOCK_DURATION			60.0
#macro	FROZEN_DURATION			600.0

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	ENMY_SMENERGY_DROP		0
#macro	ENMY_LGENERGY_DROP		1
#macro	ENMY_SMMISSILE_DROP		2
#macro	ENMY_LGMISSILE_DROP		3
#macro	ENMY_AEION_DROP			4
#macro	ENMY_POWBOMB_DROP		5
#macro	ENMY_TOTAL_DROPS		6

#endregion

#region Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Initializing unique variables

// Keeps the instance ID of the spawner that created this Enemy object so it can decrement the "curInstances"
// value within said spawner object upon death.
linkedSpawnerID = noone;

// Stores the weapon colliders that are attached to the Enemy object, which are responsible for handling
// collisions with player projectiles and weaponry.
colliderIDs		= ds_list_create();

// Stores the damage prior to any damage reduction due to difficulty settings or Samus's current suit upgrades.
// The stun duration determines how long in "unit frames" (60 = 1 real-world second), to prevent any input from
// the player after Samus takes damage.
damage		 = 0;
stunDuration = 0.0;

// 
dropChances	= array_create(ENMY_TOTAL_DROPS, 0);

// A 32-bit value that stores ones and zeros at various bits within the value. A one (1) allows the enemy to
// be damaged by a certain piece of weaponry or inflicted by a given ailment. A azero (0) means the enemy has
// complete immunity against the weapon/ailment in question.
weaknessFlags	= 0;

// Stores the current ailment that has afflicted the Enemy. The last variable stores the timer that will cure
// the Enemy of the ailment once its value reaches or goes below zero.
curAilment		= AIL_NONE;
ailmentTimer	= 0.0;

// Variables related to an Enemy's frozen status ailment. The first stores the ID for the temporary block that 
// allows an enemy to act as a platform while it is frozen. Meanwhile, the second will store the threshold that
// determines how much hp the enemy has to have left before it can be frozen by an ice-based weapon.
platformID		= noone;
freezeThreshold = 0.25;

// Variables for an enemy's shaking effect that occurs whenever they take damage from an attack. The first two
// values are responsible for keeping track of the position the enemy was in when the effect was initialized;
// acting as the origin of the shake. Finally, the strength determines how far from that center the randomized
// per-frame position update can place the enemy at.
stunX			= 0;
stunY			= 0;
stunStrength	= 0;

// Variables that are responsible for handling a horizontal shift of one pixel to the left and right at a 
// regular interval determined by the Enemy utilizing this effect.
shiftBaseX		= 0xFFFFFFFF;
shiftTimer		= 0.0;

#endregion

#region Default initialize function override

/// @description The default initialization function for an Enemy entity. By default, they will all be toggled
/// to visible while also having their loop animation flag flipped to true. On top of that, Enemies will have
/// a default recovery period of 1/60th units (60 units = 1 second).
/// @param {Function}	state	The function to use for this entity's initial state.
initialize = function(_state){
	object_set_next_state(_state);
	stateFlags	   |= ENTT_DRAW_SELF | ENTT_LOOP_ANIM;
	recoveryLength	= 1.0;
	visible			= true;
}

#endregion

#region Hitpoint and hitstun function initializations

/// Stores the pointer to the parent "update_hitpoints" function to allow the inherited version of the function
/// to call the logic from the base function despite overriding it to add more functionality.
__update_hitpoints = update_hitpoints;
/// @description A simple modification of the standard Entity "update_hitpoints" function that flips the flag
/// "ENMY_DROP_ITEM" to true, which actually allows the enemy to drop an item upon death from taking too much 
/// damage.
update_hitpoints = function(_modifier){
	__update_hitpoints(_modifier);
	if (hitpoints == 0) {stateFlags |= ENMY_DROP_ITEM;}
}

/// Stores the parent object's function for applying a hitstun effect onto an entity so it can be called in
/// this function definition that would overwrite the reference to the original otherwise.
__entity_apply_hitstun = entity_apply_hitstun;
/// @description A hitstun function unique to enemy entities. It will send them into their hitstun state while
/// also applying a shake effect--its intensity varying depending on the damage it sustained--during the hitstun.
/// @param {Real}	duration	Time in "frames" to apply the hitstun (Excluding the recovery) for (60 frames = 1 second).
/// @param {Real}	damage		Damage to deduct to the entity's current hitpoints.
entity_apply_hitstun = function(_duration, _damage){
	// Don't set up the hitstun state if the Enemy in question currently has an ailment active OR if the Enemy
	// is already considered hit stunned. Hit stunning an already hit stunned enemy causes it to softlock.
	if (curAilment != AIL_NONE || nextState == state_hitstun){
		update_hitpoints(-_damage);
		return;
	}
	__entity_apply_hitstun(_duration, _damage);
	object_set_next_state(state_hitstun);
	stunStrength = min(floor(1 + _damage * 0.25), 4);
	stunX = x;
	stunY = y;
}

#endregion

#region Utility function initialization

/// @description Creates a new weapon collider for the Enemy, which is a region that can only be collided with
/// by Samus's weapons. Its position and size can be set independent of the Enemy's bounding box, and multiple
/// can be created to have areas that can't be damaged by Samus and areas that can be based on the value of the
/// collider's "immunityArea" flag.
/// @param {Real}	x				The x position of the immunity bounding box relative to the Enemy's own x position.
/// @param {Real}	y				The y position of the immunity bounding box relative to the Enemy's own y position.
/// @param {Real}	width			Size of the bounding box along the x axis.
/// @param {Real}	height			Size of the bounding box along the y axis.
/// @param {Bool}	isImmunityArea	Flag that toggles the effect of Samus's weaponry on and off for collider region.
create_weapon_collider = function(_x, _y, _width, _height, _isImmunityArea = false){
	var _parentID	= id;
	var _instance	= instance_create_object(x + _x, y + _y, obj_enemy_collider);
	with(_instance){ // Copy characteristics into immunity area.
		parentID		= _parentID;
		offsetX			= _x;
		offsetY			= _y;
		isImmunityArea	= _isImmunityArea;
		image_xscale	= _width;
		image_yscale	= _height;
	}
	ds_list_add(colliderIDs, _instance);
}

/// @description Creates a general bounding box for Samus's weapons to check collision's against that is the
/// exact size of its actual collider used for collisions against the world and Samus, for example. This assumes
/// the Enemy's origin is centered and that isn't considered an "immunity" collider.
create_general_collider = function(){
	var _width	= (bbox_right - bbox_left);
	var _height = (bbox_bottom - bbox_top); 
	var _x		= -(_width >> 1);
	var _y		= -(_height >> 1);
	create_weapon_collider(_x, _y, _width, _height);
}

/// @description Edits the parameters of an existing weapon collider. This allows an already created collider
/// to be repositioned, resized, and have its susceptibility to Samus' weapons toggled on/off as needed.
/// @param {Real}	index			Which attached collider is going to be adjusted.
/// @param {Real}	x				New x offset relative to the Enemy's x position for the collider.
/// @param {Real}	y				New y offset relative to the Enemy's y position for the collider.
/// @param {Real}	width			Value to change the collider's width to; in pixels.
/// @param {Real}	height			Value to change the collider's height to; in pixels.
/// @param {Bool}	isImmunityArea	Toggles the collider's immunity against Samus's weaponry on/off.
edit_weapon_collider = function(_index, _x, _y, _width, _height, _isImmunityArea){
	if (_index >= ds_list_size(colliderIDs)) {return;}
	with(colliderIDs[| _index]){
		offsetX			= _x;
		offsetY			= _y;
		image_xscale	= _width;
		image_yscale	= _height;
		isImmunityArea	= _isImmunityArea;
	}
}

/// @description Horizontally shifts the Enemy along the x axis by one pixel to either the left or right; relative
/// to the direction it had previously shifted toward. Updating "shiftBaseX" to match the Enemy's position is
/// required if the Enemy is allowed to move while also performing this shifting effect.
/// @param {Real}	speed	Determines the frequency of the shifting (Speed of 1.0 = ~60 shifts per second).
apply_horizontal_shift = function(_speed){
	shiftTimer += DELTA_TIME;
	if (shiftTimer >= _speed){
		if (x == shiftBaseX) {x += choose(-1, 1);}
		else				 {x	 = shiftBaseX + sign(shiftBaseX - x);}
		shiftTimer -= _speed;
	}
}

/// @description 
/// @param {Real}	index	The type of drop to spawn into the world where the enemy died.
spawn_item_drop = function(_index){
	switch(_index){
		case ENMY_SMENERGY_DROP:
			instance_create_object(x, y, obj_sm_energy_drop, depth - 1);
			break;
		case ENMY_LGENERGY_DROP:
			instance_create_object(x, y, obj_lg_energy_drop, depth - 1);
			break;
		case ENMY_SMMISSILE_DROP:	// NOTE -- Spawns a small energy orb until Samus has access to Missiles. 
			if (event_get_flag(FLAG_MISSILES)) {instance_create_object(x, y, obj_missile_drop, depth - 1);}
			else {instance_create_object(x, y, obj_sm_energy_drop, depth - 1);}
			break;
		case ENMY_LGMISSILE_DROP:	// NOTE -- Spawns a small energy orb until Samus has access to Missiles.
			if (event_get_flag(FLAG_MISSILES)) {/* TODO -- Create large missile drop here. */}
			else {instance_create_object(x, y, obj_sm_energy_drop, depth - 1);}
			break;
		case ENMY_AEION_DROP:		// NOTE -- Spawns a large energy orb until Samus has access to an Aeion ability.
			if (PLAYER.maxAeion > 0) {instance_create_object(x, y, obj_aeion_drop, depth - 1);}
			else {instance_create_object(x, y, obj_lg_energy_drop, depth - 1);}
			break;
		case ENMY_POWBOMB_DROP:		// NOTE -- Spawns a large energy orb until Samus has access to Power Bombs.
			if (event_get_flag(FLAG_POWER_BOMBS)) {/* TODO -- Create power bomb drop here. */}
			else {instance_create_object(x, y, obj_lg_energy_drop, depth - 1);}								
			break;
	}
}

#endregion

#region Ailment function initializations

/// @description Attempts to inflict an Enemy with the "Freeze" ailment, which allows the Enemy to be used as
/// a platform by Samus to reach higher places or move across long chasms. An attempt to freeze the Enemy will
/// fail if they are immune to being frozen, are already frozen, or their current hitpoint value hasn't met
/// the required hp threshold for freezing.
/// @param {Real}	damage			The damage that the weapon will deal should the Enemy not be frozen instead.
/// @param {Bool}	isColdBased		Determines if the weapon used is "cold-based" and can freeze.
inflict_freeze = function(_damage, _isColdBased){
	// If this function is called while the Enemy is already frozen, the timer for the ailment will be reset
	// before the function is exited prematurely. Allows for freeze resets like most of the games in the series.
	if (_isColdBased && curAilment == AIL_FROZEN){
		if (ailmentTimer < FROZEN_DURATION * 0.25){
			ailmentTimer = FROZEN_DURATION;
			image_blend = HEX_LIGHT_BLUE;
			return true;
		}
		return false; // Doesn't do anything until a re-freeze can occur.
	}
	
	// Freezing an Enemy can't occur if the weapon isn't "cold-based", they are already frozen, immune to 
	// the status ailment, their HP is  greater than one, OR their current hitpoint ratio is higher than the 
	// required threshold percentage.
	var _hitpoints = hitpoints - _damage;
	if (!_isColdBased || !(weaknessFlags & ENMY_FREEZE_WEAK) || 
			(_hitpoints > 1 && _hitpoints / maxHitpoints > freezeThreshold)) 
		return false;
	
	if (curAilment != AIL_NONE) {remove_active_ailment();} // Remove previous ailment.
	
	// Apply the frozen state; setting the object up to be tinted blue while their current animation is 
	// completely frozen for the duration of the ailment.
	object_set_next_state(state_frozen);
	curState		= NO_STATE;		// Remove current state in case it hasn't processed for the current frame.
	prevAnimSpeed	= animSpeed;
	lastStateExt	= lastState;
	curAilment		= AIL_FROZEN;
	ailmentTimer	= FROZEN_DURATION;
	image_blend		= HEX_LIGHT_BLUE;
	animSpeed		= 0.0;
	
	// Create the "enemy collider" which is used to allow Samus to stand on the Enemy while they remain frozen.
	// The collision bounds are scaled from the 1x1 default to the size of the bounding box utilized by the Enemy.
	var _bboxRight	= bbox_right;
	var _bboxLeft	= bbox_left;
	var _bboxTop	= bbox_top;
	var _bboxBottom	= bbox_bottom;
	platformID = instance_create_object(_bboxRight, _bboxTop, obj_enemy_platform);
	with(platformID){
		image_xscale = _bboxLeft - _bboxRight;
		image_yscale = _bboxBottom - _bboxTop;
	}
	
	return true;
}

/// @description Removes the ailment that was affecting the Enemy. It will clean up any objects or effects that
/// were in-use temporarily. After the required clean up is done, the Enemy will be returned to whatever it was 
/// doing prior to the ailment's infliction.
remove_active_ailment = function(){
	switch(curAilment){
		case AIL_FROZEN:
			with(platformID) {instance_destroy(self);}
			stateFlags |= ENTT_DRAW_SELF;
			animSpeed	= prevAnimSpeed;
			image_blend	= c_white;
			break;
	}
	
	object_set_next_state(lastState);
	curAilment = AIL_NONE;
	ailmentTimer = 0.0;
}

#endregion

#region State function initialization

/// @description An enemy's default hitstun function, which will see them shaking at a predetermined intensity
/// around a starting position. The shaking will cease once the timer reaches its "resting" point of -1.0.
state_hitstun = function(){
	if (hitstunTimer == -1.0){ // Return to previous state; reposition to origin of shake range.
		object_set_next_state(lastState);
		x = stunX;
		y = stunY;
		return;
	}
	
	// Applying a new position based on the shake's origin coordinates and the strength of shaking being 
	// applied throughout the hitstun's duration.
	x = stunX + irandom_range(-stunStrength, stunStrength);
	y = stunY + irandom_range(-stunStrength, stunStrength);
}

/// @description 
state_stunned = function(){
	
}

/// @description 
state_shocked = function(){
	
}

/// @description The default state for whenever an Enemy is frozen. It doesn nothing aside from flickering
/// their sprite from a blue tint to no tint at all when the timer is below 25% of its starting value.
state_frozen = function(){
	if (ailmentTimer < FROZEN_DURATION * 0.25){
		if (image_blend != c_white)	{image_blend = c_white;}
		else						{image_blend = HEX_LIGHT_BLUE;}
	}
}

#endregion