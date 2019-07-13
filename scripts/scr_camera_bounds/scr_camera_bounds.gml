/// @description Stops the camera from going outside of the room.
/// @param minX
/// @param minY
/// @param maxX
/// @param maxY

var minX, minY, maxX, maxY;
minX = argument0 + (global.camWidth / 2);
minY = argument1 + (global.camHeight / 2);
maxX = argument2 - (global.camWidth / 2);
maxY = argument3 - (global.camHeight / 2);

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