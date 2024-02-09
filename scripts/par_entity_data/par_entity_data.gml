#region Macros used by both entity classes

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the "stateFlags" variable. These represent substates that can alter how an  //
//	entity functions without it having to be exclusive to a single function like their main state does.	   //
// ------------------------------------------------------------------------------------------------------- //

// --- Damage Taken Substate --- //
#macro	ENTT_HIT_STUNNED		0x00800000
// --- Animation/Rendering Substates --- //
#macro	ENTT_DRAW_SELF			0x01000000
#macro	ENTT_PAUSE_ANIM			0x02000000
#macro	ENTT_LOOP_ANIM			0x04000000
#macro	ENTT_ANIM_END			0x08000000
#macro	ENTT_ON_SCREEN			0x10000000
// --- Main Functionality Substates --- //
#macro	ENTT_ACTIVE				0x20000000
#macro	ENTT_INVINCIBLE			0x40000000
#macro	ENTT_DESTROYED			0x80000000

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check for these general Entity substates.					   //
// ------------------------------------------------------------------------------------------------------- //

// --- Damage Taken Substate Check --- //
#macro	ENTT_IS_HIT_STUNNED		(stateFlags & ENTT_HIT_STUNNED)
// --- Animation/Rendering Substate Checks --- //
#macro	ENTT_CAN_DRAW_SELF		(stateFlags & ENTT_DRAW_SELF)
#macro	ENTT_IS_ANIM_PAUSED		(stateFlags & ENTT_PAUSE_ANIM)
#macro	ENTT_CAN_LOOP_ANIM		(stateFlags & ENTT_LOOP_ANIM)
#macro	ENTT_ANIMATION_ENDED	(stateFlags & ENTT_ANIM_END)
#macro	ENTT_IS_ON_SCREEN		(stateFlags & ENTT_ON_SCREEN)
// --- Main Functionality Substate Checks --- //
#macro	ENTT_IS_ACTIVE			(stateFlags & ENTT_ACTIVE)
#macro	ENTT_IS_INVINCIBLE		(stateFlags & ENTT_INVINCIBLE)
#macro	ENTT_IS_DESTROYED		(stateFlags & ENTT_DESTROYED)

#endregion

#region Functions utilized by both entity classes

/// @description Removing all of the components from the entity object; preventing memory leaks from occurring 
/// if these weren't cleaned up during runtime. Over time, this would cause the game to crash.
function entity_cleanup(){
	if (audioComponent != noone){
		instance_destroy_struct(audioComponent);
		audioComponent = noone;
	}
	
	object_remove_light_component(true);
}

/// @description Updates the positions of any components that are active and attached to the entity calling
/// this function. It takes into account the offsets stored wihtin the entity themselves.
function entity_end_step(){
	if (lightComponent != noone){
		var _x, _y; // Store position as local variables, since Game Maker prefers these when jumping between objects.
		_x = x + lightOffsetX;
		_y = y + lightOffsetY;
		with(lightComponent) {set_position(_x, _y);}
	}

	if (audioComponent != noone){
		var _x, _y; // Store position as local variables, since Game Maker prefers these when jumping between objects.
		_x = x + audioOffsetX;
		_y = y + audioOffsetY;
		with(audioComponent) {audio_emitter_position(emitterID, _x, _y, 0);}
	}
}

