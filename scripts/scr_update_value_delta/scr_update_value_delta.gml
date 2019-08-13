/// @description Updates a given variables based on the game's delta time value. This script will allow for the
/// changing of any variable to be frame-independent. Ex. counting down timers will still behave like they would
/// if they were being handled at 60 FPS.
/// @param baseVal
/// @param incrementVal

var baseVal, incrementVal;
baseVal = argument0;
incrementVal = argument1;

return baseVal + (incrementVal * global.deltaTime);