#region Macro initialization

// The damage the Skree will inflict during its default and post-attacking states, as well as the damage it 
// will inflict during states not covered by the base daamge value.
#macro	SKRE_BASE_DAMAGE		4
#macro	SKRE_ATK_DAMAGE			10

// The maximum distance in pixels relative to the Skree's current x position that Samus must be in order to
// trigger its pre-attack state in order to attack her.
#macro	SKRE_TRIGGER_DISTANCE	20

// Macros for the Skree's animation speed for its attacking states, as well as the speed it will increase its
// animation speed by in order to reach that required speed during the pre-attack state.
#macro	SKRE_ATK_ANIM_SPEED		3.0
#macro	SKRE_ANIM_SPD_INCREASE	0.3

// Important time values for the Skree's various attack state waiting times in "frames" (60 of those being one 
// second of real-time), as well as the amount in "frames" that the Skree will shift back and forth horizontally
// whenever this effect is required in each state.
#macro	SKRE_ATK_BEGIN_TIME		10.0
#macro	SKRE_ATK_END_TIME		30.0
#macro	SKRE_POST_DEATH_TIME	8.0
#macro	SKRE_SHIFT_INTERVAL		2.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set the maximum horizontal speed and the Skree's maximum falling speed which are both utilized during the 
// Skree's main attacking state.
maxHspd = 1.5;
maxVspd = 6.0;

// Instead of having the maximum horizontal and vertical speeds set instantly for the Skree once it begins
// falling towards Samus, the Skree will slowly accelerate towards each value's maximum until those values 
// are reached; values they will remain at until the attack state ends.
hAccel = 0.3;
vAccel = 0.6;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Skree will be able to 
// take four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 4;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Skree. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= SKRE_BASE_DAMAGE;
stunDuration	= 8;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.45;	// 45%
aeionDropChance		= 0.3;	// 30%
ammoDropChance		= 0.25;	// 25%

#endregion

#region Unique variable initialization

// Determines what direction the Skree will move in horizontally (+1 for right, -1 for left) relative to its
// x position against Samus's x position at the point of starting the Skree's main attacking state.
moveDirection	= 0;

// Keeps track of the current interval of time that has passed since the Skree has been in its beginning and
// post attacking state, repsectively.
attackTimer		= 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Skree, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description 
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_skree, -1);
	object_add_light_component(x, y, 0, 8, 0, HEX_LIGHT_RED, 0.5);
	create_general_collider();
	initialize_weak_to_all();
}

#endregion

#region State function initialization

/// @description The Skree's default/dormant state. It is an incredibly simple state where the Skree will sit
/// on the ceiling animating at its normal rate. When Samus enters a specific horizontal region relative to the
/// Skree's current x position (And Samus's y is below the Skree's current vertical position), the Skree will
/// enter into its attacking state(s); starting with the attack's "begin" state.
state_default = function(){
	// Grab Samus's current position in order to see if she's currently within the region required by the Skree
	// for it to trigger its main attack.
	var _playerX = 0;
	var _playerY = 0;
	with(PLAYER){
		_playerX = x + (hspd * movement);
		_playerY = y;
	}
	
	// Perform the check between the Skree and Samus's current coordinates to see if she is within the attack
	// trigger region for the Skree. From this point until the Skree is in its final attack state will have 
	// its attack increased.
	if (_playerX > x - SKRE_TRIGGER_DISTANCE && _playerX < x + SKRE_TRIGGER_DISTANCE && _playerY > y + 32){
		object_set_next_state(state_begin_attack);
		damage		= SKRE_ATK_DAMAGE;
		shiftBaseX	= x;
	}
}

