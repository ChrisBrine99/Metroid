/// @description Updates the position of the camera used the currently desired movement method, whether that be
/// free and smooth movement while unlocked, or a locked-on movement with a deadzone in the center.

function update_camera_position() {
	// FOR CUTSCENES -- Returns true if the unlocked camera movement reached its desired position
	var _positionReached = false;

	// Calculating the bounds of the camera relative to the edges of the room
	var _halfWidth, _halfHeight;
	_halfWidth = WINDOW_WIDTH / 2;
	_halfHeight = WINDOW_HEIGHT / 2;

	if (!newObjectSet && curObject != noone){ // Camera movement when locked onto an object
		var _newPosition = [0, 0];
		with(curObject){
			_newPosition[X] = x;
			_newPosition[Y] = y;
		}
	
		// Factors in the current offset of the camera shake to avoid any weird bugs with deadzone
		// boundaries.
		var _deadZone = deadZoneRadius;
	
		// Horizontal camera movement
		if (x < _newPosition[X] - _deadZone){ // Moving the camera to the left
			x = _newPosition[X] - _deadZone;
			shakeCenter[X] = x; // Update the camera shake's origin point's X position
		} else if (x > _newPosition[X] + _deadZone){ // Moving the camera to the right
			x = _newPosition[X] + _deadZone;
			shakeCenter[X] = x; // Update the camera shake's origin point's X position
		}
		// Vertical camera movement
		if (y < _newPosition[Y] - _deadZone){ // Moving the camera upward
			y = _newPosition[Y] - _deadZone;
			shakeCenter[Y] = y; // Update the camera shake's origin point's Y position
		} else if (y > _newPosition[Y] + _deadZone){ // Moving the camera downward
			y = _newPosition[Y] + _deadZone;
			shakeCenter[Y] = y; // Update the camera shake's origin point's Y position
		}
	} else{ // Camera movement when unlocked or moving to followed object
		var _moveSpeed = moveSpeed * global.deltaTime;
		// Smooth horizontal movement
		targetFraction[X] += (targetPosition[X] - x) * _moveSpeed;
		if (abs(targetFraction[X]) >= 1){ // Prevents any half-pixel movement on the x-axis.
			var _amountToMove = floor(targetFraction[X]);
			targetFraction[X] -= _amountToMove;
			x += _amountToMove;
		}
		// Smooth vertical movement
		targetFraction[Y] += (targetPosition[Y] - y) * _moveSpeed;
		if (abs(targetFraction[Y]) >= 1){ // Prevents any half-pixel movement on the y-axis.
			var _amountToMove = floor(targetFraction[Y]);
			targetFraction[Y] -= _amountToMove;
			y += _amountToMove;
		}
	
		// Check if the camera has reached its final position. Reset fraction variables and lock position if so
		var _ignoreCheck = (x < _halfWidth || y < _halfHeight ||  x > _halfWidth + room_width || y > _halfHeight + room_height);
		if (_ignoreCheck || point_distance(x, y, targetPosition[X], targetPosition[Y]) < moveSpeed){
			x = targetPosition[X];
			y = targetPosition[Y];
			targetFraction = [0, 0];
			// Reset the flag for moving to a newly followed object to return to default movement
			if (curObject != noone){
				newObjectSet = false;
			}
			_positionReached = true;
		}
	
		// When the camera is unlocked the shake's origin point will always be the center of the screen
		shakeCenter[X] = x;
		shakeCenter[Y] = y;
	}

	// Horizontal boundaries
	if (x < _halfWidth){ // Preventing the camera from passing the left bounds of the room
		x = _halfWidth;
		shakeCenter[X] = x; // Update the shake's center point
	} else if (x > room_width - _halfWidth){ // Preventing the camera from passing the right bounds of the room
		x = room_width - _halfWidth;
		shakeCenter[X] = x; // Update the shake's center point
	}
	// Vertical boundaries
	if (y < _halfHeight){ // Preventing the camera from passing the top bounds of the room
		y = _halfHeight;
		shakeCenter[Y] = y; // Update the shake's center point
	} else if (y > room_height - _halfHeight){ // Preventing the camera from passing to bottom bounds of the room
		y = room_height - _halfHeight;
		shakeCenter[Y] = y; // Update the shake's center point
	}

	// Finally, after moving the camera to its next position for the frame, offset its position relative to the
	// current strength of the camera shake if one exists.
	if (shakeMagnitude > 0){
		x = shakeCenter[X] - random_range(-shakeMagnitude, shakeMagnitude);
		y = shakeCenter[Y] - random_range(-shakeMagnitude, shakeMagnitude);
		shakeMagnitude -= (shakeStrength / shakeLength) * global.deltaTime;
	}

	// After moving the camera to a new postiion; update the view matrix
	camera_set_view_mat(cameraID, matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0));

	// Returns either true or false to let the cutscene know that the camera has reached its necessary
	// position, which will allow the cutscene to move onto the next instruction
	return _positionReached;
}