#region Initializing any macros that are useful/related to obj_arm_cannon
#endregion

#region Initializing enumerators that are useful/related to obj_arm_cannon
#endregion

#region Initializing any globals that are useful/related to obj_arm_cannon
#endregion

#region The main object code for obj_arm_cannon

/// @param {Real}			index		Unique value generated by GML during compilation that represents this struct asset.
function obj_player_ghost_effect(_index) : base_struct(_index) constructor{
	// Much like Game Maker's own x and y variables, these store the current position of the camera within 
	// the current room. By default they are always set to a value of zero.
	x = 0;
	y = 0;
	
	// Borrows the naming-scheme and functionality of GameMaker's own "sprite_index" and "image_xscale" variables
	// for drawing the effect. Using a unique alpha channel value and stores the frame of Samus's animation
	// that will be used for the effect.
	sprite_index = NO_SPRITE;
	image_xscale = 1;
	imageIndex	 = 0;
	alpha		 = 0.0;
	
	// Determines whether or not to draw a seperate arm cannon that is visible during for some of Samus's
	// sprites (Standing, Crouching, Jumping, etc.) and animations (Walking). It will use the data within the
	// struct below to draw the arm cannon should the ghosting effect need to show it along with Samus.
	drawArmCannon = false;
	armCannon = {
		x				: 0,
		y				: 0,
		image_xscale	: 1,
		imageIndex		: 0,
	};
	
	/// @description Placed within the Cleanup event of whatever object is managing this struct (More than
	/// likely the player object since they create the effect). It will "delete" the armCannon struct, which
	/// signals to GML's garbage collector that it can be freed from memory.
	cleanup = function(){
		delete armCannon;
	}
	
	/// @description Placed within the Draw event of whatever is managing this object (More than likely the
	/// player object since it's their effect). It will simply render the image provided by its variables;
	/// skipping that rendering entirely if there isn't a valid sprite index set.
	draw = function(){
		if (sprite_index == NO_SPRITE) {return;}
		draw_sprite_ext(sprite_index, imageIndex, x, y, image_xscale, 1, 0, image_blend, alpha);
		
		if (!drawArmCannon) {return;} // Skip drawing the arm cannon if is isn't set to visible
		var _xx		= x;
		var _yy		= y;
		var _alpha	= alpha;
		var _color	= image_blend;
		with(armCannon) {draw_sprite_ext(spr_samus_cannon0, imageIndex, _xx + x, _yy + y, image_xscale, 1, 0, _color, _alpha);}
	}
}

#endregion

#region Global functions related to obj_arm_cannon

/// @description Creates the ghosting effect that ir produced by Samus whenever she is somersaulting in the air.
/// These ghosts are lightweight objects that are created and have their pointers returned by this function for
/// storage and memory management.
/// @param {Real}			x			Samus's x position at the time of this effect's creation.
/// @param {Real}			y			Samus's y position at the time of this effect's creation.
/// @param {Asset.GMSprite} sprite		The jumping sprite that is copied over from Samus.
/// @param {Real}			imageIndex	The image of the copied over jumping sprite to draw. 
/// @param {Real}			imageXScale The direction Samus is currently facing (1 == Right, -1 == Left).
/// @param {Real}			color		Blending color to apply to the ghost sprite.
/// @param {Real}			alpha		Starting opacity for the ghost sprite.
/// @param {Bool}			drawCannon	Toggles the rendering of the arm cannon on or off for the ghost sprite.
function create_player_ghost_effect(_x, _y, _sprite, _imageIndex, _imageXScale, _color, _alpha, _drawCannon = false){
	var _struct = instance_create_struct(obj_player_ghost_effect);
	with(_struct){ // Apply all the properties to the newly created jump effect.
		x				= _x;
		y				= _y;
		sprite_index	= _sprite;
		image_xscale	= _imageXScale;
		image_blend		= _color;
		imageIndex		= _imageIndex;
		alpha			= _alpha;
		
		// Skip accessing the arm cannon struct that exists within this effect object instance if it doesn't
		// need to be drawn for the given sprite. Otherwise, copy all required sprite flipping and position
		// offset data so it matches how Samus's normal sprite should look.
		if (!_drawCannon) {break;}
		drawArmCannon = _drawCannon;
		with(armCannon){
			var _xx = 0;
			var _yy = 0;
			with(PLAYER.armCannon){
				_xx			= x;
				_yy			= y;
				_imageIndex = imageIndex;
			}
			x			 = _xx;
			y			 = _yy;
			image_xscale = _imageXScale;
			imageIndex	 = _imageIndex;
		}
	}
	return _struct;
}

#endregion