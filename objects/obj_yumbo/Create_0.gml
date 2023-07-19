#region Macros that are useful/related to obj_yumbo

// 
#macro	CHASE_COOLDOWN_INTERVAL	90.0
#macro	DETECTION_RADIUS		64
#macro	ESCAPE_RADIUS			96

// 
#macro	WANDER_SPEED			1.0
#macro	TARGET_POS_RADIUS		32

// 
#macro	TARGET_UPDATE_MIN_TIME	45.0
#macro	TARGET_UPDATE_MAX_TIME	150.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the proper sprite, and add a dim ambient light for the Gullug's eyes; the light matching the eye color
// in the sprite itself. Finally, the Yumbo is set to be susceptible to every weapon Samus has access to.
entity_set_sprite(spr_yumbo, -1);
object_add_light_component(x, y, -4, -2, 6, HEX_LIGHT_ORANGE, 0.5);
initialize_weak_to_all();

// 
maxHspd = 1.8;
maxVspd = 1.8;

// Since te Power Beam deals a single point of damage (On "Normal" difficulty), the Yumbo will be able to take
// four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints = 4;
hitpoints = maxHitpoints;

// Set the damage output and hitstun duration for the Yumbo. These values are increased/decreased by the
// difficulty level selected by the player.
damage = 8;
stunDuration = 10;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance = 0.5;		// 50%
aeionDropChance = 0.2;		// 20%
ammoDropChance = 0.2;		// 20%

#endregion

#region Unique variable initialization

// 
targetX = x;
targetY = y + 32;
targetUpdateTimer = random_range(TARGET_UPDATE_MIN_TIME, TARGET_UPDATE_MAX_TIME);

// 
centerX = x;
centerY = y + 64;

// 
chaseCooldownTimer = 0.0;

#endregion

#region State function initialization

/// @description 
state_default = function(){
	// 
	if (chaseCooldownTimer > 0.0){
		chaseCooldownTimer -= DELTA_TIME;
	} else if (chaseCooldownTimer <= 0.0 && distance_to_object(PLAYER) <= DETECTION_RADIUS 
			&& collision_line(x, y, PLAYER.x, PLAYER.y - 16, par_collider, false, true) == noone){
		object_set_next_state(state_chase_samus);
		return;
	}
	
	// 
	targetUpdateTimer -= DELTA_TIME;
	if (targetUpdateTimer <= 0.0){
		targetUpdateTimer = random_range(TARGET_UPDATE_MIN_TIME, TARGET_UPDATE_MAX_TIME);
		do{ // 
			targetX = centerX + irandom_range(-TARGET_POS_RADIUS, TARGET_POS_RADIUS);
			targetY = centerY + irandom_range(-TARGET_POS_RADIUS, TARGET_POS_RADIUS);
		} until(!collision_line(x, y, targetX, targetY, par_collider, false, true));
		image_xscale = (x > targetX) ? -1 : 1;
		lightOffsetX = -4 * image_xscale;
		return;
	}
	
	// 
	if (x == targetX && y == targetY) {return;}
	
	// 
	direction = point_direction(x, y, targetX, targetY);
	hspd = lengthdir_x(WANDER_SPEED, direction);
	vspd = lengthdir_y(WANDER_SPEED, direction);
	apply_frame_movement(NO_FUNCTION);
}

/// @description The Yumbo's "attacking" state. It will target Samus's current position (Offset by 16 pixels
/// above her actual position so it's more inline with the center of her sprite) until it damages her OR Samus
/// manages to go outside of the Yumbo's "territory". Regardless of the condition that is met, the Yumbo will
/// return to its default state and have a 1.5 second cooldown applied before it can chase Samus once again.
state_chase_samus = function(){
	// The Yumbo has gone outside of its "hunting" region OR it has collided with and damaged Samus. Resets
	// itself back to its default state; moving back to the center of its "territory" region.
	if (distance_to_point(centerX, centerY) >= ESCAPE_RADIUS || place_meeting(x, y, PLAYER)){
		object_set_next_state(state_default);
		targetUpdateTimer	= random_range(TARGET_UPDATE_MIN_TIME, TARGET_UPDATE_MAX_TIME);
		chaseCooldownTimer	= CHASE_COOLDOWN_INTERVAL;
		image_xscale = (x > targetX) ? -1 : 1;
		lightOffsetX = -4 * image_xscale;
		
		// Move the Yumbo back to the center of its "territory", but with a random offset within an eight-pixel 
		// radius from that center applied so it doesn't always return to the same place after ending a chase.
		targetX = centerX + irandom_range(-8, 8);
		targetY = centerY + irandom_range(-8, 8);
		
		return; // State was changed; exit current state early.
	}
	
	// Move the Yumbo towards the player at its maximum possible movement speed. Its hspd and vspd will be
	// determined by the angle between its position and Samus's multiplied by its maximum hspd and vspd values.
	var _playerX = PLAYER.x;
	var _playerY = PLAYER.y - 16;
	direction = point_direction(x, y, _playerX, _playerY);
	hspd = lengthdir_x(maxHspd, direction);
	vspd = lengthdir_y(maxVspd, direction);
	apply_frame_movement(NO_FUNCTION); // No world collision function is needed for the Yumbo.
	
	// Ensure the Yumbo is always facing Samus; its eye light being properly offset for said facing direction.
	image_xscale = (x < _playerX) ? 1 : -1;
	lightOffsetX = -4 * image_xscale;
}

// Set the Yumbo to its default state upon creation.
object_set_next_state(state_default);

#endregion