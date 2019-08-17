/// @description Stops the camera from going outside of the room.
/// @param camera
/// @param minX
/// @param minY
/// @param maxX
/// @param maxY

var minX, minY, maxX, maxY;
minX = argument0 + (global.camWidth / 2);	// The left-side camera boundary
minY = argument1 + (global.camHeight / 2);	// The upper camera boundary
maxX = argument2 - (global.camWidth / 2);	// The maximum value the camera's X position can be
maxY = argument3 - (global.camHeight / 2);	// The maximum value the camera's Y position can be

// Make sure the object executing this script is a camera object
if (object_index == obj_camera){
	// Horizontal bounds
	if (x < minX){ // Left side bounds
		x = minX;
	} else if (x > maxX){ // Right side bounds
		x = maxX;
	}
	// Vertical bounds
	if (y < minY){ // Upward bounds
		y = minY;
	} else if (y > maxY){ // Downward bounds
		y = maxY;
	}
}