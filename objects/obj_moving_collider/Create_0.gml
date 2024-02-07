#region Unique variable initializations

// Stores the instance ID of the Enemy object that is managing this "immunity area" object. It will utilize this
// ID to retrieve its position to move this instance along with it relative to any offset values.
parentID = noone;

// Determines the offset relative to the "parentID" object's position to place itself at when it updates its
// position to match its parent object's at the end of a given frame.
offsetX = 0;
offsetY = 0;

// 
hspd	= 0.0;
vspd	= 0.0;

// 
deltaHspd = 0.0;
deltaVspd = 0.0;

// 
hspdFraction = 0.0;
vspdFraction = 0.0;

#endregion