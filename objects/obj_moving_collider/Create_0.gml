#region Unique variable initializations

// Stores the instance ID of the Enemy object that is managing this "immunity area" object. It will utilize this
// ID to retrieve its position to move this instance along with it relative to any offset values.
parentID = noone;

// Determines the offset relative to the "parentID" object's position to place itself at when it updates its
// position to match its parent object's at the end of a given frame.
offsetX = 0;
offsetY = 0;

// Determines how fast along the x and y axis the collider will move, respectively.
hspd = 0.0;
vspd = 0.0;

// Unlike entities, the "delta" for the horizontal and vertical velocities during the current frame are stored
// within actual object variables instead of just being local variables. This is required so Samus can be moved
// by the same amounts should she be standing on one of these platforms.
deltaHspd = 0;
deltaVspd = 0;

// Stores the current fractional values from the two "delta" velocity values so the collider only moves by whole
// pixels when required.
hspdFraction = 0.0;
vspdFraction = 0.0;

#endregion