#region Macros used by both entity classes

// Positions for the bit flags that allow or restrict specific functionalities of the entity, whether they be
// a dynamic or static one. These four highest positioned bits are shared by both entity types; any others will
// be unique to one type or the other.
#macro	HIT_STUNNED				23
#macro	DRAW_SPRITE				24
#macro	FREEZE_ANIMATION		25
#macro	LOOP_ANIMATION			26
#macro	ANIMATION_END			27
#macro	ON_SCREEN				28
#macro	ACTIVE					29
#macro	INVINCIBLE				30
#macro	DESTROYED				31

// Condenses the code required to check any of the four shared bit flags' current states into macro values.
#macro	IS_HIT_STUNNED			(stateFlags & (1 << HIT_STUNNED) != 0)
#macro	CAN_DRAW_SPRITE			(stateFlags & (1 << DRAW_SPRITE) != 0)
#macro	IS_ANIMATION_FROZEN		(stateFlags & (1 << FREEZE_ANIMATION) != 0)
#macro	CAN_LOOP_ANIMATION		(stateFlags & (1 << LOOP_ANIMATION) != 0)
#macro	DID_ANIMATION_END		(stateFlags & (1 << ANIMATION_END) != 0)
#macro	IS_ON_SCREEN			(stateFlags & (1 << ON_SCREEN) != 0)
#macro	IS_ACTIVE				(stateFlags & (1 << ACTIVE) != 0)
#macro	IS_INVINCIBLE			(stateFlags & (1 << INVINCIBLE) != 0)
#macro	IS_DESTROYED			(stateFlags & (1 << DESTROYED) != 0)

// Useful marcos for the angle values of the four cardinal directions.
#macro	DIRECTION_NORTH			90.0
#macro	DIRECTION_SOUTH			270.0
#macro	DIRECTION_EAST			0.0
#macro	DIRECTION_WEST			180.0

// Some more useful macros for determining the current "movement direction" of a given entity (Enemy AI like
// the "Ripper", "Halzyn", and "Mumbo" utilize these values.
#macro	MOVE_DIR_RIGHT			1
#macro	MOVE_DIR_LEFT			-1

#endregion

#region Functions utilized by both entity classes

/// @description Removing all of the components from the entity object; preventing memory leaks from occurring 
/// if these weren't cleaned up during runtime. Over time, this would cause the game to crash.
function entity_cleanup(){
	//object_remove_audio_component();
	//object_remove_interact_component();
	object_remove_light_component();
}

/// @description Renders the entity to the screen using the proper animation system for said animations to not
/// be linked to whatever the current frame rate is. If there is no sprite to draw or the entity isn't set to
/// render their sprite to the screen, this function will have its logic skipped. The same applies to animation
/// logic if the sprite doesn't animate.
function entity_draw(){
	// Don't process any code within this event if there isn't a valid sprite to draw. The default value for a 
	// sprite before it is initialized by an object (Which is done using the "set_sprite" function that is 
	// found in the  "Create" event of this parent object) should be the constant NO_SPRITE.
	if (sprite_index == NO_SPRITE || !IS_ACTIVE) {return;}

	// Animate the sprite as long as the game isn't paused AND the length of the sprite is greater than one 
	// image. Otherwise, the sprite will only render whatever image is found at the "imageIndex" number. After 
	// that number exceeds the length of the sprite's animation, it will automatically loop, set the "animation 
	// end" flag, and reset the value within "imageIndex".
	if (!IS_ANIMATION_FROZEN && spriteLength > 1){
		imageIndex += spriteSpeed / ANIMATION_FPS * DELTA_TIME * animSpeed;
		if (imageIndex >= spriteLength && animSpeed > 0.0){
			if (CAN_LOOP_ANIMATION){ // Flip "animation end" bit; reset animation when animation limit reached.
				stateFlags |= (1 << ANIMATION_END);
				imageIndex -= spriteLength - loopOffset;
			} else{ // Animation cannot loop; lock it at the end of the sprite.
				imageIndex = spriteLength - 1;
			}
		} else if (imageIndex <= 0 && animSpeed < 0.0){
			if (CAN_LOOP_ANIMATION){ // Animation is reversed; reset back to end, which is the start in this case.
				imageIndex += spriteLength - loopOffset;
			} else{ // Animation does not loop; set it to the zeroth indexed frame of the animation and freeze it.
				imageIndex = 0;
			}
		} else{ // Clear the "animation end" otherwise.
			stateFlags &= ~(1 << ANIMATION_END);
		}
	}

	// After the new animation logic has been updated; draw the sprite to the screen using all the other 
	// default image/sprite manipulation variables that are built into every Game Maker object.
	if (!CAN_DRAW_SPRITE || !IS_ON_SCREEN) {return;}
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
	if (_x				> bbox_right	+ CULL_PADDING	||
		_x + _width		< bbox_left		- CULL_PADDING	||
		_y				> bbox_bottom	+ CULL_PADDING	||
		_y + _height	< bbox_top		- CULL_PADDING)
			{stateFlags &= ~(1 << ON_SCREEN);}
	else	{stateFlags |= (1 << ON_SCREEN);}
}

#endregion