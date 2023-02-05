#region Editing default variables, initializing unique variables, and other important initializations

// Edit some of the object's default variables before any initialization of unique variables occurs.
image_index = 0;
image_speed = 0;

// Determines the effect of a liquid on the player object: how much slower it'll move when submerged in it,
// how long it takes them to accelerate to their submerged maximum hspd and vspd, and how much damage it'll
// deal and how quickly that damage will be dealt.
maxHspdPenalty = 0;
maxVspdPenalty = 0;
hAccelPenalty = 0;
vAccelPenalty = 0;
damage = 0;
damageInterval = 0;

// Variables for the optional wave effect that the liquid can have, which will have it moving up and down at a
// set amplitude and freqency (60 units = 1 second of real-time) relative to its starting y position.
initialY = y;
amplitude = 0;
frequency = 0;

#endregion