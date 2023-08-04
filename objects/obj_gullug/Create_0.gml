#region Macro initialization

// Determines how wide the Gullug's circle of movement is in its default state, as well as the speed it moves
// along the circumference of that circle.
#macro	GLLG_MOVE_RADIUS		48.0
#macro	GLLG_MOVE_SPEED			2.0

// Determines the amount of damage that the Gullug will apply to Samus when it comes into contact with her
// during its regular and attacking states, respectively.
#macro	GLLG_BASE_DAMAGE		8
#macro	GLLG_ATTACK_DAMAGE		16

// Macro values for various attack state parameters. The first is the radius that Samus is required to be within
// relative to the Gullug's current position before it can attack her. The final two values are the speed the
// Gullug moves at when it is attacking and returning from attacking to its regular movement, respectively.
#macro	GLLG_ATK_DISTANCE		96.0
#macro	GLLG_ATK_SPEED			2.0
#macro	GLLG_ATK_RETURN_SPEED	1.0

// Various timer that the Gullug utilizes for various actions that it can perform. In order, they determine
// how long in unit frames (60 ufs = 1 second) before it can attack again, how long the Gullug can attack for
// before giving up, the time between it detecting Samus and beginning its attack, and how long it must wait
// between its attack and returning to its default state.
#macro	GLLG_ATK_COOLDOWN_TIME	60.0
#macro	GLLG_ATK_TIME			50.0
#macro	GLLG_ATK_BEGIN_TIME		20.0
#macro	GLLG_ATK_END_TIME		5.0

// Determines how fast the Gullug shifts to the left and right during its attack begin state.
#macro	GLLG_SHAKE_SPEED		2.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Gullug will be able to take
// eight hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 8;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Gullug. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= GLLG_BASE_DAMAGE;
stunDuration	= 12;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.35;	// 35%
aeionDropChance		= 0.3;	// 30%
ammoDropChance		= 0.3;	// 30%

#endregion

#region Unique variable initialization

// Stores the initial position of the Gullug, which will determine the center point of the cirle it will
// rotate around when in its default state.
startX			= 0;
startY			= 0;

// Stores the "direction" that the Gullug will move in; being able to choose from either left (-1) or right(+1).
moveDirection	= 0;

// Variables that are utilized by the Gullug for its attacking functionality. The first two store the position
// that the Gullug was at along its circle of movement before it began its attack, and the final value tracks
// intervals of time between various states to determine what the Gullug can do.
returnX			= 0;
returnY			= 0;
attackTimer		= 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Gullug, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Gullug. It sets its sprite, creates an ambient light for its
/// eyes, and sets it to be weak to all forms of weaponry. On top of that, its initial state is set while its 
/// starting movement direction is randomly determined between left (-1) and right (+1); the starting position
/// being determined as either the top (90) or bottom (270) of its movement circle.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_gullug, -1);
	object_add_light_component(x, y, 0, -5, 14, HEX_LIGHT_PURPLE, 0.5);
	create_general_collider();
	initialize_weak_to_all();
	
	// 
	startX			= x;
	startY			= y;
	moveSpeed		= 2.0;
	moveDirection	= choose(1, -1);
	attackTimer		= GLLG_ATK_COOLDOWN_TIME;	// Enables the Gullug to attack as soon as they area created.
	
	// Start the Gullug at either the top (90) or bottom (270) of its movement circle by said value being
	// randomly chosen upon the Gullu's initialization.
	direction		= choose(90, 270);
	y				= startY + lengthdir_y(GLLG_MOVE_RADIUS, direction);
}

#endregion

#region State function initialization

/// @description The Gullug's default/dormant state. While in this state, they will simply circle around a
/// point endlessly. If there is a line of sight between the Gullug and Samus, it will try charging at her.
/// Otherwise, it will remain in this state indefinitely.
state_default = function(){
	// Cache the current value for delta time since it is utilized multiple times throughout the state.
	var _deltaTime = DELTA_TIME;
	
	// 
	if (attackTimer == GLLG_ATK_COOLDOWN_TIME){
		// 
		var _playerX = 0xFFFFFFFF;
		var _playerY = 0xFFFFFFFF;
		with(PLAYER){
			_playerX = x;
			_playerY = y - 16; // Offset by 16 so it is properly centered on Samus.
		}
	
		// 
		if (distance_to_point(_playerX, _playerY) <= GLLG_ATK_DISTANCE){
			object_set_next_state(state_begin_attack);
			shiftBaseX	= x;
			attackTimer	= 0.0;
			
			// 
			var _direction = point_direction(x, y, _playerX, _playerY);
			hspd = lengthdir_x(GLLG_ATK_SPEED, _direction);
			vspd = lengthdir_y(GLLG_ATK_SPEED, _direction);
			return;
		}
	} else{ // Incrementing "attackTimer" until it hits the time required for attacking to be "out of cooldown".
		attackTimer += _deltaTime;
		if (attackTimer > GLLG_ATK_COOLDOWN_TIME)
			attackTimer = GLLG_ATK_COOLDOWN_TIME;
	}
	
	// 
	x = startX + floor(lengthdir_x(GLLG_MOVE_RADIUS, direction));
	y = startY + floor(lengthdir_y(GLLG_MOVE_RADIUS, direction));
	direction += moveDirection * moveSpeed * _deltaTime;
}

/// @description 
state_begin_attack = function(){
	// 
	attackTimer += DELTA_TIME;
	if (attackTimer > GLLG_ATK_BEGIN_TIME){
		object_set_next_state(state_attack);
		x			= shiftBaseX;
		returnX		= x;
		returnY		= y;
		damage		= GLLG_ATTACK_DAMAGE;
		attackTimer	= 0.0;
		return;
	}
	
	// 
	apply_horizontal_shift(GLLG_SHAKE_SPEED);
}

/// @description 
state_attack = function(){
	// 
	apply_frame_movement(NO_FUNCTION);
	attackTimer += DELTA_TIME;
	
	// 
	if (attackTimer > GLLG_ATK_TIME || place_meeting(x, y, PLAYER)){
		object_set_next_state(state_end_attack);
		damage		= GLLG_BASE_DAMAGE;
		attackTimer	= 0.0;
		
		// 
		var _direction = point_direction(x, y, returnX, returnY);
		hspd = lengthdir_x(GLLG_ATK_RETURN_SPEED, _direction);
		vspd = lengthdir_y(GLLG_ATK_RETURN_SPEED, _direction);
	}
}

/// @description 
state_end_attack = function(){
	// 
	var _deltaTime	= DELTA_TIME;
	attackTimer	   += _deltaTime;
	if (attackTimer < GLLG_ATK_END_TIME) {return;}
	
	// 
	apply_frame_movement(NO_FUNCTION);
	if (point_distance(x, y, returnX, returnY) 
			<= max(GLLG_ATK_RETURN_SPEED, GLLG_ATK_RETURN_SPEED * _deltaTime)){
		object_set_next_state(state_default);
		x			= returnX;
		y			= returnY;
		attackTimer = 0.0;
	}
}

#endregion

// Once the create event has executed, initialize the Gullug by setting it to its default state function.
initialize(state_default);