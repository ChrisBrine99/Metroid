// Grab the player's current coordinates within the room AND the camera's coordinates for use in drawing
// certain HUD elements. (The door indicator requires all four values, for example) They are grabbed here
// for faster overall performance of this event.
var _cameraID, _playerX, _playerY, _cameraX, _cameraY;
_cameraID = CAMERA.camera.ID;
_playerX = PLAYER.x;
_playerY = PLAYER.y;
_cameraX = camera_get_view_x(_cameraID);
_cameraY = camera_get_view_y(_cameraID);

// Render all currently existing menu instances here; looping through them in the order that they were created
// and added into said instance list. This means that the earliest created menu will be rendered below the next
// menu, and so on until the list has all been rendered.
var _length = ds_list_size(global.menuInstances);
for (var i = 0; i < _length; i++){
	with(global.menuInstances[| i]) {draw_gui();}
}

// Process all singleton structs that contain a Draw GUI event; rendering them to the screen when and how they
// would if they were standard GML objects. The order here is important and determines what will be drawn on
// top of what, and vice versa.
with(TEXTBOX_HANDLER)	{draw_gui(camera_get_width(), camera_get_height());}
with(CONTROL_INFO)		{draw_gui();}

// Renders a screen covering rectangle in the desired color and transparency whenever a screen fade effect has
// been created and is currently executing.
with(SCREEN_FADE) {draw_gui(_cameraX, _cameraY);}

// FOR DEBUGGING
//with(DEBUGGER) {draw_gui();}