/// @description Renders the entity to the screen using the proper animation system for said animations to not
/// be linked to whatever the current frame rate is. If there is no sprite to draw or the entity isn't set to
/// render their sprite to the screen, this function will have its logic skipped. The same applies to animation
/// logic if the sprite doesn't animate.
function entity_draw(){
	// Don't process any code within this event if there isn't a valid sprite to draw. The default value for a 
	// sprite before it is initialized by an object (Which is done using the "set_sprite" function that is 
	// found in the  "Create" event of this parent object) should be the constant NO_SPRITE.
	if (sprite_index == NO_SPRITE || !ENTT_IS_ACTIVE) {return;}

	// Animate the sprite as long as the game isn't paused AND the length of the sprite is greater than one 
	// image. Otherwise, the sprite will only render whatever image is found at the "imageIndex" number. After 
	// that number exceeds the length of the sprite's animation, it will automatically loop, set the "animation 
	// end" flag, and reset the value within "imageIndex".
	if (!ENTT_IS_ANIM_PAUSED && spriteLength > 1){
		imageIndex += spriteSpeed / ANIMATION_FPS * DELTA_TIME * animSpeed;
		if (imageIndex >= spriteLength && animSpeed > 0.0){
			if (ENTT_CAN_LOOP_ANIM){ // Flip "animation end" bit; reset animation when animation limit reached.
				stateFlags |= ENTT_ANIM_END;
				imageIndex -= spriteLength - loopOffset;
			} else{ // Animation cannot loop; lock it at the end of the sprite.
				imageIndex = spriteLength - 1;
			}
		} else if (imageIndex <= 0.0 && animSpeed < 0.0){
			if (ENTT_CAN_LOOP_ANIM){ // Animation is reversed; reset back to end, which is the start in this case.
				imageIndex += spriteLength - loopOffset;
			} else{ // Animation does not loop; set it to the zeroth indexed frame of the animation and freeze it.
				imageIndex = 0.0;
			}
		} else{ // Clear the "animation end" otherwise.
			stateFlags &= ~ENTT_ANIM_END;
		}
	}

	// After the new animation logic has been updated; draw the sprite to the screen using all the other 
	// default image/sprite manipulation variables that are built into every Game Maker object.
	if (!ENTT_CAN_DRAW_SELF || !ENTT_IS_ON_SCREEN) 
		return;
	draw_sprite_ext(sprite_index, imageIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

/// @description Moves the entity to the specified x and y coordinates within the current room. In case decimals
/// are provided in the argument space, the values are floored before they are set to the entity's position.
/// @param {Real}	x	Position along the x-axis to place the entity at.
/// @param {Real}	y	Position along the y-axis to place the entity at.
function entity_set_position(_x, _y){
	x = floor(_x);
	y = floor(_y);
}

/// @description Assigns a new sprite to be used by the entity in question. This function is best called every
/// frame as if it was replacing a "sprite_index = " call throughout any state code. Doing so will ensure that
/// the sprite it set AND that the animation speed of the sprite can be updated without any additional code
/// relating to the sprite within the entity's state(s) function.
/// @param {Asset.GMSprite}	sprite		The existing sprite resource to assign to the entity.
/// @param {Asset.GMSprite}	mask		Collision bounds for the entity (-1 means the newly assigned sprite's collision will be used).
/// @param {Real}			speed		Modifier to speed up or slow down an animation in real-time.
/// @param {Real}			start		Sttarting image to use when the sprite is first assigned.
/// @param {Real}			loopOffset	Animation frame to reset to whenever it loops.
function entity_set_sprite(_sprite, _mask, _speed = 1, _start = -1, _loopOffset = 0){
	if (sprite_index != _sprite && sprite_exists(_sprite)){
		sprite_index	= _sprite;
		mask_index		= _mask;
		loopOffset		= _loopOffset;
		spriteLength	= sprite_get_number(_sprite);
		spriteSpeed		= sprite_get_speed(_sprite);
		if (_start != -1) {imageIndex =	_start;}
	}
	animSpeed =	_speed; // The animation speed can always be updated by calling this function.
}

/// @description Performs a check to see if an entity is on-screen on not. If they are, they will have their
/// draw event(s) processed. Otherwise, the entity will be removed from the render pipeline until they are
/// considered "on-screen" once again.
/// @param {Real}	x		Position of the viewport along the x-axis.
/// @param {Real}	y		Position of the viewport along the y-axis.
/// @param {Real}	width	The size of the viewport (In pixels) along the x-axis.
/// @param {Real}	height	The size of the viewport (In pixels) along the y-axis.
function entity_is_on_screen(_x, _y, _width, _height){
	if (_x				> bbox_right	+ RENDER_CULL_PADDING	||
		_x + _width		< bbox_left		- RENDER_CULL_PADDING	||
		_y				> bbox_bottom	+ RENDER_CULL_PADDING	||
		_y + _height	< bbox_top		- RENDER_CULL_PADDING)
			{stateFlags &= ~ENTT_ON_SCREEN;}
	else	{stateFlags |=  ENTT_ON_SCREEN;}
}

#endregion