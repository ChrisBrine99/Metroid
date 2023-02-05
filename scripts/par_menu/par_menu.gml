/// @description 

#region Initializing any macros that are useful/related to par_menu

// A macro value that determines how many "frames" the highlighted option will be its highlighted color
// before it swaps over to the default color for that same number of frames; repreating indefinitely. The
// "frame" in this case is equal to 1/60th of a second of real-time.
#macro	OPTION_FLASH_INTERVAL		8

#endregion

#region Initializing enumerators that are useful/related to par_menu
#endregion

#region Initializing any globals that are useful/related to par_menu
#endregion

#region The main object code for par_menu

function par_menu() constructor{
	// Much like Game Maker's own object_index variable, this will store the unique ID value provided to this
	// object by Game Maker during runtime; in order to easily use it within the menu management system.
	object_index = par_menu;
	
	// Stores the important state information for the current menu; the currently executing state function,
	// the value that the current state SHOULD be, (AKA the "nextState" variable) and finally the index for
	// the previous state's function in case it needs to be referenced within another state.
	curState = NO_STATE;
	nextState = NO_STATE;
	lastState = NO_STATE;
	
	// Stores the current state for the menu's animation, which will overwrite any non-animation state code
	// from being run by the menu. Once the animation has been completed, these variables should be cleared
	// out to the below values within each animation function. Otherwise, normal state code will never run 
	// since "animationState" would never equal NO_STATE.
	animationState = NO_STATE;
	animationStateArgs = array_create(0, 0);
	
	// Much like the variables that are responsible for storing the animation state and any of its required
	// arguments, these two variables will do the same, but for the optional function that can be set to
	// call when the animation state has completed its execution.
	animationEndFunction = NO_STATE;
	animationEndFunctionArgs = array_create(0, 0);
	
	// Important variables for keeping track of certain menu option states. The first variable is the option
	// that is currently being highlighted by the user through the menu's cursor. The second is the index for
	// the selected option if the user has selected one. Finally, the third option stores another option that
	// should be selected after the selOption variable already has a valid index.
	curOption = 0;
	selOption = -1;
	auxSelOption = -1;
	
	// The flag that determines if the option is currently in its highlighted state or its default state;
	// said flag flipping whenever the highlight timer variable below hits a set interval of frames.
	highlightOption = false;
	highlightTimer = 0;
	
	// Stores the dimensions of the menu in terms of total columns (menuWidth) and rows (menuHeight) it has.
	// The width value isn't normally changed after the menu's initialization, but the height in updated on
	// the fly relative to the total amount of options.
	menuWidth = 0;
	menuHeight = 0;
	
	// These three variables control the visible region of menu options on the y-axis. The first value determines
	// how many rows will be shown at any given time to the player; the second is the offset of the visible
	// region relative to the topmost row in the menu; and finally the shift offset determines how far the
	// cursor needs to be from the top and bottom edges of the visible menu region before the visible region
	// is shifted.
	numVisibleRows = 0;
	firstRowOffset = 0;
	rowShiftOffset = 0;
	
	// Much like above, the three variables below handle the how the view for the menu shifts around as the
	// player moves the cursor around, and how many options are visible at any given time. However, these
	// values are for the x-axis and handle logic for all columns in the menu.
	numVisibleColumns = 0;
	firstColumnOffset = 0;
	columnShiftOffset = 0;
	
	// A flag that allows the program to know the activity status of a given menu. If it's set to false, no
	// step event logic will be run, but it will still be rendered onto the screen if its alpha level isn't 
	// set to 0. Otherwise, it will have its step event logic running every frame as normal whenever active.
	isMenuActive = true;
	
	// A group of boolean values that store the states for all menu inputs during a given frame; setting to
	// either true or false depending on what the "menu_get_input" function gets from GML's keyboard/gamepad
	// input processing functions. The "FileDelete" input is unique to the load game menu, but is grouped here
	// for simplicity and better readability.
	inputRight = false;
	inputLeft = false;
	inputUp = false;
	inputDown = false;
	inputAuxRight = false;
	inputAuxLeft = false;
	inputSelect = false;
	inputReturn = false;
	inputFileDelete = false;
	
	// A final boolean value for menu input that is for an optional return key; useful for allowing a menu
	// open input also be the closing input for that menu. (Ex. Inputs for opening the "Item," "Notes," and
	// "Map" sections of the inventory will also close them through this variable pair) The second variable
	// stores the integer value for the input code.
	inputAuxReturn = false;
	auxReturnIndex = -1;
	
	// Variables that handle the auto-scrolling that is possible to do with the menu cursor by holding down
	// any of the four direction keys. The timer is how many delta frames (60 = 1 second of real-world time)
	// it will take for the autoscroll to occur. The first flag tells the movement function whether or not
	// to actually initialize the autoscrolling. Finally, the last flag will be set to true when the auto
	// scroll logic should be ran by the menu.
	autoScrollTimer = 0;
	isAutoScrolling = false;
	moveMenuCursor = false;
	
	// A simple string variable that stores the text that will be displayed for the game's title. The function
	// that automatically renders this string will contain alignment, font, positioning, transparency, and 
	// color arguments to save on memory.
	title = "";
	
	// These two list variables store the information about a menu's given option or an option's infomation
	// data, respectively. There are also default rendering functions to display the required information from
	// these lists; just like how the title has its own function for rendering as well.
	optionData = ds_list_create();
	optionInfoData = ds_list_create();
	
	// A simple variable that ranges from 0 to 1 which handles the overall transparency of the menu and its
	// elements that are drawn within its "menu_draw_gui" function. It can be easily manipulated through
	// animation states, and any other desired place in the code.
	alpha = 0;

	/// @description An empty function that is called automatically by the function "instance_create_menu_struct".
	/// This allows the code for creating a given menu to be less cluttered with variables that are adjusted
	/// on a per-menu bases like the options, info, title, menu dimensions, and so on.
	initialize = function() {}

	/// @description Code that should be placed into the "Step" event of whatever object is controlling this
	/// par_menu struct OR any of its children. In short, it is ran every frame and executes the current 
	/// animation state OR the state that it is current in at the moment if there is no animation state being
	/// executed. THe main state code is only ran if the menu is considered active.
	step = function(){
		// If there is a valid animation state that is currently active, it will be run on each game frame
		// until the conditions are met for the animation's completetion. After that, the state data will be 
		// cleared from the variables and the step event will function normally.
		if (animationState != NO_STATE){
			if (script_execute_ext(animationState, animationStateArgs) && animationEndFunction != NO_STATE){
				script_execute_ext(animationEndFunction, animationEndFunctionArgs);
				animationEndFunction = NO_STATE;
				animationEndFunctionArgs = array_create(0, 0);
			}
			return; // Exit the script early to prevent the menu's input and state code to be updated.
		}
		
		// Don't allow a given menu to process its step event logic (Input and state code) if the flag for
		// the menu's active state is set to false.
		if (!isMenuActive) {return;}
		
		// The logic that will flip the currently highlighted option's colors between the highlight colors
		// and the option's default colors. This is based on a macro value containing the interval for the
		// flashing frequency.
		highlightTimer -= DELTA_TIME;
		if (highlightTimer <= 0){
			highlightTimer = OPTION_FLASH_INTERVAL;
			highlightOption = !highlightOption;
		}
		
		// Grab the input from the player using whatever their currently active control method is; either
		// keyboard or mouse. Then, process that input to play menu sound effects, and handle selecting
		// options/moving the cursor around the menu.
		get_input();
		handle_input();
		
		// Only attempt to execute the menu's current state if there is a valid index number stored within 
		// the state variable. Otherwise, the function call will result in a crash.
		if (curState != NO_STATE) {curState();} 
	}
	
	/// @description Code that should be placed into the "End Step" event of whatever object is controlling
	/// par_menu or any of its children. In short, it handles updating the current state for the textbox to 
	/// the new state if one was set in the frame.
	end_step = function(){
		if (curState != nextState) {curState = nextState;}
	}
	
	/// @description Code that should be placed into the "End Step" event of whatever object is controlling
	/// par_menu or its children. In this struct, it's empty, but all menu object inherit and use the function
	/// to render their information to the screen.
	draw_gui = function() {}
	
	/// @description Code that should be placed into the "Cleanup" event of whatever object is controlling
	/// par_menu or its children. In short, it will cleanup any data that needs to be freed from memory that 
	/// isn't collected by Game Maker's built-in garbage collection handler.
	cleanup = function(){
		// Delete the titleData struct and then clear its pointer from the variable.
		delete titleData;
		titleData = noone;
		
		// Loop through all of the option structs and free them from memory when the menu is called to close.
		var _length = ds_list_size(optionData);
		for (var i = 0; i < _length; i++) {delete optionData[| i];}
		ds_list_destroy(optionData);
		
		// Next, loop through all the option info structs and perform the same memory clearing as with the
		// menu option structs that were cleared in the chunk of code above.
		_length = ds_list_size(optionInfoData);
		for (var j = 0; j < _length; j++) {delete optionInfoData[| j];}
		ds_list_destroy(optionInfoData);
	}
	
	/// @description Gathers input for the menu's default input variables from either the keyboard or the 
	/// gamepad depending on which one is considered the active controller by the game.
	get_input = function(){
		if (!global.gamepad.isActive){ // Gathering Keyboard Input
			inputRight =		keyboard_check(global.settings.keyMenuRight);
			inputLeft =			keyboard_check(global.settings.keyMenuLeft);
			inputUp =			keyboard_check(global.settings.keyMenuUp);
			inputDown =			keyboard_check(global.settings.keyMenuDown);
			inputAuxRight =		keyboard_check_pressed(global.settings.keyAuxMenuRight);
			inputAuxLeft =		keyboard_check_pressed(global.settings.keyAuxMenuLeft);
			
			inputSelect =		keyboard_check_pressed(global.settings.keySelect);
			inputReturn =		keyboard_check_pressed(global.settings.keyReturn);
			if (auxReturnIndex != -1) {inputAuxReturn = keyboard_check_pressed(auxReturnIndex);}
			
			inputFileDelete =	keyboard_check_pressed(global.settings.keyFileDelete);
		} else{ // Gathering Controller Input
			var _deviceID = global.gamepad.deviceID;
			inputRight =		gamepad_button_check(_deviceID, global.settings.gpadMenuRight);
			inputLeft =			gamepad_button_check(_deviceID, global.settings.gpadMenuLeft);
			inputUp =			gamepad_button_check(_deviceID, global.settings.gpadMenuUp);
			inputDown =			gamepad_button_check(_deviceID, global.settings.gpadMenuDown);
			inputAuxRight =		gamepad_button_check_pressed(_deviceID, global.settings.gpadAuxMenuRight);
			inputAuxLeft =		gamepad_button_check_pressed(_deviceID, global.settings.gpadAuxMenuLeft);
		
			inputSelect =		gamepad_button_check_pressed(_deviceID, global.settings.gpadSelect);
			inputReturn =		gamepad_button_check_pressed(_deviceID, global.settings.gpadReturn);
			if (auxReturnIndex != -1) {inputAuxReturn = gamepad_button_check_pressed(_deviceID, auxReturnIndex);}
			
			inputFileDelete =	gamepad_button_check_pressed(_deviceID, global.settings.gpadFileDelete);
		}
	}
	
	/// @description The function that comes after "menu_get_input" (otherwise it'll be process LAST frame's
	/// input and that's literally unnecessary lag...) and handles all of the keyboard/gamepad input states 
	/// that were grabbed by said previous function. It handles the sound playback of selecting an option,
	/// unselecting an option/exiting a menu, as well as cursor movement from the four directional inputs
	/// for said menu. It doesn't handle the auxiliary cursor inputs or the "file delete" input, since those
	/// are specifically to only a few menus unlike the ones handled in the function.
	handle_input = function(){
		// Don't allow any input to be handled if the dimensions of the menu are equal to 0; meaning that
		// either the width or height is currently initialized to 0, which isn't valid.
		if (menuWidth * menuHeight == 0) {return;}
		
		// Pressing either the return key OR the menu's optional auxiliary return key will play the sound
		// effect for closing the menu OR unselecting an option. (Depending on what the return button is
		// currently being used for)
		if (inputReturn || inputAuxReturn){
			// TODO -- Play menu closing/deselecting sound here
			return;
		}
		
		// Much like above, pressing the select key will simply play the sound effect for the menu's given
		// selection sound. After that, it will exit the function to prevent cursor input from being applied.
		if (inputSelect && selOption == -1){
			// TODO -- Play sound for menu selection here
			selOption = curOption;
			return;
		}
		
		// Determine the X and Y magnitudes for input based on the left/right, and the up/down input states,
		// respectively. After that it checks if either have a valid megnitude or either -1 or 1, which then
		// lets the code handle the cursor movement and auto-scrolling by holding a given direction down.
		var _magnitude = [(inputRight - inputLeft), (inputDown - inputUp)];
		if (_magnitude[X] != 0 || _magnitude[Y] != 0){
			// Decrement the autoscroll timer every frame until it reaches 0, which will then process cursor
			// movement for that frame; resetting the timer to either 30 (~0.5 seconds of real-time) or 10
			// (~0.166666....7 seconds of real-time) units depending on if autoscrolling is already happening.
			autoScrollTimer -= DELTA_TIME;
			if (autoScrollTimer <= 0){
				if (isAutoScrolling){ // Autoscrolling it already active, so they will move 3x faster than the first.
					autoScrollTimer = 10;
				} else{ // The initial menu movement after holding down a given direction is slightly slower than the rest.
					isAutoScrolling = true;
					autoScrollTimer = 30;
				}
				
				// Signal to the code below that it should be able to be executed for this frame.
				moveMenuCursor = true;
			}
			
			// If the flag for signalling to the menu to move its cursor is set to false, the function will
			// be exited; processing no possible movement for that frame.
			if (!moveMenuCursor) {return;}
			moveMenuCursor = false; // Instantly set to false again.
			
			// Stores the current value for "curOption" to then check it against itself after all the menu
			// cursor movement logic has been processed. This is used to reset the highlight flicker variables
			// to ensure they will always start off with the highlight being active on an cursor switch.
			var _curOption = curOption;
			
			// Handling horizontal cursor movement; also handling the movement of the current visible region
			// for the menu on the x-axis and wrapping the cursor to the other side of the menu when it is
			// on either the first or last column.
			if (_magnitude[X] != 0){
				var _onFirstColumn, _onLastColumn;
				_onFirstColumn = (curOption % menuWidth == 0);
				_onLastColumn = (curOption % menuWidth == menuWidth - 1);
			
				// Handle the three possible cases for the cursor's movement logic: either it's on the first
				// column and the cursor should move left, which will then wrap it around to the last column;
				// it's on the last column and moving to the right so it does the opposite of the previous
				// case; or it is simply moving to the next neighboring column depending on the magnitude.
				if (_onFirstColumn && _magnitude[X] == -1){
					curOption = min(ds_list_size(optionData) - 1, curOption + menuWidth - 1);
					
					// Fix the visible region x offset dpending on where the position of the last menu option 
					// on that row isn't located on the final column like normal. (which only occurs of the
					// final row of the menu is it's size isn't evenly divisible by the menu's width)
					firstColumnOffset = clamp(firstColumnOffset + menuWidth - numVisibleColumns, 0, curOption % menuWidth - columnShiftOffset);
				} else if (_onLastColumn && _magnitude[X] == 1){
					curOption -= (menuWidth - 1);
					firstColumnOffset = 0;
				} else{
					curOption += _magnitude[X];
					
					// Handle an edge case where the end of the final row is before the menu's final column,
					// which will wrap it back to the first column early if it ever occurs.
					if (_magnitude[X] == 1 && curOption >= ds_list_size(optionData)){
						curOption -= curOption % menuWidth;
						firstColumnOffset = 0;
					}
					
					// Shift the menu's visible region offset for the x-axis depending on what column the 
					// cursor is on relative to the visible region AND the buffer from those edges that 
					// causes the region shift early.
					var _curColumn = curOption % menuWidth;
					if (firstColumnOffset + numVisibleColumns < menuWidth && _curColumn >= firstColumnOffset + numVisibleColumns - columnShiftOffset) {firstColumnOffset++;}
					else if (firstColumnOffset > 0 && _curColumn < firstColumnOffset + columnShiftOffset) {firstColumnOffset--;}
				}
			}
			
			// Handling vertical cursor movement; also handling the movement of the current visible region
			// for the menu on the y-axis and wrapping the cursor to the other side of the menu when it is
			// on either the first or last row.
			if (_magnitude[Y] != 0){
				var _totalOptions = ds_list_size(optionData);
				
				// Much like above, handle the three possible cases for moving the cursor vertically: wrapping
				// from the first row to the last row/second-last row depending on how many elements are on
				// said final row; wrapping from the final option on that column back to the first row; or
				// simply moving the cursor to its next row based on the magnitude's value. (Either 1 or -1)
				if (curOption - menuWidth < 0 && _magnitude[Y] == -1){
					curOption += (menuWidth * floor(_totalOptions / menuWidth));
					if (curOption >= _totalOptions) {curOption -= menuWidth;}

					// Determining the view of the menu based on what row it ends up on relative to the
					// number of elements on the final row. It simply makes sure that the visible region is
					// properly offset to match where the menu cursor wraps around to on the bottom of the menu.
					var _curRow = floor(curOption / menuWidth) + 1;
					firstRowOffset = max(0, min(menuHeight - numVisibleRows, _curRow - rowShiftOffset));
				} else if (curOption + menuWidth >= _totalOptions && _magnitude[Y] == 1){
					curOption = curOption % menuWidth;
					firstRowOffset = 0;
				} else{
					curOption += menuWidth * _magnitude[Y];
					
					// Shift the menu's visible region offset for the y-axis depending on what row the 
					// cursor is on relative to the visible region AND the buffer from those edges that 
					// causes the region shift early.
					var _curRow = floor(curOption / menuWidth);
					if (firstRowOffset + numVisibleRows < menuHeight && _curRow >= firstRowOffset + numVisibleRows - rowShiftOffset) {firstRowOffset++;}
					else if (firstRowOffset > 0 && _curRow < firstRowOffset + rowShiftOffset) {firstRowOffset--;}
				}
			}
			
			// If the menu's highlighted option was changed by horizontal/vertical movement or a combination
			// of both, thehighlight timer should be reset and the highlight should always begin as being
			// applied to said option. Otherwise, the currently highlighted option will be unclear.
			if (curOption != _curOption){
				highlightTimer = OPTION_FLASH_INTERVAL;
				highlightOption = true;
			}
		} else{ // Simply reset all of the cursor updating variables whenever no direction inputs are being held.
			moveMenuCursor = true;
			isAutoScrolling = false;
			autoScrollTimer = 0;
		}
	}
	
	/// @description A simple function that adds an option struct to a menu's given list of option data. The
	/// data within these structs allows them to have unique position values, text, images, and even offset
	/// values that change where the option is positioned while it's highlighted by the menu cursor. The
	/// variable for the menu's current height is updated to reflect any possible change this new option
	/// could cause to the dimensions of the menu.
	/// @param text
	/// @param isActive
	/// @param image
	/// @param imageX
	/// @param imageY
	/// @param canOffsetImage
	add_option = function(_text, _isActive, _image = -1, _imageX = 0, _imageY = 0, _canOffsetImage = false){
		ds_list_add(optionData, {
			// Stores the text information for the menu option, which is drawn at the x and y positions
			// stored in the two above variables in the struct.
			text :			_text,
			
			// Variables that store an option's image information, which is displayed relative to the offset
			// from the option's actual x and y position. (Where the text normally is rendered)
			image :			_image,
			imageX :		_imageX,
			imageY :		_imageY,
			
			// Stores the horizontal offset for the option and all its elements (Text and image) relative to
			// their normal positions. Used mainly for moving a selected option to emphasize that it is the
			// option currently highlighted by the user. The target value is what the xOffset will move to
			// on a per-frame basis until it reaches said target.
			xOffset :		0,
			xOffsetTarget : 0,
			
			// Stores the vertical offset for the option and all its elements (Text and iamge) relative to
			// their normal positions on the screen; much like the two variables above. The target value
			// functions the same as the horizontal's target variable as well.
			yOffset :		0,
			yOffsetTarget : 0,
			
			// A flag that can prevent the image from being affected by the x and y offset positions; allowing
			// it to remain in its initial position relative to the option's actual coordinates.
			offsetImage :	_canOffsetImage,
			
			// A simple flag that lets the commanding menu know if this option is currently active or not.
			// If it isn't active the option will unable to be selected and thus cannot activate its logic.
			// Otherwise, the option will function as it should.
			isActive :		_isActive,
			
			/// @description A function that will render an option's image to the screen at the coordinates
			/// that are stored within its "imageX" and "imageY" variables; optionally offset if the image
			/// should be offset along with the option's text.
			/// @param color
			/// @param alpha
			option_draw_icon : function(_color, _alpha){
				if (image != -1){ // Only display an image with a valid sprite index value
					if (offsetImage)	{draw_sprite_ext(image, 0, imageX + xOffset, imageY + yOffset, 1, 1, 0, _color, _alpha);}
					else				{draw_sprite_ext(image, 0, imageX, imageY, 1, 1, 0, _color, _alpha);}
				}
			},
		});
		menuHeight = ceil(ds_list_size(optionData) / menuWidth);
	}
	
	/// @description Removes an option struct from the given index; shifting the indexes of all option structs
	/// that are found after the index down by a value of one. After that, the menu height value is updated
	/// based on the new amount of options in the list relative to the width of the menu.
	/// @param index
	delete_option = function(_index){
		// Prevent the function from deleting from indexes of the list that don't actually exist and would
		// result in a crash if they were attempted to be deleted.
		if (_index < 0 || _index >= ds_list_size(optionData)) {return;}
		
		// First, delete the struct's pointer; freeing up its memory. Then, delete the freed pointer value
		// from the list and update the menu height value to match the potential change from delete the option.
		delete optionData[| _index];
		ds_list_delete(optionData, _index);
		menuHeight = ceil(ds_list_size(optionData) / menuWidth);
	}
	
	/// @description Much like the function above for adding a menu option to the respective option list;
	/// this function will do the same but for the menu's option information data instead. This information
	/// can have a unique position on the screen along with the aforementioned info text and even a unique
	/// string that is displayed whenever the paired option is inactive.
	/// @param x
	/// @param y
	/// @param infoText
	/// @param inactiveInfoText
	add_option_info = function(_x, _y, _infoText, _inactiveInfoText = ""){
		ds_list_add(optionInfoData, {
			// Much like Game Maker's built-in "x" and "y" variables for its objects, these two variables
			// store the position of the option on the screen; provided to it by the argument fields for
			// this function.
			x : _x,
			y : _y,
			
			// These two variables will store the option info's default displayed text and the text that will
			// only be shown if the paired option is currently inactive. Otherwise, it can just be set to an
			// empty string since it will never be shown to the user.
			defaultText :	_infoText,
			inactiveText :	_inactiveInfoText,
		});
	}
	
	/// @description This function operates on the exact same principles as the deletion function for the
	/// option deletion function. However, it handles the deletion of data from within the option info list
	/// instead of the normal option list.
	/// @param index
	delete_option_info = function(_index){
		// Prevent the function from deleting from indexes of the list that don't actually exist and would
		// result in a crash if they were attempted to be deleted.
		if (_index < 0 || _index >= ds_list_size(optionData)) {return;}
		
		// Simply delete the option info struct from the given index; removing that index from the master
		// list after that has been completed, so it isn't accidentally used after said deletion.
		delete optionInfoData[| _index];
		ds_list_delete(optionInfoData, _index);
	}
	
	/// @description A simple function that draws the menu's title at the provided coordinates; along with the
	/// provided text and text outline colors. On top of that, the alignment of the text relative to its set
	/// coordinates can also be altered.
	/// @param x
	/// @param y
	/// @param font
	/// @param hAlign
	/// @param vAlign
	/// @param alpha
	/// @param color
	/// @param outlineColor
	draw_title = function(_x, _y, _font, _hAlign = fa_left, _vAlign = fa_top, _alpha = 1, _color = HEX_WHITE, _outlineColor = RGB_GRAY){
		draw_set_text_align(_hAlign, _vAlign); // Set the desired horizontal and vertical text alignments.
		outline_set_font(_font);
		draw_text_outline(_x, _y, title, _color, _outlineColor, _alpha);
		draw_reset_text_align(); // Reset those alignments to prevent issues outside of the function.
	}
	
	/// @description A function that allows a menu to have a default means of rendering its options to the
	/// screen for the player to view. It will loop through all of the indexes for options found within the
	/// visible region of the menu; rendering all of their text and images to the screen at the calculated
	/// coordinates if they should be shown in the menu.
	/// @param x
	/// @param y
	/// @param spacingX
	/// @param spacingY
	/// @param font
	/// @param hAlign
	/// @param vAlign
	/// @param alpha
	draw_options = function(_x, _y, _spacingX, _spacingY, _font, _hAlign = fa_left, _vAlign = fa_top, _alpha = 1){
		// First, set the text alignment and font to match what is needed for a given menu's option styling.
		draw_set_text_align(_hAlign, _vAlign);
		outline_set_font(_font);
		
		// Store the variables that are used by the menu to track where the cursor currently is, as well as
		// what has actually been selected by the player. (Which can be two options at any given time if needed)
		var _curOption, _selOption, _auxSelOption, _highlightOption;
		_curOption = curOption;
		_selOption = selOption;
		_auxSelOption = auxSelOption;
		_highlightOption = highlightOption;
		
		// Begin looping from the top-left option for the currently visible region (Found at the coordinates
		// [firstRowOffset, firstColumnOffset] of the menu relative to its global dimensions) and renders all
		// possible options from that position all the way to the bottom-right corner or the closest the loop
		// can get to that. (The final option is either the last in the menu or at the coordinates
		// [firstRowOffset + numVisibleColumns, firstColumnOffset + numVisibleColumns]; depending on what
		// ends up being the smaller of the two values)
		var _xx, _yy, _length, _optionIndex;
		_xx = _x;
		_yy = _y;
		_length = ds_list_size(optionData);
		for (var yy = firstRowOffset; yy < firstRowOffset + numVisibleRows; yy++){
			for (var xx = firstColumnOffset; xx < firstColumnOffset + numVisibleColumns; xx++){
				// Calculate the current option to render based on the yy and xx values from the two for
				// loops used for this rendering algorithm. If this value exceeds the total number of options
				// in the menu, it will break out of this inner loop and set the outer loop to end as well by
				// setting its yy value to the "<" condition's value.
				_optionIndex = (yy * menuWidth) + xx;
				if (_optionIndex >= _length){
					yy = firstRowOffset + numVisibleColumns;
					break; // Exits this inner loop instantly
				}
				
				// If the option's index was within the bounds of the option list's size, the loop will jump
				// into the scope of the option struct at that index and render its image and text data with
				// a certain colour hue depending on what "state" the option is in relative to the menu's 
				// cursor, what has been selected, and so on.
				with(optionData[| _optionIndex]){
					// If the option isn't currently active, its image and text will be drawn in a blacked-out
					// hue to signify it isn't active; no matter if the cursor is supposed to be highlighting the
					// option or not relative to the curOption value.
					if (!isActive){
						option_draw_icon(HEX_GRAY, _alpha);
						draw_text_outline(_xx + xOffset, _yy + yOffset, text, HEX_GRAY, RGB_DARK_GRAY, _alpha);
						continue; // Skip the rest of the logic in the loop; instantly moving to the next iteration.
					}
					
					// If the option was selected by some auxiliary method that is required outside of the standard
					// menu input handling, (Ex. combining items for crafting, and so on) it will be coloured with
					// a red hue; overwriting both the default selection color and the cursor highlight color.
					if (_optionIndex == _auxSelOption){
						option_draw_icon(HEX_LIGHT_RED, _alpha);
						draw_text_outline(_xx + xOffset, _yy + yOffset, text, HEX_LIGHT_RED, RGB_DARK_RED, _alpha);
						continue; // Skip the rest of the logic in the loop; instantly moving to the next iteration.
					}
					
					// Much like above, this overwrites the normal option colors with a new highlight hue, but
					// a green hue instead of the red to signify this is a selected option through standard means.
					if (_optionIndex == _selOption){
						option_draw_icon(HEX_LIGHT_GREEN, _alpha);
						draw_text_outline(_xx + xOffset, _yy + yOffset, text, HEX_LIGHT_GREEN, RGB_DARK_GREEN, _alpha);
						continue; // Skip the rest of the logic in the loop; instantly moving to the next iteration.
					}
					
					// If the option is currently highlighted by the menu's cursor by the user, it will tint both
					// the image AND text in a yellow hue; light yellow for the image blending and text, with a
					// dark yellow for the text's outline color.
					if (_optionIndex == _curOption && _highlightOption){
						option_draw_icon(HEX_LIGHT_YELLOW, _alpha);
						draw_text_outline(_xx + xOffset, _yy + yOffset, text, HEX_LIGHT_YELLOW, RGB_DARK_YELLOW, _alpha);
						continue; // Skip the rest of the logic in the loop; instantly moving to the next iteration.
					}
					
					// The default way that a menu option's image and text are rendered to the screen, which uses
					// the standard text colors of white with a gray outlining. The image is also rendered without
					// any blending done to its normal colors. (Uses "c_white" because "HEX_WHITE" isn't actually
					// white, but an "off-white" coloring)
					option_draw_icon(c_white, _alpha);
					draw_text_outline(_xx + xOffset, _yy + yOffset, text, HEX_WHITE, RGB_GRAY, _alpha);
				}
				
				// Shift the x-position offset by the value provided in the function X spacing argument space,
				// which as its name suggests determines how far apart each visible option is on the X-axis.
				_xx += _spacingX;
			}
			
			// Outside of the inner loop will be when the x offset value is reset and the y-position offset
			// is incremented based on the same principles as the x spacing argument value, but for the y
			// axis instead.
			_yy += _spacingY;
			_xx = _x;
		}
		
		// Finally, reset the text alignment to prevent any issues with text drawing that occurs outside of
		// this function, since it will most likely not use the option alignment values if they don't happen
		// to be the "fa_left" and "fa_top" defaults.
		draw_reset_text_align();
	}
	
	/// @description A simple function that renders the currently highlighted option's info to the screen at
	/// its stored coordinates. Depending on if the option is active or not will determine what information
	/// is shown to the player.
	/// @param index
	/// @param font
	/// @param hAlign
	/// @param vAlign
	/// @param alpha
	draw_option_info = function(_index, _font, _hAlign = fa_left, _vAlign = fa_top, _alpha = 1){
		// First, ensure that the option info will be rendered with the proper text alignment and font choice.
		draw_set_text_align(_hAlign, _vAlign);
		outline_set_font(_font);
		
		// Before jumping into the option info struct's scope, grab its matching option struct's flag for the
		// option's active state. This will determine whether or not the "active" or "inactive" info will be
		// shown to the player.
		var _isActive = optionData[| _index].isActive;
		with(optionInfoData[| _index]){
			if (_isActive)	{draw_text_outline(x, y, defaultText, HEX_WHITE, RGB_GRAY, _alpha);}
			else			{draw_text_outline(x, y, inactiveText, HEX_RED, RGB_DARK_RED, _alpha);}
		}
		
		// Finally, reset the text alignment to prevent any issues with text drawing that occurs outside of
		// this function, since it will most likely not use the option alignment values if they don't happen
		// to be the "fa_left" and "fa_top" defaults.
		draw_reset_text_align();
	}
	
	/// @description Assigns an animation state to the menu, which will take priority over the logic contained
	/// within the current object state that the menu may be in. Once the animation has met its desired
	/// ending conditions, an optional ending function can be called before the menu's current object state
	/// code resumes execution.
	/// @param {Function}	animationState
	/// @param {Array}		animationStateArgs
	/// @param {Function}	completionFunction
	/// @param {Array}		completionFunctionArgs
	set_animation_state = function(_animationState, _animationStateArgs, _animationEndFunction = NO_STATE, _animationEndFunctionArgs = array_create(0)){
		var _animationFunction = method_get_index(_animationState);
		// Only set the animation state up if a valid function was provided AND the "state arguments" array
		// variable actually being an array of data; otherwise the animation code will crash the program.
		if (_animationFunction != NO_STATE && is_array(_animationStateArgs)){
			animationState =		method_get_index(_animationState);
			animationStateArgs =	_animationStateArgs;
			// Much like the code above, only accept and set the completion function and its respective 
			// argument array is the value provided is a valid index for a method in the menu's code, and 
			// that the argument array is actually an array; otherwise the program will crash.
			if (_animationEndFunction != NO_STATE && is_array(_animationEndFunctionArgs)){
				animationEndFunction =		method_get_index(_animationEndFunction);
				animationEndFunctionArgs =	_animationEndFunctionArgs;
			}
		}
	}
	
	/// @description alphaTarget A simple animation function that fades the menu's alpha level towards a 
	/// given level that is provided in the first argument space. The second argument's value simply 
	/// determines the speed that the alpha level will reach the supplied target value in increments of 
	/// 1/60th of a second.
	/// @param alphaSpeed
	static menu_animation_alpha = function(_alphaTarget, _alphaSpeed){
		if (alpha == _alphaTarget){ // Reset the animation state variables once the animation condition has been met.
			animationState = NO_STATE;
			animationStateArgs = array_create(0, 0);
			return true; // Animation has completed; return true to let the menu know that is the case.
		}
		alpha = value_set_linear(alpha, _alphaTarget, _alphaSpeed);
		return false; // Animation hasn't completed; return false so the animation continues.
	}
}

#endregion

#region Global functions related to par_menu
#endregion