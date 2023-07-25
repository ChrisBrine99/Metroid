#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the proper sprite, and add a dim ambient light for the Mumbo's eyes; the light matching the eye color
// in the sprite itself. Finally, the Yumbo is set to be susceptible to every weapon Samus has access to.
entity_set_sprite(spr_mumbo, -1);
object_add_light_component(x, y, 0, -2, 10, HEX_LIGHT_GREEN, 0.65);
initialize_weak_to_all();

// The mumbo will move left to right; reversing its horizontal direction once it hits a wall. However, it will
// also slowly move towards Samus's direction along the vertical axis, so its max vertical velocity is set low.
maxHspd = 0.5;
maxVspd = 0.05;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Yumbo will be able to take
// four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints = 4;
hitpoints = maxHitpoints;

// Set the damage output and hitstun duration for the Yumbo. These values are increased/decreased by the
// difficulty level selected by the player.
damage = 8;
stunDuration = 8;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance = 0.45;	// 45%
aeionDropChance = 0.20;		// 20%
ammoDropChance = 0.30;		// 30%

#endregion

#region Unique variable initialization

// Determines the direction that the Mumbo is currently moving in; right or left. It is randomly set upon a
// Mumbo instance's creation so they don't all start in the same direction.
movement = choose(1, -1);

#endregion

#region State function initialization

/// @description 
state_default = function(){
	// Determine horizontal movement based on the direction the Yumbo is set to move in.
	hspd = maxHspd * movement;
	
	// Process vertical movement, which is completely determined by its y position relative to Samus's y 
	// position, but only when the Yumbo is considered "on screen".
	vspd = 0.0; // Vspd is always zeroed out before seeing if the Mumbo should move vertically or not.
	if (IS_ON_SCREEN){
		var _yy = y;
		with(PLAYER){ // Center target on middle of Samus whether she's in her morphball form or not.
			if (IN_MORPHBALL)	{_yy = sign(PLAYER.y - 8 - _yy);}
			else				{_yy = sign(PLAYER.y - 20 - _yy);}
		}
		vspd = maxVspd * _yy;
	}
	
	// Finally, process the movement for the frame using the standard entity world collision function. After
	// that, check for a horizontal collision relative to the Mumbo's movement direction so it can flip said
	// direction of movement.
	apply_frame_movement(entity_world_collision);
	if (place_meeting(x + movement, y, par_collider)) {movement *= -1;}
}

// Set the Mumbo to its default state upon creation.
object_set_next_state(state_default);

#endregion