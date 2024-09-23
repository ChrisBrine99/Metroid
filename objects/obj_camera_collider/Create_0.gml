visible = false;

// Determines how the view reacts initially to the followed object entering this collider. The first two values
// determine the viewport's target x and y position within the room (The camera's true position is near the middle
// of said viewport), and the final value determines how fast the camera will move relative to the base speed of
// its base manual horizontal and vertical movement speeds.
viewTargetX = -1;
viewTargetY = -1;
camMoveSpeed = 1.0;

// Determines the camera's valid positions along the x axis while the camera's followed object is within this
// collider's bounding box. The viewport will not exceed these values.
viewMinX = -1;
viewMaxX = -1;

// The same that occurs for the viewport's x axis also applies to its y axis, and these variables will determine
// the valid region that the camera can position the viewport at while the followed object is colliding with the
// bounding box of this collider.
viewMinY = -1;
viewMaxY = -1;

// A boolean value that will toggle the camera's flag for ignoring boundaru limits for the object until the camera
// viewport ccompletely enters the boundary's dimensions.
ignoreBoundsUntilCamInside = false;