#region Initializing any macros that are useful/related to obj_arm_cannon
#endregion

#region Initializing enumerators that are useful/related to obj_arm_cannon
#endregion

#region Initializing any globals that are useful/related to obj_arm_cannon
#endregion

#region The main object code for obj_arm_cannon

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_arm_cannon(_index) : base_struct(_index) constructor{
	// Much like Game Maker's own x and y variables, these store the current position of the camera within 
	// the current room. By default they are always set to a value of zero.
	x = 0;
	y = 0;
	
	// Much like a standard object's "image_xscale" variable and "visible" boolean, these will determine how
	// the arm cannon will be drawn on the screen. The scaling value will always be either 1 or -1 depending
	// on the direction Samus is facing, and the visibility of the arm cannon will be determined by Samus's
	// various states (Ex. Morphball) and animations (Ex. Entering a jump).
	image_xscale = 1;
	visible = false;
	
	// Stores the image that will be drawn at the arm cannon's current position to respresent said weapon.
	// The arm cannon will be facing different direction and look different depending on what Samus is doing,
	// so this variable allows that to be applied to the final image that is drawn.
	imageIndex = 0;
	
	// Stores the player's current position for the frame which is used during the arm cannon's draw event.
	playerX = 0;
	playerY = 0;
	
	/// @description Called in the "End Step" event of whatever (The player most likely) is controlling this
	/// lightweight object. It will update the characteristics of the arm cannon depending on the actions
	/// Samus is performing, and the state she currently finds herself in.
	end_step = function(){
		var _x = x;
		var _y = y;
		var _playerX = 0;
		var _playerY = 0;
		var _visible = true;
		var _imageXScale = image_xscale;
		var _imageIndex = imageIndex;
		with(PLAYER){
			_playerX = x;
			_playerY = y;
			var _state = curState;
			switch(_state){
				case NO_STATE: // Simply set the beam to be invisible or visible based on what it was previously.
					_visible = other.visible;
					break;
				case state_phase_shift: // Determining visibility of arm cannon during a phase shift.
					_visible = !IS_GROUNDED;
					break;
				case state_room_warp: // When warping the position isn't updated, but the cannon will be drawn if it was previously.
					_visible = IS_AIMING && !IN_MORPHBALL;
					break;
				case state_default: // Beam position for when samus is standing or walking on the floor.
					if (stateFlags & (1 << AIMING_UP)){
						_x = -(1 * image_xscale);
						_y = -43;
						// Determines if the player's missiles are active, which will change the image that is 
						// used to respresent the arm cannon.
						if (curWeapon == curMissile) {_imageIndex = 5;}
						else						 {_imageIndex = 4;}
						break;
					} else if (IS_MOVING){
						if (!IS_AIMING) {_visible = false;}
						_x = (9 * image_xscale);
						_y = -30;
						// Determines if the player's missiles are active, which will change the image that is 
						// used to respresent the arm cannon (Index zero and two have no cutout).
						if (curWeapon == curMissile) {_imageIndex = 2;}
						else						 {_imageIndex = 0;}
						break;
					}
					_x = (5 * image_xscale);
					_y = -27;
					// Determines if the player's missiles are active, which will change the image that is 
					// used to respresent the arm cannon (Index one and three have the cutout for her hand).
					if (curWeapon == curMissile) {_imageIndex = 3;}
					else						 {_imageIndex = 1;}
					break;
				case state_airbourne: // Beam positions for whenever Samus is in the air.
					if (stateFlags & (1 << AIMING_UP)){
						if (jumpStartTimer < JUMP_ANIM_TIME){ // Temporarily use the standing while aiming up coordinates for the intro animation.
							_x = -(1 * image_xscale);
							_y = -43;
						} else{ // Animation is finished; use standard coordinates for jumping while aiming up.
							_x = -(1 * image_xscale);
							_y = -40;
						}
						// Determines if the player's missiles are active, which will change the image that is 
						// used to respresent the arm cannon.
						if (curWeapon == curMissile) {_imageIndex = 5;}
						else						 {_imageIndex = 4;}
						break;
					} else if (stateFlags & (1 << AIMING_DOWN)){
						_x = 0;
						_y = -18;
						// Determines if the player's missiles are active, which will change the image that is 
						// used to respresent the arm cannon.
						if (curWeapon == curMissile) {_imageIndex = 7;}
						else						 {_imageIndex = 6;}
						break;
					}
					// Make the arm cannon invisible while somersaulting OR during the first frame of animation
					// for all possible jump "intro" animations. The only exception to this is the second frame of
					// the somersaulting intro where the arm cannon must be drawn to complete the sprite that is used.
					if ((IS_JUMP_SPIN && sprite_index != jumpSpriteFw) || (jumpStartTimer < JUMP_ANIM_TIME && vspd <= 0)) {_visible = false;}
					_x = (5 * image_xscale);
					_y = -25;
					// Determines if the player's missiles are active, which will change the image that is 
					// used to respresent the arm cannon (Index one and three have the cutout for her hand).
					if (curWeapon == curMissile) {_imageIndex = 3;}
					else						 {_imageIndex = 1;}
					break;
				case state_crouching: // Arm cannon's single position for when Samus is crouched.
					_x = (4 * image_xscale);
					_y = -17;
					// Determines if the player's missiles are active, which will change the image that is 
					// used to respresent the arm cannon (Index one and three have the cutout for her hand).
					if (curWeapon == curMissile) {_imageIndex = 3;}
					else						 {_imageIndex = 1;}
					break;
				default: // By default the arm cannon will not be rendered.
					_visible = false;
					break;
			}
			_imageXScale = image_xscale;
		}
		x = _x;
		y = _y;
		playerX = _playerX;
		playerY = _playerY;
		visible = _visible;
		image_xscale = _imageXScale;
		imageIndex = _imageIndex;
	}
	
	/// @description Called within the "Draw" event of whatever (Most like the player) is controlling this
	/// lightweight object. It will simply draw the arm cannon at its x/y position in the room depending on
	/// its visibility flag being true.
	draw = function(){
		if (!visible) {return;}
		draw_sprite_ext(spr_samus_cannon0, imageIndex, playerX + x, playerY + y, image_xscale, 1, 0, c_white, 1);
	}
}

#endregion

#region Global functions related to obj_arm_cannon
#endregion