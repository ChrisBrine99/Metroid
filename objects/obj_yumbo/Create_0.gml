#region Macros that are useful/related to obj_yumbo

// Stores the values for the Yumbo's damage output when it is in its default and attack states, respectively.
#macro	YMBO_BASE_DAMAGE		8
#macro	YMBO_ATTACK_DAMAGE		16

// Macro values for the radii that the Yumbo uses in order to determine how far Samus needs to be from it before
// it attempts to charge at her, as well as how far Samus needs to be from the Yumbo's "territory" before it
// ends the chase.
#macro	YMBO_DETECTION_RADIUS	64.0
#macro	YMBO_ESCAPE_RADIUS		96.0

// Determines characteristics of the Yumbo's dormant state; how fast it can move along either axes, and the
// distance from the center of its "territory" that it is allowed to wander around.
#macro	YMBO_WANDER_SPEED		1.0
#macro	YMBO_TARGET_RADIUS		32
#macro	YMBO_RETURN_RADIUS		8

// Various timers that the Yumbo utilizes to perform actions. In order, they determine the time required to
// pass before it can attack again, how long it takes to begin its attack state, how long it needs to go from
// its attack to default state after finishing said attack, and the range of time for its target update time
// whenever those coordinates are updating in its default state.
#macro	YMBO_ATK_COOLDOWN_TIME	90.0
#macro	YMBO_ATK_BEGIN_TIME		20.0
#macro	YMBO_ATK_END_TIME		12.0
#macro	YMBO_TUPDATE_MIN_TIME	45.0
#macro	YMBO_TUPDATE_MAX_TIME	150.0

// Determines how fast the Yumbo shifts to the left and right during its attack begin state.
#macro	YMBO_SHAKE_SPEED		2.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set maximum velocity for the Yumbo, which is slightly slower than Samus herself. These values will be used
// to determine the Yumbo's actual speed relative to the direction found between it and Samus's position while
// it is chasing her.
maxHspd = 1.8;
maxVspd = 1.8;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Yumbo will be able to take
// four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 4;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Yumbo. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= YMBO_BASE_DAMAGE;
stunDuration	= 12;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.5;	// 50%
aeionDropChance		= 0.2;	// 20%
ammoDropChance		= 0.2;	// 20%

#endregion

#region Unique variable initialization

// Variables that are relevant to the Yumbo's functionality during its "dormant" state. The first two variables
// determine the x and y positions that the Yumbo will "target" and move towards, respectively. The final value
// determines how much time will remain before the target coordinate is updating to new values.
targetX				= 0;
targetY				= 0;
targetUpdateTimer	= 0.0;

// Determines the "center" of the Yumbo's territory. This value is then used to determine if Samus is close
// enough to the Yumbo for it to begin aggressively chasing her.
centerX = 0;
centerY = 0;

// A value that will decrement itself until it hits zero whenever a value is applied to it. When greater than
// zero, the Yumbo will not engage in chasing Samus even if she's within its territory.
attackTimer = 0.0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Yumbo, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Yumbo. It sets its sprite, and sets it to be weak to all 
/// forms of weaponry. On top of that, its initial state is set and its starting facing direction is randomly
/// chosen to be either to the left (-1) or right (1). Its unique variables and properties are also determined
/// by a call to this function.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_yumbo, -1);
	//object_add_light_component(x, y, -4, -2, 6, HEX_LIGHT_ORANGE, 0.5);
	create_general_collider();
	initialize_weak_to_all();
	
	// By default, the center of the Yumbo's "territory" will be the coordinates it is found at during the
	// call to this initialization function. The target position it stores will also be the same. However,
	// those values are adjusted if the Yumbo was created by a Yumbo Nest spawner.
	centerX = x;
	centerY = y;
	targetX = x;
	targetY = y;
	
	alarm[0] = 1;	// Fix for offseting Yumbo's "center" point if it came from a spawner.
	
	// Initial timer before the Yumbo will update its dormant positional target will be randomly set to be a
	// value between the minimum possible time (45.0 units) and maximum (150.0 units), respectively (60 units
	// = 1 second).
	targetUpdateTimer = random_range(YMBO_TUPDATE_MIN_TIME, YMBO_TUPDATE_MAX_TIME);
	
	// Randomly determine what direction the Yumbo will spawn in facing; left (-1) or right (+1).
	image_xscale = choose(-1, 1);
	lightOffsetX = -4 * image_xscale;	// Fix light offset to match facing direction.
}

#endregion

#region State function initialization

