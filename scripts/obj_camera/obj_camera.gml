#region	Initializing any macros that are useful/related to obj_camera

// ------------------------------------------------------------------------------------------------------- //
//	Values for the flags found within obj_camera's "stateFlags" variable, which allows for various parts   //
//	of the Camera's functionality to be enabled/disabled regardless of its current state.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	CAM_MANUAL_MOVEMENT		0x20000000
#macro	CAM_VIEW_BOUNDS			0x40000000
#macro	CAM_FOLLOW_OBJECT		0x80000000

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check each of the Camera's different substate flags.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	CAM_IS_MOVEMENT_MANUAL	(stateFlags & CAM_MANUAL_MOVEMENT)
#macro	CAM_VIEW_BOUNDS_ACTIVE	(stateFlags & CAM_VIEW_BOUNDS)
#macro	CAM_CAN_FOLLOW_OBJECT	(stateFlags & CAM_FOLLOW_OBJECT)

// ------------------------------------------------------------------------------------------------------- //
//	Determines the size of the square region found in the middle of the screen that will prevent the	   //
//	camera from moving so long as its target object only moves within that area.						   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DEADZONE_WIDTH			4
#macro	DEADZONE_HEIGHT			3

// ------------------------------------------------------------------------------------------------------- //
//	Determines the distance from the edge of the camera's viewport that an object must exceed for it to	   //
//	be skipped in the rendering process or have its existence deactivated entirely, respectively.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	RENDER_CULL_PADDING		0x10
#macro	OBJECT_CULL_PADDING		0x60

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	CAM_VIEW_MANUAL_XSPEED	0.25
#macro	CAM_VIEW_MANUAL_YSPEED	0.15
#macro	CAM_VIEW_AXIS_RESET	   -2

#endregion

#region Initializing enumerators that are useful/related to obj_camera
#endregion

#region Initializing any globals that are useful/related to obj_camera
#endregion

#region	The main object code for obj_camera

