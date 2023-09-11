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

// 
moveDirection	= 0;
targetX			= 0;
targetY			= 0;

// 
waitTimer		= 0.0;
flipTimer		= 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Senjoo, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description 
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_senjoo, -1);
	object_add_light_component(x, y, 0, -2, 14, HEX_LIGHT_RED, 0.5);
	create_general_collider();
	initialize_weak_to_all();
	spriteSpeed /= ANIMATION_FPS; // Divide by required value once since the Senjoo's sprite never changes.
	
	// Randomly choose a moving direction (Either clockwise or counter-clockwise depending on the chosen value)
	// and then always set the Senjoo to be at its lowest point in terms of movment/direction.
	moveDirection	= choose(MOVE_DIR_RIGHT, MOVE_DIR_LEFT);
	direction		= moveDirection == MOVE_DIR_RIGHT ? 135 : 45;
	
	// Also, have the Senjoo wait four times as long for its first movement relative to the rest.
	waitTimer		= SNJO_WAIT_INTERVAL * 4.0;
}

#endregion

#region State function initialization

/// @description 
state_default = function(){
	waitTimer -= DELTA_TIME;
	if (waitTimer < 0.0){
		object_set_next_state(state_move_to_target);
		waitTimer	= SNJO_WAIT_INTERVAL;
		damage		= SNJO_ATTACK_DAMAGE;
		
		// 
		direction  += 90 * moveDirection;
		targetX		= x - lengthdir_x(SNJO_ATK_MOVE_DISTANCE, direction);
		targetY		= y - lengthdir_y(SNJO_ATK_MOVE_DISTANCE, direction);
	}
}

/// @description
state_move_to_target = function(){
	// 
	hspd = (targetX - x) * 0.1;
	if (hspd > maxHspd)			{hspd =  maxHspd;}
	else if (hspd < -maxHspd)	{hspd = -maxHspd;}
	
	// 
	vspd = (targetY - y) * 0.1;
	if (vspd > maxVspd)			{vspd =  maxVspd;}
	else if (vspd < -maxVspd)	{vspd = -maxVspd;}
	
	// 
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