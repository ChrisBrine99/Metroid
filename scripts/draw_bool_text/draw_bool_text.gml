/// @description Return a boolean as being either "True", "False", "On", "Off", or anything the user wants.
/// @param boolVal
/// @param trueValStr
/// @param falseValStr

var boolVal, trueValStr, falseValStr;
boolVal = bool(argument0);
trueValStr = argument1;
falseValStr = argument2;

if (boolVal) {return trueValStr;}
else {return falseValStr;}