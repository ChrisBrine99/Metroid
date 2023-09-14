#region	Initializing any macros that are useful/related to obj_camera

// The bit flags for the camera, which allow view boundaries to be enabled or disabled along the room's bounds
// OR at given points within the room relative to where the view and player object currently are. The "reset"
// flags transition the view back to the player object before re-enabling standard movement.
#macro	LOCK_CAMERA_X			27	// When true, the camera will lock its x position to whatever the "obj_camera_boundary" instance requires.
#macro	LOCK_CAMERA_Y			28	// When true, the camera will lock its y position to whatever the "obj_camera_boundary" instance requires.
#macro	RESET_TARGET_X			29	// Makes the view to move back to the target object's X position.
#macro	RESET_TARGET_Y			30	// Makes the view to move back to the target object's Y position.
#macro	VIEW_BOUNDARY			31	// Keeps the camera's view within the confines of the current room.

// Comparison marcos to check the state for a given bit flag that the camera utilizes.
#macro	IS_CAMERA_X_LOCKED		(stateFlags & (1 << LOCK_CAMERA_X) != 0)
#macro	IS_CAMERA_Y_LOCKED		(stateFlags & (1 << LOCK_CAMERA_Y) != 0)
#macro	CAN_RESET_TARGET_X		(stateFlags & (1 << RESET_TARGET_X) != 0)
#macro	CAN_RESET_TARGET_Y		(stateFlags & (1 << RESET_TARGET_Y) != 0)
#macro	IS_VIEW_BOUND_ENABLED	(stateFlags & (1 << VIEW_BOUNDARY) != 0)

// Constants for the camera's "deadzone" region, which exists in the exact center of the view. This means the 
// camera's position won't be updated if the target object happens to move around within this region.
#macro	DEADZONE_WIDTH			4
#macro	DEADZONE_HEIGHT			3

// Determines distance that the entity's bounding box must be from the edges of the camera in order to have
// itself culled from the rendering process for the current frame.
#macro	RENDER_CULL_PADDING		12
#macro	OBJECT_CULL_PADDING		80

#endregion

#region Initializing enumerators that are useful/related to obj_camera
#endregion

#region Initializing any globals that are useful/related to obj_camera
#endregion

