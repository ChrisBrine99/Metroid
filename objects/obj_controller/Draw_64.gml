// 
var _width	= display_get_gui_width();
var _height	= display_get_gui_height();

// Call the map manager's "Draw GUI" event, which is responsible for initializing the surface that is used as
// the game's map, updating that surface relative to if the player moves into a new cell or not, and making
// sure the surface containing all this data actually exists.
with(MAP_MANAGER) {draw_gui();}

// Render the game's HUD first; allowing menus, control information, and all other GUI elements to display on
// top of the HUD instead of being obscured by it.
with(GAME_HUD) {draw_gui();}

// Render all currently existing menu instances here; looping through them in the order that they were created
// and added into said instance list. This means that the earliest created menu will be rendered below the next
// menu, and so on until the list has all been rendered.
var _length = ds_list_size(global.menuInstances);
for (var i = 0; i < _length; i++){
	with(global.menuInstances[| i]) {draw_gui(_width, _height);}
}

// Process all singleton structs that contain a Draw GUI event; rendering them to the screen when and how they
// would if they were standard GML objects. The order here is important and determines what will be drawn on
// top of what, and vice versa.
//with(TEXTBOX_HANDLER)	{draw_gui(_width, _height);}
//with(CONTROL_INFO)		{draw_gui();}

// Renders a screen covering rectangle in the desired color and transparency whenever a screen fade effect has
// been created and is currently executing.
with(SCREEN_FADE) {draw_gui(_width, _height);}

// FOR DEBUGGING
with(DEBUGGER) {draw_gui();}