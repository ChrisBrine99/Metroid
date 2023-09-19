#region Macro initialization

// The damage dealt to Samus upon collision with the Senjoo while it is stationary and while it is moving to 
// its next target point, respectively.
#macro	SNJO_BASE_DAMAGE		16
#macro	SNJO_ATTACK_DAMAGE		48

// Determines how fast the Senjoo will move towards its next target position, as well as how long the length
// of the point between its previous and next target coordinates is.
#macro	SNJO_ATK_MOVE_SPEED		3.0
#macro	SNJO_ATK_MOVE_DISTANCE	48

// Determines how long the Senjoo will wait at its current target coordinates once reaching said point before 
// it will begin to move toward the next target point that is calculated.
#macro	SNJO_WAIT_INTERVAL		20.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set the maximum possible speed of the Senjoo to the value within the macro above. Both velocity values will
// use the same value so there is no speed difference along the x and y axis.
maxHspd = SNJO_ATK_MOVE_SPEED;
maxVspd = SNJO_ATK_MOVE_SPEED;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Senjoo will be able to 
// take sixteen hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 16;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Gullug. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= SNJO_BASE_DAMAGE;
stunDuration	= 15;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.3;	// 30%
aeionDropChance		= 0.2;	// 20%
ammoDropChance		= 0.2;	// 20%

#endregion

#region Unique variable initialization

// Variables that are important to how the Senjoo moves, where it moves to, and the direction it moves relative
// to its starting position. The target coordinates for the enemy's movement logic are stored in the last two
// variables.
moveDirection	= 0;
targetX			= 0;
targetY			= 0;

// Timers that are utilized by the Senjoo. The first is responsible for counting the amount of time that it has
// been waiting to move again after reaching its current target destination. The second timer is used to play
// its "animation" that just flips its x scaling factor between -1 and 1 to simulate some form of movement.
waitTimer		= 0.0;
flipTimer		= 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Senjoo, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialize the Senjo; setting its sprite; creating its general collider for Samus's weapons,
/// enable the Senjoo to be damaged by all beams/missiles/bombs/abilities, and initialize all other variables
/// required for the Senjoo at initialization.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_senjoo, -1);
	create_general_collider();
	
	// Set up weakness flags such that the Senjoo is weak to every type of weapon Samus can utilize.
	weaknessFlags  |= (
		// --- Beam Type Flags --- //
		ENMY_POWBEAM_WEAK | ENMY_ICEBEAM_WEAK | ENMY_WAVBEAM_WEAK | ENMY_PLSBEAM_WEAK | ENMY_CHRBEAM_WEAK |
		// --- Missile Flags --- //
		ENMY_REGMISSILE_WEAK | ENMY_SUPMISSILE_WEAK | ENMY_ICEMISSILE_WEAK | ENMY_SHKMISSILE_WEAK |
		// --- Bomb/Screw Attack Flags --- //
		ENMY_REGBOMB_WEAK | ENMY_POWBOMB_WEAK | ENMY_SCREWATK_WEAK |
		// --- Ailment Flags --- //
		ENMY_STUN_WEAK | ENMY_SHOCK_WEAK | ENMY_FREEZE_WEAK
	);
	
	// Divide by required value once since the Senjoo's sprite never changes.
	spriteSpeed /= ANIMATION_FPS;
	
	// Randomly choose a moving direction (Either clockwise or counter-clockwise depending on the chosen value)
	// and then always set the Senjoo to be at its lowest point in terms of movment/direction.
	moveDirection	= choose(MOVE_DIR_RIGHT, MOVE_DIR_LEFT);
	direction		= moveDirection == MOVE_DIR_RIGHT ? 135 : 45;
	
	// Prevent the Senjoo from instantly moving to a target upon creation by setting its wait timer to the
	// required interval during the initialization process.
	waitTimer		= SNJO_WAIT_INTERVAL;
}

#endregion

#region State function initialization

/// @description The Senjoo's default state, which is where it will remain stationary for a specific duration
/// of time before it alters its "direction" to determine the next coordinates in the room to move toward.
state_default = function(){
	waitTimer -= DELTA_TIME;
	if (waitTimer < 0.0){
		object_set_next_state(state_move_to_target);
		waitTimer	= SNJO_WAIT_INTERVAL;
		damage		= SNJO_ATTACK_DAMAGE;	// Increase damage while Senjoo is moving.
		
		// The value for direction is always one of the four cardinal directions offset by 45 degrees in order
		// to create the diamond-shaped movement path unique to the Senjoo. The value stored in "moveDirection"
		// will determine if the direction up is subtracted or added to the previous value. After that, the
		// target coordinates are updated with the proper coordinates.
		direction  += 90 * moveDirection;
		targetX		= x - lengthdir_x(SNJO_ATK_MOVE_DISTANCE, direction);
		targetY		= y - lengthdir_y(SNJO_ATK_MOVE_DISTANCE, direction);
	}
}

/// @description The Senjoo's movement state, which it will remain in until it reaches the target coordinate
/// that was calculated relative to the Senjoo's current direction value. It returns to the waiting/default
/// state upon reaching the target.
state_move_to_target = function(){
	// Handling horizontal movement, which is determined by the Senjoo's current distance from the x value
	// of the target coordinate. This value is limited by its maximum horizontal velocity.
	hspd = (targetX - x) * 0.1;
	if (hspd > maxHspd)			{hspd =  maxHspd;}
	else if (hspd < -maxHspd)	{hspd = -maxHspd;}
	
	// Vertical movement is handled in the exact same way as the horizontal movement, but using the y position
	// values instead of the x position values.
	vspd = (targetY - y) * 0.1;
	if (vspd > maxVspd)			{vspd =  maxVspd;}
	else if (vspd < -maxVspd)	{vspd = -maxVspd;}
	
	// Finally, take the hspd and vspd calculated above and move the Senjoo with those values. Then, check if 
	// the position of the Senjoo compared to the target coordinate is smaller than the Senjoo's maximum move
	// speed. If it is, the Senjoo will stop moving and wait to move again in a new direction.
	apply_frame_movement(NO_FUNCTION);
	if (point_distance(x, y, targetX, targetY) <= SNJO_ATK_MOVE_SPEED){
		object_set_next_state(state_default);
		damage			= SNJO_BASE_DAMAGE;
		hspdFraction	= 0.0;
		vspdFraction	= 0.0;
	}
}

#endregion

// Once the create event has executed, initialize the Senjoo by setting it to its default state function.
initialize(state_default);