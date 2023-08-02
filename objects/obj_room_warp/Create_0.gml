#region Variable initialization

// Variables that determine the destination of the warp, which are utilized when Samus collides with said warp
// inside of a given room. The top two values will determine the position Samus is set to and the final value
// determines the room to move Samus to.
targetX = 0;
targetY = 0;
targetRoom = ROOM_INDEX_INVALID;

#endregion