#region Macros that are useful/related to par_enemy and its children

// Macros for each of the bits in the variable "stateFlags". These bits will all determine how the enemy functions
// and interacts with the world depending on which are set (1) and which are not (0).
#macro	AILMENT_ACTIVE			14
#macro	STUN_IMMUNITY			15
#macro	SHOCK_IMMUNITY			16
#macro	FREEZE_IMMUNITY			17
#macro	POWER_BOMB_IMMUNITY		18
#macro	SCREW_ATTACK_IMMUNITY	19
#macro	DROP_ITEM				20

// Simplified checks for an enemy's state flags, which determine what they can and can't do relative to the bits that
// are set and those that aren't.
#macro	AILMENT_INFLICTED		(stateFlags & (1 << AILMENT_ACTIVE))
#macro	IMMUNE_TO_STUN			(stateFlags & (1 << STUN_IMMUNITY))
#macro	IMMUNE_TO_FREEZE		(stateFlags & (1 << FREEZE_IMMUNITY))
#macro	IMMUNE_TO_SHOCK			(stateFlags & (1 << SHOCK_IMMUNITY))
#macro	IS_IMMUNE_TO_PBOMB		(stateFlags & (1 << POWER_BOMB_IMMUNITY))
#macro	IS_IMMUNE_TO_SATTACK	(stateFlags & (1 << SCREW_ATTACK_IMMUNITY))
#macro	CAN_DROP_ITEM			(stateFlags & (1 << DROP_ITEM))

// Macros for the ailments based on their priority; where the higher number will overwrite the previous one
// should it be inflicted while the enemy is already affected by some lower priority ailment.
#macro	AIL_NONE				0
#macro	AIL_STUNNED				1
#macro	AIL_SHOCKED				2
#macro	AIL_FROZEN				3

// Macros that determine the duration of each ailment in "unit frames"; where 60 of those frames equal one
// real-world second.
#macro	STUN_DURATION			30
#macro	SHOCK_DURATION			60
#macro	FROZEN_DURATION			600

// Determines the chance of missile ammo being dropped by the enemy when it drops ammo upon death. The remaining amount
// out of one is the chance of a power bomb charge dropping instead.
#macro	MISSILE_DROP_CHANCE		0.75

// Determines the base percentage chance that a small energy orb will be dropped instead of a large energy orb. This 
// chance is altered depending on the percentage of energy Samus has remaining relative to her current maximum. The
// remainder of 1.0 minus this value is the chance of dropping a large energy orb.
#macro	SM_ENERGY_DROP_CHANCE	0.85

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

// 
colliderIDs		= ds_list_create();

// Stores the damage prior to any damage reduction due to difficulty settings or Samus's current suit upgrades.
// The stun duration determines how long in "unit frames" (60 = 1 real-world second), to prevent any input from
// the player after Samus takes damage.
damage			= 0;
stunDuration	= 0.0;

// Stores the percentage drop chances (Ranging from 0.0 to 1.0 == 0% to 100% chance) for energy (small and large), aeion, 
// and ammunition (missiles and power bombs), respectively. The enemy will check in the order: energy, aeion, and ammo, 
// upon defeat, so if the previous value(s) equal or surpass 1.0; the remaining checks will be ignored. Another thing to 
// note is that the aeion and ammo drops are converted into a 80/20 chance at spawning an small/large energy orb if Samus 
// doesn't have access to her missile launcher/power bomb and aeion powers, respectively.
energyDropChance	= 0.0;
aeionDropChance		= 0.0;
ammoDropChance		= 0.0;

// Keeps track of the weaponry Samus can utilize that the Enemy can be damaged by. Anything not found on this
// list will simply be ignored if it happens to collide with the Enemy.
weaknesses		= ds_list_create();

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

// 
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
	stateFlags	   |= (1 << DRAW_SPRITE) | (1 << LOOP_ANIMATION);
	recoveryLength	= 1.0;
	visible			= true;
}

#endregion

#region Hitpoint and hitstun function initializations

/// Stores the pointer to the parent "update_hitpoints" function to allow the inherited version of the function
/// to call the logic from the base function despite overriding it to add more functionality.
__update_hitpoints = update_hitpoints;
/// @description A simple modification of the standard Entity "update_hitpoints" function that flips the flag
/// "DROP_ITEM" to true, which actually allows the enemy to drop an item upon death from taking too much damage.
update_hitpoints = function(_modifier){
	__update_hitpoints(_modifier);
	if (hitpoints == 0) {stateFlags |= (1 << DROP_ITEM);}
}

/// Stores the parent object's function for applying a hitstun effect onto an entity so it can be called in
/// this function definition that would overwrite the reference to the original otherwise.
__entity_apply_hitstun = entity_apply_hitstun;
/// @description A hitstun function unique to enemy entities. It will send them into their hitstun state while
/// also applying a shake effect--its intensity varying depending on the damage it sustained--during the hitstun.
/// @param {Real}	duration
/// @param {Real}	damage
entity_apply_hitstun = function(_duration, _damage){
	if (curAilment != AIL_NONE){
		update_hitpoints(-_damage);
		return; // Don't allow standard hitstun effect whenever an enemy has an ailment active.
	}
	__entity_apply_hitstun(_duration, _damage);
	object_set_next_state(state_hitstun);
	stunStrength = min(floor(1 + _damage * 0.25), 4);
	stunX = x;
	stunY = y;
}

