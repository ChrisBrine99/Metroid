// Don't bother trying to update this object's position if it doesn't have a parent object tied to it OR the
// current game state isn't set to "in-game"; preventing any Entity movement.
if (parentID == noone || GAME_CURRENT_STATE != GSTATE_NORMAL) 
	return;

// Grab the position of the parent object and store those values into local variables. Then, the position of the
// immune area instance will be set to those stored values relative to the offset values for said positions.
var _x = 0;
var _y = 0;
with(parentID){
	_x = x;
	_y = y;
}
x = _x + offsetX;
y = _y + offsetY;