/// @description The Yumbo's default state, where it will randomly choose a point within an area that has its
/// range determined by the values of "centerX" and "centerY", respectively. Once it reaches said point OR the
/// target update timer reaches zero prior to the target coordinates being reached, the Yumbo will choose a
/// new target position. They will wait at the target position until the "target update" timer reaches 0.0
/// should they reach the target before the timer completely counts down.
state_default = function(){
	// Prevent the Yumbo from instantly attacking Samus whenever she's within range of them by applying a 
	// value to the "attackTimer" variable. If that timer is at or below 0.0, the Yumbo will begin chasing
	// Samus if she's within range and there aren't any colliders between the two.
	if (attackTimer == YMBO_ATK_COOLDOWN_TIME && distance_to_object(PLAYER) <= YMBO_DETECTION_RADIUS 
			&& collision_line(x, y, PLAYER.x, PLAYER.y - 16, par_collider, false, true) == noone){
		object_set_next_state(state_begin_attack);
		shiftBaseX	= x;
		attackTimer = 0.0;
		return;
	} else{ // Increment timer until it surpasses required value.
		attackTimer += DELTA_TIME;
		if (attackTimer > YMBO_ATK_COOLDOWN_TIME)
			attackTimer = YMBO_ATK_COOLDOWN_TIME;
	}
	
	// The "target update" time will be decremented at a rate of ~60 units per second regardless of if the 
	// Yumbo is resting at its target coordinates or still moving towards it. This timer will be reset to a 
	// value within a range of 45.0 and 150.0 units, resepctively.
	targetUpdateTimer -= DELTA_TIME;
	if (targetUpdateTimer <= 0.0){
		targetUpdateTimer	= random_range(YMBO_TUPDATE_MIN_TIME, YMBO_TUPDATE_MAX_TIME);
		targetX				= centerX + irandom_range(-YMBO_TARGET_RADIUS, YMBO_TARGET_RADIUS);
		targetY				= centerY + irandom_range(-YMBO_TARGET_RADIUS, YMBO_TARGET_RADIUS);
		image_xscale		= (x > targetX) ? -1 : 1;
		lightOffsetX		= -4 * image_xscale;
		return;
	}
	
	// Don't bother trying to move the Yumbo if it's already at its target position.
	if (x == targetX && y == targetY) {return;}
	
	// Move the Yumbo along both axes in the direction that the target coordinates are from its current position.
	// After that, the general entity movement function is called but no world collision function will be checked.
	direction	= point_direction(x, y, targetX, targetY);
	hspd		= lengthdir_x(YMBO_WANDER_SPEED, direction);
	vspd		= lengthdir_y(YMBO_WANDER_SPEED, direction);
	apply_frame_movement(NO_FUNCTION);
}

/// @description Yumbo's beginning state for its attack. It applies a horizontal shift back and forth by one 
/// pixel at a set interval; signifying to the player that it is about to perform an attack.
state_begin_attack = function(){
	// Increment the "attackTimer" variable until it surpasses the required value for the attack to start. At
	// that point, the Yumbo will shift into its main attack state; increasing its attack for that state.
	attackTimer += DELTA_TIME;
	if (attackTimer > YMBO_ATK_BEGIN_TIME){
		object_set_next_state(state_attack);
		x			= shiftBaseX;
		damage		= YMBO_ATTACK_DAMAGE;
		attackTimer = 0.0;
		return;
	}
	
	// Call the function to apply the Enemy-wide horizontal shifting effect, which signifies an attack starting.
	apply_horizontal_shift(YMBO_SHAKE_SPEED);
}

/// @description The Yumbo's attacking state. It will target Samus's current position (Offset by 16 pixels
/// above her actual position so it's more inline with the center of her sprite) until it damages her OR Samus
/// manages to go outside of the Yumbo's "territory". Regardless of the condition that is met, the Yumbo will
/// return to its default state and have a 1.5 second cooldown applied before it can chase Samus once again.
state_attack = function(){
	// The Yumbo has gone outside of its "hunting" region OR it has collided with and damaged Samus. Resets
	// itself back to its default state; moving back to the center of its "territory" region.
	if (distance_to_point(centerX, centerY) > YMBO_ESCAPE_RADIUS || place_meeting(x, y, PLAYER)){
		object_set_next_state(state_end_attack);
		damage = YMBO_BASE_DAMAGE;
		return; // State was changed; exit current state early.
	}
	
	// Move the Yumbo towards the player at its maximum possible movement speed. Its hspd and vspd will be
	// determined by the angle between its position and Samus's multiplied by its maximum hspd and vspd values.
	var _playerX	= PLAYER.x;
	var _playerY	= PLAYER.y - 16;
	direction		= point_direction(x, y, _playerX, _playerY);
	hspd			= lengthdir_x(maxHspd, direction);
	vspd			= lengthdir_y(maxVspd, direction);
	apply_frame_movement(NO_FUNCTION); // No world collision function is needed for the Yumbo.
	
	// Ensure the Yumbo is always facing Samus; its eye light being properly offset for said facing direction.
	image_xscale = (x < _playerX) ? 1 : -1;
	lightOffsetX = -4 * image_xscale;
}

/// @description The Yumbo's attack end state, which is an even more barebones version of its attack begin
/// state. All it does is increment the "attackTimer" variable for a set amount of time; freezing the Yumbo
/// in place once its attack has been completed.
state_end_attack = function(){
	// Once the "attackTimer" variable has reached the required value, the Yumbo will be reset to its default
	// state; randomly determining a target update time between its minimum (45.0) and maximum (150.0) values.
	attackTimer += DELTA_TIME;
	if (attackTimer > YMBO_ATK_END_TIME){
		object_set_next_state(state_default);
		targetUpdateTimer	= random_range(YMBO_TUPDATE_MIN_TIME, YMBO_TUPDATE_MAX_TIME)
		attackTimer			= 0.0; // Clear timer for the attack cooldown to utilize it.
		
		// Determine a target position that is close (Radius is 8.0 units) to its center point that was determined
		// during initialization of the Yumbo. After that, the Yumbo is set to face the target coordinates.
		targetX			= centerX + irandom_range(-YMBO_RETURN_RADIUS, YMBO_RETURN_RADIUS);
		targetY			= centerY + irandom_range(-YMBO_RETURN_RADIUS, YMBO_RETURN_RADIUS);
		image_xscale	= (x > targetX) ? -1 : 1;
		lightOffsetX	= -4 * image_xscale;
	}
}

#endregion

// Once the create event has executed, initialize the Yumbo by setting it to its default state function.
initialize(state_default);