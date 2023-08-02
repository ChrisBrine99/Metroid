#region Unique variable initializations

// Stores the instance ID of the Enemy object that is managing this "immunity area" object. It will utilize this
// ID to retrieve its position to move this instance along with it relative to any offset values.
parentID = noone;

// Determines the offset relative to the "parentID" object's position to place itself at when it updates its
// position to match its parent object's at the end of a given frame.
offsetX = 0;
offsetY = 0;

// Toggles effect of Samus's weapons against the collider on (false) and off (true).
isImmunityArea = false;

#endregion