#region	The main object code for obj_camera

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_camera(_index) : base_struct(_index) constructor{
	// Stores the positions of the Camera itself, which represents the exact center of the game's viewport.
	x = 0;
	y = 0;
	
	// Contains bits that can be toggled on or off to enabled or disable functionalities and characteristics
	// of the Camera itself. From things like locking view movement to allowing movement outside of the room's
	// dimensions, and so on.
	stateFlags = 0;
	
	// Variables for the GML Camera that this struct utilizes. The ID of said camera is stored in the first 
	// variables, while the other three determine what instance in the game is currently being followed by the
	// camera; the final two variables being an offset relative to that target object's position to actually
	// target as the view's "resting" position.
	camera = camera_create();
	targetObject = noone;
	targetOffsetX = 0;
	targetOffsetY = 0;
	
	// Keeps track of the current instance of "obj_camera_boundary" that the target object is colliding with.
	prevBoundaryID = noone;
	
	// Variables that track the starting strength of the camera's shake effect, the current amount of shaking 
	// being applied to the camera, and the total duration of the effect.
	shakeSetStrength = 0.0;
	shakeCurStrength = 0.0;
	shakeDuration = 0.0;
	
	/// @description The standard cleanup function for the Camera, which mimics how GameMaker's own "cleanup"
	/// event. As such, it should be called within the "cleanup" event by the controller object that manages
	/// this struct.
	cleanup = function(){
		camera_destroy(camera);
	}
	
	/// @description The "End Step" function for the struct, which should be called in the "End Step" event of 
	/// the obejct that is set to managed this one. It will update the camera's position; resulting in a new
	/// position to the view based on the camera's position updates.
	end_step = function(){
		// Update the camera's position to lock it onto the position of the target object. After that, any view
		// bounds currently being applied to the camera are processed (Different from regular room boundaries).
		follow_target_object();
		process_camera_boundaries();
		
		// Once the camera's position has been updated to its target position for the frame, the view will be
		// updated to that position; the camera's position being the center of the resulting view.
		var _x = floor(x - (camera_get_view_width(camera) * 0.5));
		var _y = floor(y - (camera_get_view_height(camera) * 0.5));
		update_view_position(_x, _y);
		
		// Checking if the camera's shaking effect is active or not. If so, the current strength of the effect
		// will be decayed relative to its duration and starting strength.
		if (shakeCurStrength <= 0.0) {return;}
		shakeCurStrength -= shakeSetStrength / shakeDuration * DELTA_TIME;
		
		// Choose a random whole-pixel position within the range of (-strength, +strength) for the camera to
		// snap to; resulting in a frame-by-frame random position to simulate something shaking intensely.
		var _shakeStrength = round(shakeCurStrength);
		var _shakeX = camera_get_view_x(camera) + irandom_range(-_shakeStrength, _shakeStrength);
		var _shakeY = camera_get_view_y(camera) + irandom_range(-_shakeStrength, _shakeStrength);
		camera_set_view_pos(camera, _shakeX, _shakeY);
	}
	
	/// @description A function the mimics GameMaker's own "Room Start" event within its own objects. As such,
	/// it should be called in that event by this struct's management object. 
	room_start = function(){
		// 
		var _x			= x;
		var _y			= y;
		var _boundaryID = noone;
		with(targetObject){
			_x			= x;
			_y			= y;
			_boundaryID = instance_place(x, y, obj_camera_boundary);
		}
		
		// 
		prevBoundaryID = _boundaryID;
		if (_boundaryID != noone){
			with(_boundaryID){
				if (viewTargetX != -1) {_x = viewTargetX;}
				if (viewTargetY != -1) {_y = viewTargetY;}
			}
		} else{
			stateFlags	  &= ~((1 << LOCK_CAMERA_X)  | (1 << LOCK_CAMERA_Y) |
							   (1 << RESET_TARGET_X) | (1 << RESET_TARGET_Y));
		}
		x = _x;
		y = _y;
		
		// 
		view_set_camera(0, camera);
		view_set_visible(0, true);
		view_enabled = true;
	}
	
	/// @description Update the view's position to the coordinates supplied into the function arguments. If the
	/// room view boundaries flag is enabled, the position supplied will be clamped to be between (0, 0) and
	/// the current room's dimensions. This function will also call the function responsible for culling all
	/// entities that are currently off-screen.
	/// @param {Real}	x	Target value for the viewport's next X position.
	/// @param {Real}	y	Target value for the viewport's next Y position.
	update_view_position = function(_x, _y){
		var _width = camera_get_view_width(camera);
		var _height = camera_get_view_height(camera);
		if (IS_VIEW_BOUND_ENABLED){
			_x = clamp(_x, 0, max(room_width - _width, 0));
			_y = clamp(_y, 0, max(room_height - _height, 0));
		}
		camera_set_view_pos(camera, _x, _y);
		cull_off_screen_entities(_x, _y, _width, _height);
	}
	
	/// @description Updates the position of the camera based on the target object's position, but only if the
	/// camera is locked along the x and y axes, respectively. If either or both are currently unlocked, this
	/// function will not update the camera's position along the axis or axes.
	follow_target_object = function(){
		// By default, the camera's target posiiton will be its own position to prevent it from snapping to
		// some aribtrary default position that these target variables use as default values. If there is an
		// object to follow, its current position will be used instead.
		var _targetX = x;
		var _targetY = y;
		if (targetObject != noone){ // Don't bother applying target offset if there is no target to follow.
			with(targetObject){
				_targetX = x;
				_targetY = y;
			}
			_targetX += targetOffsetX;
			_targetY += targetOffsetY;
		}
		
		// Moving the camera along the x-axis if required to keep the object it's following within the deadzone
		// boundary of said axis. No movement to the deadzone is processed if the camera isn't currently locked
		// along its horizontal.
		if (!IS_CAMERA_X_LOCKED){
			if (_targetX < x - DEADZONE_WIDTH)		 {x = _targetX + DEADZONE_WIDTH;}
			else if (_targetX > x + DEADZONE_WIDTH)	 {x = _targetX - DEADZONE_WIDTH;}
		}
		
		// Performing the same movement as the x-axis, but for the y-axis. No movement occurs if the camera is
		// currently considered "unlocked" along the vertical axis; much like what happens along the horizontal.
		if (!IS_CAMERA_Y_LOCKED){
			if (_targetY < y - DEADZONE_HEIGHT)		 {y = _targetY + DEADZONE_HEIGHT;}
			else if (_targetY > y + DEADZONE_HEIGHT) {y = _targetY - DEADZONE_HEIGHT;}
		}
	}
	
	/// @description Processes the camera's current in-room view boundaries, which are determined by the target
	/// object's collision with an instance of "obj_camera_boundary". Also handles smoothly moving the camera
	/// back onto tracking the target object if the specialized boundaries are no longer required.
	process_camera_boundaries = function(){
		if (GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}
		
		var _targetX		= -1;
		var _targetY		= -1;
		var _stateFlags		= stateFlags;
		var _prevBoundaryID = prevBoundaryID;
		with(targetObject){ // Collision check occurs within the instance that the camera is currently following.
			var _boundary = instance_place(x, y, obj_camera_boundary);
			with(_boundary){
				// Only apply a new target along the camera's x axis if the view boundary has an actual value
				// provided for the axis. Otherwise, it won't have an in-game boundary applied to it.
				if (viewTargetX != -1){
					_stateFlags &= ~(1 << RESET_TARGET_X);
					_stateFlags |= (1 << LOCK_CAMERA_X);
					_targetX	 = viewTargetX;
				}
				
				// The same process that occurred for the x axis also occurs for the y axis; apply boundary
				// target if a value is given; don't do anything on the axis, otherwise.
				if (viewTargetY != -1){
					_stateFlags &= ~(1 << RESET_TARGET_Y);
					_stateFlags |= (1 << LOCK_CAMERA_Y);
					_targetY	 = viewTargetY;
				}
			}
			
			// If there is a mismatch between the value of "_boundary" (The view boundary--or lack thereof--that
			// the target object is currently colliding with) and the instance ID stored in the camera's
			// "prevBoundaryID" variable, the view across the locked axis/axes is unlocked in order to have it
			// reset to following the target object along that axis/axes once again.
			if (_boundary != _prevBoundaryID){
				_prevBoundaryID = _boundary;
				if (_stateFlags & (1 << LOCK_CAMERA_X)) {_stateFlags |= (1 << RESET_TARGET_X);}
				if (_stateFlags & (1 << LOCK_CAMERA_Y)) {_stateFlags |= (1 << RESET_TARGET_Y);}
			}
		}
		prevBoundaryID	= _prevBoundaryID;
		stateFlags		= _stateFlags;
		
		// Moves the camera to the x position it will be locked to if the view is currently locked along its
		// axis OR will smoothly move the camera back to following the target object's x position if the camera
		// has been told to reset its x position.
		if (_targetX != -1 && !CAN_RESET_TARGET_X){
			x				= value_set_relative(x, _targetX, 0.25);
		} else if (CAN_RESET_TARGET_X){
			var _oTargetX	= targetObject.x + targetOffsetX;
			x				= value_set_relative(x, _oTargetX, 0.25 + abs(targetObject.hspd * 0.2));
			if (abs(x - _oTargetX) <= DEADZONE_WIDTH) 
				stateFlags &= ~((1 << RESET_TARGET_X) | (1 << LOCK_CAMERA_X));
		}
		
		// Moves the camera using the same parameters and conditions as when it moves along the x axis, but
		// for the vertical position of the camera/view instead.
		if (_targetY != -1 && !CAN_RESET_TARGET_Y){
			y				= value_set_relative(y, _targetY, 0.25);
		} else if (CAN_RESET_TARGET_Y){
			var _oTargetY	= targetObject.y + targetOffsetY;
			y				= value_set_relative(y, _oTargetY, 0.25 + abs(targetObject.vspd * 0.2));
			if (abs(y - _oTargetY) <= DEADZONE_HEIGHT)
				stateFlags &= ~((1 << RESET_TARGET_Y) | (1 << LOCK_CAMERA_Y));
		}
	}
	
	/// @description 
	/// @param {Real}	x		Current x-position for the camera's viewport.
	/// @param {Real}	y		Current y-position for the camera's viewport.
	/// @param {Real}	width	Width of the camera's viewport (In pixels).
	/// @param {Real}	height	Height of the camera's viewport (In pixels).
	cull_off_screen_entities = function(_x, _y, _width, _height){
		with(par_dynamic_entity){
			if (!CAN_DRAW_SPRITE) {continue;} // Ignore invisible dynamic entities.
			entity_is_on_screen(_x, _y, _width, _height);
		}
		with(par_static_entity){
			if (!CAN_DRAW_SPRITE) {continue;} // Ignore invisible static entities.
			entity_is_on_screen(_x, _y, _width, _height);
		}
		
		// 
		instance_deactivate_object(par_dynamic_entity);
		instance_deactivate_object(par_static_entity);
		instance_activate_region(
			_x			 - OBJECT_CULL_PADDING,
			_y			 - OBJECT_CULL_PADDING,
			_x + _width  + OBJECT_CULL_PADDING,
			_y + _height + OBJECT_CULL_PADDING,
			true // Signifies that the region within the bounds is where entities are reactivated.
		);
		instance_activate_object(PLAYER);	// Player is always an active object
	}
}