#endregion

#region Utility function initialization

/// @description General function to call in the Create event of the Enemy object to make it weak to every
/// projectile and bomb-based weapon. This is the default for many weaker enemies found throughout the world.
initialize_weak_to_all = function(){
	if (!ds_list_empty(weaknesses)) {ds_list_clear(weaknesses);}
	// Ensure the enemy can be stunned, frozen, or shocked since they are considered weak to everything.
	stateFlags &= ~((1 << STUN_IMMUNITY) | (1 << FREEZE_IMMUNITY) | (1 << SHOCK_IMMUNITY));
	
	ds_list_add(weaknesses, 
		(1 << TYPE_POWER_BEAM), 
		(1 << TYPE_ICE_BEAM),
		(1 << TYPE_WAVE_BEAM),
		(1 << TYPE_PLASMA_BEAM),
		(1 << TYPE_MISSILE),
		(1 << TYPE_SUPER_MISSILE),
		(1 << TYPE_ICE_MISSILE),
		(1 << TYPE_SHOCK_MISSILE),
		(1 << TYPE_BOMB)
	);
	// Power bomb and screw attack aren't found here since they will always damage enemies unless two seperate 
	// immunity flags are toggled to prevent damage from each.
}

/// @description General function to call in the Create event of the Enemy object to make it weak to beam
/// projectiles and ONLY them. This means that being hit by any missile or a bomb will deal no damage.
initialize_weak_to_beams = function(){
	if (!ds_list_empty(weaknesses)) {ds_list_clear(weaknesses);}
	
	ds_list_add(weaknesses,
		(1 << TYPE_POWER_BEAM),
		(1 << TYPE_ICE_BEAM),
		(1 << TYPE_WAVE_BEAM),
		(1 << TYPE_PLASMA_BEAM),
		// Note -- Enemy is still weak to Power Bombs.
	);
}

/// @description General function to call in the Create event of the Enemy object to make it weak to missile
/// projectiles and ONLY them. This means that being hit by any beam or a bomb will deal no damage.
initialize_weak_to_missiles = function(){
	if (!ds_list_empty(weaknesses)) {ds_list_clear(weaknesses);}
	stateFlags &= ~(1 << STUN_IMMUNITY); // Ensure the enemy can be inflicted with stun.
	
	ds_list_add(weaknesses,
		(1 << TYPE_MISSILE),
		(1 << TYPE_SUPER_MISSILE),
		(1 << TYPE_ICE_MISSILE),
		(1 << TYPE_SHOCK_MISSILE),
		// Note -- Enemy is still weak to Power Bombs.
	);
}

/// @description General function to call in the Create event of the Enemy object to make it weak to ice-based
/// projectiles and ONLY them. This means any other beam/missile/bomb (Excluding the Power Bomb) will deal no
/// damage to the Enemy in question.
/// @param {Real}	freezeThreshold		Determines percentage of HP the enemy needs to be at or below in order to be frozen.
initialize_weak_to_ice = function(_freezeThreshold = 0.25){
	freezeThreshold = _freezeThreshold;
	
	if (!ds_list_empty(weaknesses)) {ds_list_clear(weaknesses);}
	stateFlags &= ~(1 << FREEZE_IMMUNITY); // Ensure the enemy can be inflicted with freeze.
	
	ds_list_add(weaknesses,
		(1 << TYPE_ICE_BEAM),
		(1 << TYPE_ICE_MISSILE)
		// Note -- Enemy is still weak to Power Bombs.
	);
}

/// @description General function to call in the Create event of the Enemy object to make it weak to shock-based
/// projectiles and ONLY them. This means any other beam/missile/bomb (Excluding the Power Bomb) will deal no
/// damage to the Enemy in question.
initialize_weak_to_shock = function(){
	if (!ds_list_empty(weaknesses)) {ds_list_clear(weaknesses);}
	stateFlags &= ~(1 << SHOCK_IMMUNITY); // Ensure the enemy can be inflicted with shock.
	
	ds_list_add(weaknesses,
		(1 << TYPE_WAVE_BEAM),
		(1 << TYPE_SHOCK_MISSILE)
		// Note -- Enemy is still weak to Power Bombs.
	);
}

/// @description Detrermines if the weapon used against the Enemy should affect them or not. It does this by
/// checking the list of weaknesses the enemy has, and if a match is found through a bitwise AND of a given 
/// "weakness" value the function will return true to signify the Enemy is weak to said weapon.
/// @param {Real}	stateFlags		Copy of the weapon's stateFlags variable in order to determine its type against the Enemy's weaknesses.
is_weak_to_weapon = function(_stateFlags){
	var _length = ds_list_size(weaknesses);
	for(var i = 0; i < _length; i++){
		if (_stateFlags & weaknesses[| i]) {return true;}
	}
	return false;
}

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
	if (!_isColdBased || IMMUNE_TO_FREEZE || (_hitpoints > 1 && _hitpoints / maxHitpoints > freezeThreshold)) {return false;}
	
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
			stateFlags |= (1 << DRAW_SPRITE);
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
		stateFlags |= (1 << DRAW_SPRITE);
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
		if (image_blend == HEX_LIGHT_BLUE)	{image_blend = c_white;}
		else								{image_blend = HEX_LIGHT_BLUE;}
	}
}

#endregion