/// @description The first of three different states that the Skree can find itself in during its main attack.
/// This state will speed its animation up while also shaking the Skree back and forth for a short period of
/// time to help the player know the Skree is about to go for an attack.
state_begin_attack = function(){
	// First, increase the Skree's animation so it begins to spin rapidly before making its descent towards
	// the player. Until this value reaches its required threshold, the Skree's attack begin timer will not
	// be incremented.
	if (animSpeed != SKRE_ATK_ANIM_SPEED){
		animSpeed += SKRE_ANIM_SPD_INCREASE * DELTA_TIME;
		if (animSpeed > SKRE_ATK_ANIM_SPEED)
			animSpeed = SKRE_ATK_ANIM_SPEED;
		return;
	}
	
	// Wait until the attack timer exceeds the attack begin interval value; shaking the Skree back and forth
	// throughout this wait time. If the interval value is met, the Skree will begin its main attacking state 
	// where it quickly lunges downwards in Samus's direction.
	attackTimer += DELTA_TIME;
	if (attackTimer > SKRE_ATK_BEGIN_TIME){
		object_set_next_state(state_attack);
		x				= shiftBaseX;
		attackTimer		= 0.0;
		moveDirection	= (PLAYER.x > x) ? MOVE_DIR_RIGHT : MOVE_DIR_LEFT;
		damage			= SKRE_BASE_DAMAGE; // Return damage back to its default value.
		return;
	}
	apply_horizontal_shift(SKRE_SHIFT_INTERVAL);
}

/// @description The second and most important state for the Skree's attack. It's where the skree will actually
/// attempt to hit Samus by quickly moving downward and a slight horizontal velocity towards Samus relative to
/// what her position is compared to the Skree's at the beginning of its attack. This state only ends once the 
/// Skree collides with the ground.
state_attack = function(){
	// Stick DELTA_TIME into a local variable since it is used a few time throughout the state, which should
	// end up being very slightly faster than using this macro twice within any caching involved.
	var _deltaTime	= DELTA_TIME;
	
	// Update horizontal and vertical velocities for the current frame.
	hspd	+= hAccel * moveDirection * _deltaTime;
	if (hspd > maxHspd || hspd < -maxHspd) // Prevent horizontal velocity from exceeding its maximum
		hspd = maxHspd * moveDirection;
	vspd	+= vAccel * _deltaTime;
	if (vspd > maxVspd) // Also keep vertical velocity from exceeding its max
		vspd = maxVspd;
	
	// Finally, call the general entity movement/collision function to update the Skree's position for the frame.
	// After that process completes, a check if the Skree is no longer moving downward AND there is a collision
	// with a collider directly below it will be performed to try and move the skree onto its suicide state.
	apply_frame_movement(entity_world_collision, true);
	if (vspd == 0.0 && place_meeting(x, y + 1, par_collider)){
		object_set_next_state(state_kill_self);
		shiftBaseX = x; // Update shaking position to match x position after collision.
	}
}

/// @description The final state that the Skree will enter during its attack sequence. It will count up using
/// the "attackTimer" variable until its value exceeds the "attack end" threshold determined in an above macro.
/// After this, the Skree will destroy itself and spawn projectiles that spray out and upward.
state_kill_self = function(){
	// Track how long the Skree has been in this state for; kill self once required value has been exceeded.
	attackTimer += DELTA_TIME;
	if (attackTimer > SKRE_ATK_END_TIME){
		// 
		object_set_next_state(state_post_death);
		entity_set_sprite(spr_empty_mask, -1);
		stateFlags &= ~ENTT_DRAW_SELF;
		attackTimer = 0.0;
		visible		= false;
		
		// 
		var _direction	= 180;
		for (var i = 0; i < 6; i++){
			with(instance_create_object(x, y + 4, obj_skree_bullet)){
				hspd = lengthdir_x(maxHspd, _direction);
				vspd = lengthdir_y(maxVspd, _direction);
			}
			_direction -= 36;
		}
		
		// 
		with(lightComponent) {set_properties(80, HEX_LIGHT_PINK, 0.7);}
		lightOffsetY -= 8;
		return;
	}
	
	// Only allow the Skree to shake back and forth once it's considered near enough to being destroyed instead
	// of for the entirety of this final attacking state.
	if (attackTimer > SKRE_ATK_END_TIME * 0.6)
		apply_horizontal_shift(SKRE_SHIFT_INTERVAL);
}

/// @description 
state_post_death = function(){
	//
	var _deltaTime = DELTA_TIME;
	
	// 
	attackTimer += _deltaTime;
	if (attackTimer >= SKRE_POST_DEATH_TIME){
		stateFlags |= ENTT_DESTROYED;
		return;
	}
	
	// 
	var _atkTimer = sqrt(attackTimer);
	with(lightComponent){
		radius		= baseRadius + (_atkTimer * 8.0);
		strength   -= (0.7 / SKRE_POST_DEATH_TIME) * _deltaTime;
	}
}

#endregion

// Once the create event has executed, initialize the Skree by setting it to its default state function.
initialize(state_default);