#endregion

#region Global functions related to obj_camera

/// @description Initializes the camera by supplying an initial position, as well as a view width, height,
/// window scale, and any flags that should be enabled upon its creation.
/// @param {Real}	x			Initial x position of the camera in the room.
/// @param {Real}	y			Initial y position of the camera in the room.
/// @param {Real}	width		Width in pixels for the viewport.
/// @param {Real}	height		Height in pixels for the viewport.
/// @param {Real}	scale		Scale factor for the window relative to the viewport size.
/// @param {Real}	flags		All required flags to apply to the camera upon its initialization.
function camera_initialize(_x, _y, _width, _height, _scale, _flags){
	with(CAMERA){
		// First, set position and copy over the flags argument; overwritting whatever may have previously
		// been occupying these variables.
		x			= _x;
		y			= _y;
		stateFlags	= _flags;
		
		// Set the sizes of the view, application surface, and GUI to match the required resolution. The window
		// is also set to match these dimensions, but will have the scale applied to it as well as extra logic
		// to center the window on the user's primary display.
		camera_set_view_size(camera, _width, _height);
		surface_resize(application_surface, _width, _height);
		display_set_gui_size(_width, _height);
		
		// Get the dimensions of the user's main display in order to determine the game's maximum possible 
		// scaling factor for the window. The height is what determines that maximum scaling integer.
		var _displayWidth = display_get_width();
		var _displayHeight = display_get_height();
		_scale = min(floor(_displayHeight / _height), _scale);
		
		// Set the window's dimensions based on the width and height values multiplied by the calculated scaling
		// integer. Then, the window is centered based on the resulting window size against the display dimensions.
		var _windowWidth = _width * _scale;
		var _windowHeight = _height * _scale;
		window_set_size(_windowWidth, _windowHeight);
		window_set_position(floor((_displayWidth - _windowWidth) * 0.5), floor((_displayHeight - _windowHeight) * 0.5));
		
		// Update the in-game view's position so it remains centered on whatever was at the middle of the view
		// prior to the camera's dimensions being altered.
		update_view_position(_x - (_width * 0.5), _y - (_height * 0.5));
		
		// Finally, the effect handler updates the application surface's texel values to match what the new
		// dimensions need them to be when normalized between 0.0 and 1.0.
		with(EFFECT_HANDLER){
			windowTexelWidth	= 1 / _width;
			windowTexelHeight	= 1 / _height;
		}
		
		// 
		with(MAP_MANAGER){
			cellWidth	= _width;
			cellHeight	= _height;
		}
	}
}