function obj_camera(_index) : base_struct(_index) constructor{
	// Stores the positions of the Camera itself, which represents the exact center of the game's viewport.
	x = 0;
	y = 0;
	
	// Contains bits that can be toggled on or off to enabled or disable functionalities and characteristics
	// of the Camera itself. From things like locking view movement to allowing movement outside of the room's
	// boundaries, and so on.
	stateFlags = 0;
	
	// 
	camera			= camera_create();
	targetObject	= noone;
	targetOffsetX	= 0;
	targetOffsetY	= 0;
	targetPrevX		= 0;
	targetPrevY		= 0;
	
	// 
	curBoundaryID	= noone;
	viewMinX		= -1;
	viewMaxX		= -1;
	viewMinY		= -1;
	viewMaxY		= -1;
	viewTargetX		= -1;
	viewTargetY		= -1;
	camMoveSpeed	= 1.0;
	
	// 
	noCullLayer		= -1;
	
	// Variables that track the starting strength of the camera's shake effect, the current amount of shaking 
	// being applied to the camera, and the total duration of the effect.
	shakeSetStrength = 0.0;
	shakeCurStrength = 0.0;
	shakeDuration	 = 0.0;
	
	/// @description The standard cleanup function for the Camera, which mimics how GameMaker's own "cleanup"
	/// event. As such, it should be called within the "cleanup" event by the controller object that manages
	/// this struct.
	cleanup = function(){
		camera_destroy(camera);
	}
	
	/// @description 
	begin_step = function(){
		// 
		if (targetObject == noone)
			return;
		
		// 
		var _targetX = 0;
		var _targetY = 0;
		with(targetObject){
			_targetX = x;
			_targetY = y;
		}
		targetPrevX = _targetX + targetOffsetX;
		targetPrevY = _targetY + targetOffsetY;
	}
	
	/// @description The "End Step" function for the struct, which should be called in the "End Step" event of 
	/// the obejct that is set to managed this one. It will update the camera's position; resulting in a new
	/// position to the view based on the camera's position updates.
	end_step = function(){
		// Update the camera's position to lock it onto the position of the target object. After that, any view
		// bounds currently being applied to the camera are processed (Different from regular room boundaries).
		follow_target_object(2.0, 20, 8);
		process_camera_boundaries(x, y);
		
		// 
		var _width  = camera_get_view_width(camera);
		var _height = camera_get_view_height(camera);
		var _x		= floor(x - (_width * 0.5));
		var _y		= floor(y - (_height * 0.5));
		
		// 
		if (viewTargetX == -1){
			if (viewMinX != -1 && _x < viewMinX)				{_x = viewMinX;}
			else if (viewMaxX != -1 && _x + _width > viewMaxX)	{_x = viewMaxX - _width;}
		}
		
		if (viewTargetY == -1){
			if (viewMinY != -1 && _y < viewMinY)				{_y = viewMinY;}
			else if (viewMaxY != -1 && _y + _height > viewMaxY)	{_y = viewMaxY - _height;}
		}
		
		// 
		update_view_position(_x, _y, _width, _height);
		
		// 
		_x = camera_get_view_x(camera);
		_y = camera_get_view_y(camera);
		cull_off_screen_entities(_x, _y, _width, _height);

		// Checking if the camera's shaking effect is active or not. If so, the current strength of the effect
		// will be decayed relative to its duration and starting strength.
		if (shakeCurStrength <= 0.0)
			return;
		shakeCurStrength -= shakeSetStrength / shakeDuration * DELTA_TIME;
		
		// Choose a random whole-pixel position within the range of (-strength, +strength) for the camera to
		// snap to; resulting in a frame-by-frame random position to simulate something shaking intensely.
		var _shakeStrength = round(shakeCurStrength);
		var _shakeX = _x + irandom_range(-_shakeStrength, _shakeStrength);
		var _shakeY = _y + irandom_range(-_shakeStrength, _shakeStrength);
		camera_set_view_pos(camera, _shakeX, _shakeY);
	}
	
	/// @description A function the mimics GameMaker's own "Room Start" event within its own objects. As such,
	/// it should be called in that event by this struct's management object. 
	room_start = function(){
		// 
		noCullLayer = layer_get_id("Entities_NO_CULL");
		
		// 
		view_set_camera(0, camera);
		view_set_visible(0, true);
		view_enabled = true;
		
		// 
		var _camHalfWidth	= (camera_get_view_width(camera) >> 1);
		var _camHalfHeight	= (camera_get_view_height(camera) >> 1);
		var _targetX		= x;
		var _targetY		= y;
		var _offsetX		= targetOffsetX;
		var _offsetY		= targetOffsetY;
		with(targetObject){
			_targetX = x;
			_targetY = y;
			
			// 
			with(instance_place(x + _offsetX, y + _offsetY, obj_camera_collider)){
				if (viewTargetX != -1) {_targetX = viewTargetX + _camHalfWidth;}
				if (viewTargetY != -1) {_targetY = viewTargetY + _camHalfHeight;}
			}
		}
		
		// 
		x = _targetX;
		y = _targetY;
		update_view_position(floor(_targetX - _camHalfWidth), floor(_targetY - _camHalfHeight),
								_camHalfWidth * 2, _camHalfHeight * 2);

		// 
		var _camera = camera;
		with(SCREEN_FADE){
			pTargetX -= camera_get_view_x(_camera);
			pTargetY -= camera_get_view_y(_camera);
		}
	}
	
	/// @description Update the view's position to the coordinates supplied into the function arguments. If the
	/// room view boundaries flag is enabled, the position supplied will be clamped to be between (0, 0) and
	/// the current room's dimensions. This function will also call the function responsible for culling all
	/// entities that are currently off-screen.
	/// @param {Real}	x	Target value for the viewport's next X position.
	/// @param {Real}	y	Target value for the viewport's next Y position.
	update_view_position = function(_x, _y, _width, _height){
		if (CAM_VIEW_BOUNDS_ACTIVE){
			_x = clamp(_x, 0, max(room_width - _width, 0));
			_y = clamp(_y, 0, max(room_height - _height, 0));
		}
		camera_set_view_pos(camera, _x, _y);
	}
	
	/// @description Updates the position of the camera based on the target object's position, but only if the
	/// camera is locked along the x and y axes, respectively. If either or both are currently unlocked, this
	/// function will not update the camera's position along the axis or axes.
	/// @param {Real}	speed		Determines how fast the camera will move relative to the target object's current movement speeds.
	/// @param {Real}	xLimit		Determines how far ahead the camera can move along the x axis when following the target object.
	/// @param {Real}	yLimit		Determines how far ahead the camera can move along the y axis when following the target object.
	follow_target_object = function(_speed, _xLimit, _yLimit){
		// Don't bother even attempting to follow an object if there isn't an instance set as the camera's
		// current follow target. At the same time, ignore following an object if the camera's flag that tells
		// it to follow its target object isn't currently set.
		if (targetObject == noone || !CAM_CAN_FOLLOW_OBJECT)
			return;
		
		// First, the target object's position must be grabbed and stored into two local values for their
		// current x and y values within the room, respectively. Then, the values set for the offsets along
		// those axes within the camera itself are applied.
		var _targetX	= 0;
		var _targetY	= 0;
		with(targetObject){
			_targetX	= x;
			_targetY	= y;
		}
		_targetX += targetOffsetX;
		_targetY += targetOffsetY;

		// Handling horizontal movement for the camera. It handles resetting the view back to following the 
		// target object if it was previously locked by a camera boundary object previously. If no reset needs
		// to occur, the camera will simply follow slightly ahead of the direction the target object is moving
		// in along the x axis.
		if (viewTargetX == CAM_VIEW_AXIS_RESET){
			if (_targetX >= x - _xLimit && _targetX <= x + _xLimit) {viewTargetX = -1;}
			else {x = value_set_relative(x, _targetX, CAM_VIEW_MANUAL_XSPEED * camMoveSpeed);}
		} else if (targetPrevX != _targetX && viewTargetX == -1){
			x += (_targetX - targetPrevX) * _speed;
			if (_targetX < x - _xLimit)			{x = _targetX + _xLimit;}
			else if (_targetX > x + _xLimit)	{x = _targetX - _xLimit;}
		}
		
		// Handling vertical movement. It's the same logic as the horizontal movement, but along the vertical
		// axis of the room instead of the horizontal. It also follows slightly ahead of the direction the
		// target object is currently moving along, but for the y axis instead of the x axis.
		if (viewTargetY == CAM_VIEW_AXIS_RESET){
			if (_targetY >= y - _yLimit && _targetY <= y + _yLimit) {viewTargetY = -1;}
			else {y = value_set_relative(y, _targetY, CAM_VIEW_MANUAL_YSPEED * camMoveSpeed);}
		} else if (targetPrevY != _targetY && viewTargetY == -1){
			y += (_targetY - targetPrevY) * _speed;
			if (_targetY < y - _yLimit)			{y = _targetY + _yLimit;}
			else if (_targetY > y + _yLimit)	{y = _targetY - _yLimit;}
		}
	}
	
	/// @description 
	/// @param {Real}	x
	/// @param {Real}	y
	process_camera_boundaries = function(_x, _y){
		// Ignore processing camera boundaries if the camera isn't set to actively following an object within
		// the current room OR there isn't currently a valid target instance to follow.
		if (targetObject == noone || !CAM_CAN_FOLLOW_OBJECT)
			return;
		
		// First, a collision check needs to occur to see if the camera should correct its current position
		// to whatever a collider has set for it. It does this by using the target object's bounding box since
		// the camera itself is a simple object that contains none of the logic for a bounding box.
		var _instanceID = noone;
		var _offsetX	= targetOffsetX;
		var _offsetY	= targetOffsetY;
		with(targetObject){
			_instanceID = instance_place(x + _offsetX, y + _offsetY, obj_camera_collider);
		}
		
		// If the collision check returned no valid instance, the functino exists early and the varaibles that
		// are necessary for the boundary logic will be reset. The two target variables for the camera's x and
		// y coordinates are set to a special value that allows them to automatically reset themselves to follow
		// the target object once again.
		if (_instanceID == noone){
			if (curBoundaryID != noone){
				stateFlags	   &= ~CAM_MANUAL_MOVEMENT;
				curBoundaryID	= noone;
				viewMinX		= -1;
				viewMaxX		= -1;
				viewMinY		= -1;
				viewMaxY		= -1;
				viewTargetX		= CAM_VIEW_AXIS_RESET;
				viewTargetY		= CAM_VIEW_AXIS_RESET;
				camMoveSpeed	= 1.0;
			}
			return;
		}
		
		// If the current bounding ID doesn't match the ID that was returned by the collision check, the info
		// about the camera's current boundaries will need to be updated to match whatever the new camera boundary
		// instance has set for it instead of whatever info was there previously.
		if (_instanceID != curBoundaryID){
			curBoundaryID = _instanceID;
			
			// Create local variables for all the information that will be copied over from the camera bounds
			// object into the camera's boundary logic variables. Doing it like this saves GameMaker from
			// jumping between the two objects to copy the data over one by one, which is less efficient.
			var _viewMinX		= -1;
			var _viewMaxX		= -1;
			var _viewMinY		= -1;
			var _viewMaxY		= -1;
			var _viewTargetX	= -1;
			var _viewTargetY	= -1;
			var _camMoveSpeed	= 1.0;
			with(_instanceID){
				_viewMinX		= viewMinX;
				_viewMaxX		= viewMaxX;
				_viewMinY		= viewMinY;
				_viewMaxY		= viewMaxY;
				_viewTargetX	= viewTargetX;
				_viewTargetY	= viewTargetY;
				_camMoveSpeed	= camMoveSpeed;
			}
			viewMinX = _viewMinX;
			viewMaxX = _viewMaxX;
			viewMinY = _viewMinY;
			viewMaxY = _viewMaxY;
			
			// The view targets are only set if either the x and y target variables are set within the camera
			// boundary instance. This means that it can override the x value with another despite only locking
			// thecamera along the y axis, and vice versa.
			if (_viewTargetX != -1 || _viewTargetY != -1){
				stateFlags |= CAM_MANUAL_MOVEMENT;
				viewTargetX = _viewTargetX;
				viewTargetY = _viewTargetY;
				camMoveSpeed = _camMoveSpeed;
			}
		}
		
		// This piece of code 
		if (CAM_IS_MOVEMENT_MANUAL){
			// 
			if ((viewTargetX == -1 && viewTargetY == -1) || (x = viewTargetX && y == viewTargetY)){
				stateFlags &= ~CAM_MANUAL_MOVEMENT;
				viewTargetX = -1;
				viewTargetY = -1;
				return;
			}
			
			// 
			if (viewTargetX != -1) {x = value_set_relative(x, viewTargetX, CAM_VIEW_MANUAL_XSPEED * camMoveSpeed);}
			if (viewTargetY != -1) {y = value_set_relative(y, viewTargetY, CAM_VIEW_MANUAL_YSPEED * camMoveSpeed);}
		}
	}
	
	/// @description 
	/// @param {Real}	x		Current x-position for the camera's viewport.
	/// @param {Real}	y		Current y-position for the camera's viewport.
	/// @param {Real}	width	Width of the camera's viewport (In pixels).
	/// @param {Real}	height	Height of the camera's viewport (In pixels).
	cull_off_screen_entities = function(_x, _y, _width, _height){
		with(par_dynamic_entity){
			if (!ENTT_CAN_DRAW_SELF) 
				continue; // Ignore invisible dynamic entities.
			entity_is_on_screen(_x, _y, _width, _height);
		}
		with(par_static_entity){
			if (!ENTT_CAN_DRAW_SELF)
				continue; // Ignore invisible static entities.
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
		instance_activate_object(PLAYER);		// Player is always an active object
		instance_activate_layer(noCullLayer);	// Also enabled any other entities that shouldn't be culled.
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
		update_view_position(_x - (_width * 0.5), _y - (_height * 0.5), _width, _height);
		
		// Finally, the effect handler updates the application surface's texel values to match what the new
		// dimensions need them to be when normalized between 0.0 and 1.0.
		with(EFFECT_HANDLER){
			windowTexelWidth	= 1 / _width;
			windowTexelHeight	= 1 / _height;
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
			stateFlags	   |= CAM_FOLLOW_OBJECT;
			targetObject	= _object;				// Stores ID and offset paramters.
			targetOffsetX	= _offsetX;
			targetOffsetY	= _offsetY;
			targetPrevX		= _object.x;			// Defaults previous position to followed object's position.
			targetPrevY		= _object.y;
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