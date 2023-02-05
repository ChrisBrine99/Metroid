/// @description Insert summary of this file here.

#region Initializing any macros that are useful/related to obj_debugger

// Condenses the functions calls required for these debugging tools into simply and easy to use macros, as
// opposed to constantly having to type "DEBUGGER.*" for whatever function is needed when testing.
#macro	DEBUG_ADD_LINE				DEBUGGER.debug_add_line
#macro	DEBUG_ADD_MESSAGE			DEBUGGER.debug_add_message

// The constant for the maximum number of debugging messages that can be displayed at the same time by the
// debugger's built-in message system.
#macro	MAX_DEBUG_MESSAGES			5

#endregion

#region Initializing any globals that are useful/related to obj_debugger
#endregion

#region The main object code for obj_debugger

function obj_debugger() constructor{
	// The last that stores all raycast collision lines; displaying them for a specific number of frames
	// before they are cleared from memory. The alpha channel of the lines will lower the closer they are to
	// being deleted.
	linesToDraw = ds_list_create();
	
	// Much like the list for managing debug line structs, this list will be used to manage structs, but
	// these structs will display unique messages supplied to them by their initial function call, instead.
	debugMessages = ds_list_create();
	
	// Variables for displaying the player's current item inventory. The first stores the value to offset
	// the visible region of the inventory, (Only 8 slots are displayed at a single time) and the second is
	// the flag that tells the debugger to render those visible slots on screen or not.
	itemViewOffset = 0;
	showItems = false;
	
	// The flag that tells the debugger whether it should display object collision boxes or not.
	showCollisions = false;
	
	/// @description Code that should be placed into the "End Step" event of whatever object is controlling
	/// obj_debugger. In short, it is ran every frame and checks to see if the player has toggled any of the
	/// debug displays on or off, while also updating the remaining lifespan of each existing line that has
	/// been added to the debug's line display list.
	end_step = function(){
		// Toggling the debugger between showing 8 slots at a given time for the player's current item
		// inventory; this view of 8 is able to be moved through the inventory if there are more slots than
		// that number.
		if (keyboard_check_pressed(vk_i)) {showItems = !showItems;}
		
		// This chunk of code does exactly what was described in the comment above; allows the user to move
		// the viewable region of the item inventory up and down by using the "1" and "2" keys on the number
		// row for down and up the list, respectively.
		if (showItems){
			var _movement = keyboard_check_pressed(vk_1) - keyboard_check_pressed(vk_2);
			if ((_movement == -1 && itemViewOffset > 0) || (_movement == 1 && itemViewOffset < global.curItemInvSize - 8)) {itemViewOffset += _movement;}
		}
		
		// Toggling the rendering of collision bounds for all existing object in the current room, as well
		// as the ranges for given interaction components that are attached to some of those said objects.
		if (keyboard_check_pressed(vk_c)) {showCollisions = !showCollisions;}
		
		// Update all of the currently existing debug lines by reducing their lifespan and removing them
		// from the list and memory if they have ran out their lifespan's value.
		var _linesToDraw, _length;
		_linesToDraw = linesToDraw;
		_length = ds_list_size(linesToDraw);
		for (var i = 0; i < _length; i++){
			with(linesToDraw[| i]){
				curLifespan -= DELTA_TIME;
				// Clears the given debug line from memory; reducing i and _length by one since an index of
				// the list was removed. Otherwise, it will access an invalid index at the end of the list.
				if (curLifespan <= 0){
					delete _linesToDraw[| i];
					ds_list_delete(_linesToDraw, i);
					_length--;
					i--;
				}
			}
		}
		
		// Much like the lifespan value updating for all the existing debug line struct objects, the same
		// needs to be done for the lifespan values of the currently existing debug messages that are being
		// shown on the screen to the user.
		var _debugMessages = debugMessages;
		_length = ds_list_size(debugMessages);
		for (var j = 0; j < _length; j++){
			with(debugMessages[| j]){
				// The message will slowly shift out of visibility once its lifespan value has gone below
				// 10% of its initial value (All messages have the same 300 frame lifespan)
				if (curLifespan <= 30) {messageAlpha -= 0.033 * DELTA_TIME;}
				
				// Continue counting down the lifespan values of each message struct until they go below
				// a value of 0, which will cause them to be deleted from the manager list.
				curLifespan -= DELTA_TIME;
				if (curLifespan <= 0){
					delete _debugMessages[| j];
					ds_list_delete(_debugMessages, j);
					_length--;
					j--;
				}
			}
		}
	}
	
	/// @description Code that should be placed into the "Draw" event of whatever object is controlling
	/// obj_debugger. In short, it will display any debug information that exists within the world-space;
	/// like collision boxes, all of the currently existing debug lines that track raycasts, and anything
	/// else that fits the "world-space" criteria.
	draw = function(){
		// Jump into scope of the player object to draw the collision point that will be checked when they
		// attempt to interact with objects in the game world.
		with(PLAYER) {draw_sprite_ext(spr_rectangle, 0, x + lengthdir_x(8, direction), y + lengthdir_y(8, direction) - 6, 1, 1, 0, c_white, 1);}
		
		// Create the local variable for storing the length of a list while a loop is being executed for
		// said loop. (Ex. drawing interactable radiuses and raycast lines will both use this variable)
		var _length;
		
		// If the object collision box rendering flag has been toggled to true, the debugger must go through
		// all required objects and rendering their collision information.
		if (showCollisions){
			draw_set_alpha(0.5); // All interactable radius bounds and bounding boxes are semi-transparent, so set the alpha level as such.
			
			// Grab the camera's coordinates, as well as the current dimensions for the camera's view port.
			// These values will then be used to check if the collision areas for interactables and objects
			// in general are off screen and don't need to be drawn as a result.
			var _cameraX, _cameraY, _cameraWidth, _cameraHeight;
			with(CAMERA){
				_cameraX = x;
				_cameraY = y;
			}
			_cameraWidth = _cameraX + CAM_WIDTH;
			_cameraHeight = _cameraY + CAM_HEIGHT;
			
			// Loop through all of the existing interact components and draw the interact ranges as blue,
			// translucent circles. However, they will not be drawn if it's currently off-screen.
			_length = ds_list_size(global.interactables);
			for (var i = 0; i < _length; i++){
				with(global.interactables[| i]){
					if (x + radius < _cameraX || y + radius < _cameraY || x - radius > _cameraWidth || y - radius > _cameraHeight) {continue;}
					draw_ellipse_color(x - radius, y - radius, x + radius - 1, y + radius - 1, c_blue, c_blue, false);
				}
			}
			
			// This with statement will loop through EVERY currently existing object within the room; drawing
			// a collision box for it at the position of its bounding coordinates within said room. The color
			// of the box will default to gray, but certain object will have unique colors for their boxes
			// (Ex. Static colliders are red, the player's box is green, etc.)
			with(all){
				// If the object doesn't actually have a collision box, (Ex. world objects for items) don't
				// bother drawing a 1x1 square, (Result of having to add 1 to accurately represent an object's
				// collision box) and simply skip to the next object.
				if (mask_index == spr_empty_mask) {continue;}
				
				// Displaying the actually collision box, but only if that collision box is actually visible
				// on the camera. Otherwise, it will be a waste of time to render it, so it will be skipped.
				// If the out of view check fails, the color will be selected and the bounding box will be
				// drawn in the game world using that color information.
				if (bbox_right < _cameraX || bbox_bottom < _cameraY || bbox_left > _cameraWidth || bbox_top > _cameraHeight) {continue;}
				var _color = HEX_GRAY;
				switch(object_index){
					case obj_player:		_color = HEX_GREEN;		break;
					case obj_collider:		_color = HEX_RED;		break;
				}
				draw_sprite_ext(spr_rectangle, 0, bbox_left, bbox_top, (bbox_right - bbox_left) + 1, (bbox_bottom - bbox_top) + 1, 0, _color, 0.5);
			}
		}
		
		// Loop through and draw all of the currently existing debug lines that visualize a raycast's
		// trajectory path. The alpha level of the line is relative to its remaining lifespan, so the closer
		// it is to being removed from memory, the more transparent it will be. The color's for each line are
		// determined by the lines themselves, and not a general color.
		_length = ds_list_size(linesToDraw);
		for (var j = 0; j < _length; j++){
			with(linesToDraw[| j]){
				draw_set_alpha(curLifespan / setLifespan);
				draw_line_color(x, y, endX, endY, color, color);
			}
		}
		draw_set_alpha(1);
	}
	
	/// @description Code that should be placed into the "Draw GUI" event of whatever object is controlling
	/// obj_debugger. In short, it will display text information to the user that could be useful to them
	/// whilst they're debugging their program. Things like the Game State, entity culling performance, and
	/// so on.
	draw_gui = function(){
		// Starting up the outline rendering shader, which will allow all subsequent text to be drawn with a
		// one pixel outline of a given color for style purposes.
		shader_set_outline(RGB_GRAY, font_gui_small);
		
		// Display the current game state and playtime data in the top-left corner of the screen.
		draw_text_outline(5, 5, "Game State: " + game_state_get_name(GAME_STATE_CURRENT) + " (Previously: " + game_state_get_name(GAME_STATE_PREVIOUS) + ")\nIn-Game Time: " + GET_IN_GAME_TIME(), HEX_WHITE, RGB_GRAY, 1);
		
		// Always display entity rendering information on the screen; how many entities have been drawn
		// for the current room view and how many drop shadows have been drawn as well.
		draw_set_halign(fa_right);
		draw_text_outline(CAM_WIDTH - 5, 5, "Drawn Entities: " + string(DEPTH_SORTER.entitiesDrawn) + "\nDrawn Shadows: " + string(DEPTH_SORTER.shadowsDrawn), HEX_WHITE, RGB_GRAY, 1);
		
		// Loop through all of the currently available debug messages and display them to the screen in the
		// order of their creation, which is the newest (index 0) to the oldest message. (index "n")
		draw_set_valign(fa_bottom);
		var _yOffset = 0;
		var _length = ds_list_size(debugMessages);
		for (var i = 0; i < _length; i++){
			with(debugMessages[| i]){
				draw_text_outline(CAM_WIDTH - 5, CAM_HEIGHT - 12 - _yOffset, debugMessage, HEX_WHITE, RGB_GRAY, messageAlpha);
				_yOffset += string_height(debugMessage);
			}
		}
		draw_reset_text_align();
		
		// If the debugger has been told to render the item inventory for easy viewing of the current data
		// held inside of it, the current 8 slots relative to the view offset value will be shown on screen.
		if (showItems){
			var _itemViewOffset = 0;
			for (var j = 0; j < 8; j++){
				_itemViewOffset = itemViewOffset + j;
				
				// Display a default value for the empty item slot, which is just the text "---" next to the
				// relative slot number, which is the _itemViewOffset variables value's with one added.
				if (global.items[_itemViewOffset] == noone){
					draw_text_outline(5, 25 + (j * 10), string(_itemViewOffset + 1) + ": " + NO_ITEM, HEX_WHITE, RGB_GRAY, 1);
					continue;
				}
			
				// If there is an item struct current stored within the slot, the name of that item and its
				// current quantity will be rendered alongside the slot's numerical value.
				with(global.items[_itemViewOffset]){
					draw_text_outline(5, 25 + (j * 10), string(_itemViewOffset + 1) + ": " + itemName, HEX_WHITE, RGB_GRAY, 1);
					draw_text_outline(125, 25 + (j * 10), "x" + string(quantity), HEX_WHITE, RGB_GRAY, 1);
				
					// If the item is currently equipped to the player in some way, (Ex. weapons, armor,
					// amulets, flashlight, and a throwable items) an E will be drawn next to the quantity
					// to show that is the case.
					if (isEquipped) {draw_text_outline(140, 25 + (j * 10), "E", HEX_LIGHT_YELLOW, RGB_DARK_YELLOW, 1);}
				}
			}
		}
		
		with(PLAYER){
			var _key = -1;
			_length = ds_map_size(additionalEffects);
			for (var i = 0; i < _length; i++){
				_key = effectKeys[| i];
				with(additionalEffects[? _key]){
					draw_text_outline(5, 30 + (i * 20), "ID: " + string(_key) + "\nTime: " + string(timeRemaining), HEX_WHITE, RGB_GRAY, 1);
				}
			}
		}
		
		// Reset the shader at the end of the function to prevent anything that is draw after to have the
		// outline shader effect applied to it accidentally.
		shader_reset();
	}
	
	/// @description Code that should be placed into the "Cleanup" event of whatever object is controlling
	/// obj_debugger. In short, it remove any structs, data structures, and other datatypes that allocate 
	/// memory that isn't automatically cleaned up by Game Maker during runtime.
	cleanup = function(){
		// Delete all of the potentially existing debug line structs before destroying the list that 
		// existed to manage said struct objects.
		var _length = ds_list_size(linesToDraw);
		for (var i = 0; i < _length; i++) {delete linesToDraw[| i];}
		ds_list_destroy(linesToDraw);
		
		// Much like above, the same struct deletion will be performed, but for the debug messages that may
		// still exist upon the deletion of this debugger. The manager list is destroy after the structs
		// have been cleared from memory.
		_length = ds_list_size(debugMessages);
		for (var j = 0; j < _length; j++) {delete debugMessages[| j];}
		ds_list_destroy(debugMessages);
	}
	
	/// @description Creates a line that has a set "lifespan"; that lifespan being how many frames it will
	/// be shown to the user for before it begins fading out of visibility. This is mostly useful for
	/// debugging collisions that use some form of hitscan style collision detection, and can also be used
	/// to track the path of an object between two distinct points if necessary.
	/// @param {Real}			startX
	/// @param {Real}			startY
	/// @param {Real}			endX
	/// @param {Real}			endY
	/// @param {Constant.Color}	color
	/// @param {Real}			lifespan
	debug_add_line = function(_startX, _startY, _endX, _endY, _color, _lifespan){
		ds_list_add(linesToDraw, {
			// Create two variables that use the "x" and "y" syntax that Game Maker uses within its own
			// objects. The values here will be the starting coordinates for the line.
			x :				_startX,
			y :				_startY,
							
			// Next, these variables will store the ending cordinates for this given line.
			endX :			_endX,
			endY :			_endY,
							
			// Each line can utilize a unique color so that it can be easily differentiated from other
			// lines that could possibly have been created around the same timeframe; allowing easier parsing
			// of this debugging tool by the user.
			color :			_color,
			
			// Finally, create a variable that will store the current lifespan value as well as the initial
			// value, so that fading out can be done when the line is close to reaching the end of its
			// lifespan.
			curLifespan :	_lifespan,
			setLifespan :	_lifespan,
		});
	}
	
	/// @description Adds a new string that will be displayed onto the bottom-righthand corner of the screen
	/// for debugging purposes. This message will be visible for 5 seconds until it slowly fades out of
	/// visibility. The object that created the message will have its name and ID displayed prior to said
	/// message so it's easier to know where the message came from whilst debugging.
	/// @param {Id.Instance}	objectID
	/// @param {String}			message
	debug_add_message = function(_objectID, _message){
		// There will only ever be five messages max that can be seen at any given time through this debug
		// tool, so the oldest message currently is removed in order to make room for this newly created
		// message.
		if (ds_list_size(debugMessages) == MAX_DEBUG_MESSAGES){
			delete debugMessages[| MAX_DEBUG_MESSAGES - 1];
			ds_list_delete(debugMessages, MAX_DEBUG_MESSAGES - 1);
		}
		
		// Create the string that will be shown on the screen; formatting it so that it contains the name
		// of the object that called this debug function, their unique ID value, and the message itself
		// after all of that information. Then, create the struct that will store the message's data and
		// add it to the map of current messages.
		var _string = string_format_width(object_get_name(_objectID.object_index) + "(" + string(_objectID) + "): " + _message, 240, font_gui_small);
		ds_list_insert(debugMessages, 0, {
			debugMessage :	_string,
			curLifespan :	300,
			messageAlpha :	1,
		});
	}
}

#endregion

#region Global functions related to obj_debugger
#endregion