/// @description Sets the camera to follow a specific instance that exists within the room. If no object with
/// the given ID exists within the room, the camera will not attempt to target them.
/// @param {Id.Instance}	object			The unique ID value for the instance that the camera will follow.
/// @param {Real}			offsetX			Positional offset relative to the followed object's X origin value.
/// @param {Real}			offsetY			Positional offset relative to the followed object's Y origin value.
function camera_set_target_object(_object, _offsetX, _offsetY){
	with(CAMERA){
		if (instance_exists(_object)){
			targetObject	= _object;				// Stores ID and offset paramters.
			targetOffsetX	= _offsetX;
			targetOffsetY	= _offsetY;
			x				= _object.x + _offsetX;	// Snaps camera to proper position.
			y				= _object.y + _offsetY;
		}
	}
}

/// @description Applies a shaking effect to the camera of variable duration and intendity. If the strength
/// for the shaking is higher than what is currently applied to the camera (If any shake at all), the new
/// shake effect's parameters will overwrite the previous. Otherwise, the previous will continue on as normal.
/// @param {Real}	strength	Determines the starting intensity of the effect.
/// @param {Real}	duration	The total length of the shake effect.
function camera_set_shake(_strength, _duration){
	with(CAMERA){
		if (shakeCurStrength < _strength){
			shakeSetStrength	= _strength;
			shakeCurStrength	= _strength;
			shakeDuration		= _duration;
		}
	}
}

#endregion