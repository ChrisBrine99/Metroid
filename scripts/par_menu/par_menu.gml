#region Initializing any macros that are useful/related to par_menu

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

// --- Cursor Substates --- //
#macro	MENU_AUTO_SCROLL			0x08000000
#macro	MENU_MOVE_CURSOR			0x10000000
// --- Option Highlight Substate --- //
#macro	MENU_HIGHLIGHT_OPTION		0x20000000
// --- Main Functionality Substates --- //
#macro	MENU_ACTIVE					0x40000000
#macro	MENU_DESTROYED				0x80000000

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

// --- Cursor Substate Checks --- //
#macro	MENU_IN_AUTO_SCROLL			(stateFlags & MENU_AUTO_SCROLL)
#macro	MENU_CAN_MOVE_CURSOR		(stateFlags & MENU_MOVE_CURSOR)
// --- Option Highlight Substate Check --- //
#macro	MENU_CAN_HIGHLIGHT			(stateFlags & MENU_HIGHLIGHT_OPTION)
// --- Main Functionality Substate Checks --- //
#macro	MENU_IS_ACTIVE				(stateFlags & MENU_ACTIVE)
#macro	MENU_IS_DESTROYED			(stateFlags & MENU_DESTROYED)

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

// --- Menu Cursor Movement Inputs --- //
#macro	MENU_RIGHT					0x00000001
#macro	MENU_LEFT					0x00000002
#macro	MENU_UP						0x00000004
#macro	MENU_DOWN					0x00000008
// --- Menu Manipulation Inputs --- //
#macro	MENU_SELECT					0x00000010
#macro	MENU_RETURN					0x00000020
#macro	MENU_DELETE_FILE			0x00000040
// --- Optional Menu Cursor Movement Inputs --- //
#macro	MENU_AUX_RIGHT				0x00000080
#macro	MENU_AUX_LEFT				0x00000100
// --- Option Menu Manipulation Inputs --- //
#macro	MENU_AUX_SELECT				0x00000200
#macro	MENU_AUX_RETURN				0x00000400

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

// --- Cursor Right Inputs (Hold/Release) --- //
#macro	MENU_RIGHT_HELD				(inputFlags & MENU_RIGHT && prevInputFlags & MENU_RIGHT)
#macro	MENU_RIGHT_RELEASED			(!(inputFlags & MENU_RIGHT) && prevInputFlags & MENU_RIGHT)
// --- Cursor Left Inputs (Hold/Release) --- //
#macro	MENU_LEFT_HELD				(inputFlags & MENU_LEFT && prevInputFlags & MENU_LEFT)
#macro	MENU_LEFT_RELEASED			(!(inputFlags & MENU_LEFT) && prevInputFlags & MENU_LEFT)
// --- Cursor Up Inputs (Hold/Release) --- //
#macro	MENU_UP_HELD				(inputFlags & MENU_UP && prevInputFlags & MENU_UP)
#macro	MENU_UP_RELEASED			(!(inputFlags & MENU_UP) && prevInputFlags & MENU_UP)
// --- Cursor Down Inputs (Hold/Release) --- //
#macro	MENU_DOWN_HELD				(inputFlags & MENU_DOWN && prevInputFlags & MENU_DOWN)
#macro	MENU_DOWN_RELEASED			(!(inputFlags & MENU_DOWN) && prevInputFlags & MENU_DOWN)
// --- Menu Manipulation Inputs (Press) --- //
#macro	MENU_SELECT_PRESSED			(inputFlags & MENU_SELECT && !(prevInputFlags & MENU_SELECT))
#macro	MENU_RETURN_PRESSED			(inputFlags & MENU_RETURN && !(prevInputFlags & MENU_RETURN))
// --- Optional Input [Aux Right] (Hold/Release) --- //
#macro	MENU_AUX_RIGHT_HELD			(inputFlags & MENU_AUX_RIGHT && prevInputFlags & MENU_AUX_RIGHT)
#macro	MENU_AUX_RIGHT_RELEASED		(!(inputFlags & MENU_AUX_RIGHT) && prevInputFlags & MENU_AUX_RIGHT)
// --- Optional Input [Aux Left] (Hold/Release) --- //
#macro	MENU_AUX_LEFT_HELD			(inputFlags & MENU_AUX_LEFT && prevInputFlags & MENU_AUX_LEFT)
#macro	MENU_AUX_LEFT_RELEASED		(!(inputFlags & MENU_AUX_LEFT) && prevInputFlags & MENU_AUX_LEFT)
// --- Optional Inputs [Aux Select/Return] (Press) --- //
#macro	MENU_AUX_SELECT_PRESSED		(inputFlags & MENU_AUX_SELECT && prevInputFlags & MENU_AUX_SELECT)
#macro	MENU_AUX_RETURN_PRESSED		(inputFlags & MENU_AUX_RETURN && prevInputFlags & MENU_AUX_RETURN)

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MENU_OPTION_HLGHT_INTERVAL	8.0
#macro	MENU_FAST_SCROLL_INTERVAL	10.0
#macro	MENU_SLOW_SCROLL_INTERVAL	30.0

#endregion

#region Initializing enumerators that are useful/related to par_menu
#endregion

#region Initializing any globals that are useful/related to par_menu

// Stores all the unique ID values for all of the menu structs that have been created and currently exist
// within memory simultaneously; updating, drawing, and processing all other general events that exist within
// each menu--in order from the oldest existing menu instance to the newest, respectively.
global.menuInstances = ds_list_create();

#endregion

#region The main object code for par_menu

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function par_menu(_index) : base_struct(_index) constructor{
	// Determines what code is actively being executed on during the menu's step event; if there's any
	// function actually being called at all. The variables will store the currently executed function,
	// the function to switch to from the next frame onward, and the last state that was being called.
	curState	= NO_STATE;
	nextState	= NO_STATE;
	lastState	= NO_STATE;
	
	// An array that can be used to add arguments to a menu's state. This is mostly useful for animation
	// states that required certain values that aren't required outside of the functions; making arguments
	// a perfect fit for said problem.
	stateArgs = array_create(0, 0);
	
	// An integer containing 32 unique bits to utilize for a menu's various states that are independent
	// from the function being executed for each game frame. The upper four bits are occupied by general
	// menu state flags, so they cannot be used.
	stateFlags = 0;
	
	// Stores the input data for the current frame, and a snapshot of the input data from the last frame.
	// Used in order to only required one "keyboard_check" call for each input; using "prevInputFlags" to
	// determine if that input was pressed, held, or released for the current frame.
	inputFlags		= 0;
	prevInputFlags	= 0;
	
	// Values that can be adjusted on a per-menu basis to allow for additional inputs to perform certain
	// events in said menu. The auxiliary right and left inputs are unique in that they allow two other
	// inputs to alter some kind of movement in the menu that isn't the cursor, so they're optional.
	auxRightIndex	= -1;
	auxLeftIndex	= -1;
	auxSelectIndex	= -1;
	auxReturnIndex	= -1;
	
	// Stores the index of option that is currently being highlighted by the menu cursor, the option
	// that was selected by the player, and another variable that can store a previously selected option
	// if that is required by the menu.
	curOption		= 0;
	selOption		= -1;
	auxSelOption	= -1;
	
	// Variables that store the given width and current height of the menu. The height is
	// dynamically determined by the current number of options in the menu relative to its
	// given width, which needs to be set explicitly by each menu.
	menuWidth	= 0;
	menuHeight	= 0;
	
	// Determines what region of the menu is visible to the user at the current moment, and
	// how that view will shift based on the position of the cursor, the movement direciton of
	// it, and how far that next option is from the four borders of the visible region relative
	// to the two "shift offset" variables.
	numVisibleRows		= 0;
	numVisibleColumns	= 0;
	firstRowOffset		= 0;
	firstColumnOffset	= 0;
	rowShiftOffset		= 0;
	columnShiftOffset	= 0;
	
	// Timers that the menu utilizes for flashing the currently highlighted option, and for
	// creating a pause between cursor movements whenever a cursor movement direction is held
	// by the player.
	highlightTimer	= 0.0;
	autoScrollTimer = 0.0;
	
	// Variables for the main contents that will exist in all menus; the title and option structs
	// that contain all the necessary information about a given option within said menu.
	title		= "";
	optionData	= ds_list_create();
	
	// Color data for the various states a menu option (And sometimes its visible information) can
	// be found in. There are color pairs for an inactive option (Info as well), a highlighted option,
	// selected, and "stored" selected option, respectively.
	oInactiveInColor		= HEX_GRAY;
	oInactiveOutColor		= RGB_DARK_GRAY;
	oHighlightInColor		= HEX_LIGHT_YELLOW;
	oHighlightOutColor		= RGB_DARK_YELLOW;
	oSelectInColor			= HEX_GREEN;
	oSelectOutColor			= RGB_DARK_GREEN;
	oAuxSelectInColor		= HEX_RED;
	oAuxSelectOutColor		= RGB_DARK_RED;
	oInfoInactiveInColor	= HEX_GRAY;
	oInfoInactiveOutColor	= RGB_DARK_GRAY;
	
	// Determines the visibility of the menu's contents outside of any additional adjustments that can
	// occur on a per-object basis (Ex. title, options, option info, etc.).
	alpha = 0.0;
	
	// Initialize the variable that will store the states  for all dynamic entities prior to this menu's 
	// creation. It will only become a ds_map that stores said data if there  wasn't any menus in existence 
	// prior to this menu's instantiation.
	entityStates = -1;
	if (GAME_CURRENT_STATE != GSTATE_MENU){
		entityStates = ds_map_create(); // Instantiate the list for the menu that is the first in the list.
		var _curState		= NO_STATE;
		var _nextState		= NO_STATE;
		var _lastState		= NO_STATE;
		var _entityStates	= entityStates;
		with(par_dynamic_entity){ // Store all important dynamic entity variables until the menu is closed.
			if (curState == NO_STATE) 
				continue;
				
			_curState	= curState;	// Place into local variables for quick copying into entity state storage struct.
			_nextState	= nextState;
			_lastState	= lastState;
			
			ds_map_add(_entityStates, id, { // Temporary struct to store an entity's stats variables.
				curState	:	_curState,
				nextState	:	_nextState,
				lastState	:	_lastState,
			});
			
			stateFlags |= ENTT_PAUSE_ANIM;
			curState	= NO_STATE;	// Reset all copied variables to their defaults.
			nextState	= NO_STATE;
			lastState	= NO_STATE;
		}
	}
	
	// All menus will change the game state to its menu state, which will temporarily pause all dynamic 
	// entities. They will only be unpaused once all menu instances have been closed, which is determined
	// by checking the size of the global list that manages all these menu structs.
	game_set_state(GSTATE_MENU, true);
	

	/// @description The only non-static function found within the menu object. It's not static like the
	/// rest because it is inherited on a per-object basis in order to render each menu uniquely. For the
	/// parent iteration of this function it is empty.
	/// @param {Real}	width	Stores the width of the GUI surface in pixels.
	/// @param {Real}	height	Stores the height of the GUI surface in pixels.
	draw_gui = function(_width, _height) {}
	
	/// @description Code that should be placed into the "Cleanup" event of whatever object is controlling
	/// par_menu or its children. In short, it will cleanup any data that needs to be freed from memory that 
	/// isn't collected by Game Maker's built-in garbage collection handler. On top of that, it will restore
	/// all dynamic entities back to their previous states.
	cleanup = function(){
		// Loop through all options and delete their contents from memory before deleting the list itself.
		if (ds_exists(optionData, ds_type_list)){
			var _length = ds_list_size(optionData);
			for (var i = 0; i < _length; i++){
				with(optionData[| i]){ // Removes inner structs before the main struct is freed from memory.
					if (!is_undefined(optionInfo)) 
						delete optionInfo;
					delete iconData;
				}
				delete optionData[| i];
			}
			ds_list_clear(optionData);
			ds_list_destroy(optionData);
		}
		
		// Since the entity state storage map is only utilized by the first menu that was created, the rest
		// of the cleanup event's code can be skipped if the menu doesn't have a valid data structure within
		// said variable. The other check will prevent any menu except the last menu from restoring dynamic
		// entities to their previous states while also restoring the game's original state.
		if (!ds_exists(entityStates, ds_type_map) || ds_list_size(global.menuInstances) > 1)
			return;

		// Return all dynamic entities back to their states from before the menu was opened; cleaning up the
		// structs and ds_map that temporarily stored those values for the duration of the menu's existence.
		var _curState	= NO_STATE;
		var _nextState	= NO_STATE;
		var _lastState	= NO_STATE;
		var _key		= ds_map_find_first(entityStates);
		while(!is_undefined(_key)){
			// Grab the copy of the entity states that were stored when the menu was created. Doing this saves
			// the program from having to jump between the entity's scope and the struct's scope multiple times
			// to copy over these variables.
			with(entityStates[? _key]){
				_curState	= curState;
				_nextState	= nextState;
				_lastState	= lastState;
			}
			
			// The key is the id for the instance that the state data belongs to, so it's what is used to jump
			// into said entity's scope. Unfreeze the animation state for all entities alonside state reset.
			with(_key){
				stateFlags &= ~ENTT_PAUSE_ANIM;
				curState	= _curState;
				nextState	= _nextState;
				lastState	= _lastState;

			}
			
			// After copying the data back into the entity, free the struct from memory and move on.
			delete entityStates[? _key];
			_key = ds_map_find_next(entityStates, _key);
		}
		ds_map_clear(entityStates);
		ds_map_destroy(entityStates);
		
		// Restore the game's previous state now that the menu is closed.
		game_set_state(GAME_PREVIOUS_STATE, true);
	}
	
	/// @description Code that executes for every frame that the menu exists. It will execute the state
	/// that is currently assigned to the entity (A value of NO_STATE will cause this line to be ignored).
	/// On top of that, it will also tick down the counter for the menu's highlighted option flashing;
	/// flipping it on and off based on what the previous flag value was.
	static step = function(){
		// Execute the menu's current state function if one has been provided to the instance. If there
		// are arguemnts for the state, it will be called using "script_execute_ext" instead of just calling
		// it outright like a state with no arguments.
		if (curState != NO_STATE){
			if (array_length(stateArgs) == 0) {curState();}
			else {script_execute_ext(curState, stateArgs);}
		}
		
		// Updating the timer that allows the highlighted option to flicker between a unique color for
		// highlighting versus the standard color for all currently visible options.
		highlightTimer -= DELTA_TIME;
		if (highlightTimer <= 0.0){
			highlightTimer	= MENU_OPTION_HLGHT_INTERVAL;
			if (MENU_CAN_HIGHLIGHT)	{stateFlags &= ~MENU_HIGHLIGHT_OPTION;}
			else					{stateFlags |=  MENU_HIGHLIGHT_OPTION;}
		}
	}
	
	/// @description Code that executes at the end of the frame (Prior to any drawing calls). All this
	/// function does is change the entity to its next required state to avoid any mid-frame issues
	/// regarding a potential state swap.
	static end_step = function(){
		if (curState != nextState){
			nextState	= method_get_index(nextState);
			curState	= nextState;
		}
	}
	
	/// @description 
	static process_input = function(){
		inputFlags		= 0;
		prevInputFlags	= inputFlags;
		if (GAMEPAD_IS_ACTIVE){
			return;
		}
		
		// --- Cursor Movement Input Checks --- //
		if (keyboard_check(KEYCODE_MENU_RIGHT))		{inputFlags |= MENU_RIGHT;}
		if (keyboard_check(KEYCODE_MENU_LEFT))		{inputFlags |= MENU_LEFT;}
		if (keyboard_check(KEYCODE_MENU_UP))		{inputFlags |= MENU_UP;}
		if (keyboard_check(KEYCODE_MENU_DOWN))		{inputFlags |= MENU_DOWN;}
		// --- Menu Manipulation Input Checks --- //
		if (keyboard_check(KEYCODE_SELECT))			{inputFlags |= MENU_SELECT;}
		if (keyboard_check(KEYCODE_RETURN))			{inputFlags |= MENU_RETURN;}
		if (keyboard_check(KEYCODE_DELETE_FILE))	{inputFlags |= MENU_DELETE_FILE;}
		// --- Optional Movement Input Checks --- //
		if (auxRightIndex != -1	&& keyboard_check(auxRightIndex))	{inputFlags |= MENU_AUX_RIGHT;}
		if (auxLeftIndex != -1 && keyboard_check(auxLeftIndex))		{inputFlags |= MENU_AUX_LEFT;}
		// --- Optional Menu Manipulation Input Checks --- //
		if (auxSelectIndex != -1 && keyboard_check(auxSelectIndex))	{inputFlags |= MENU_AUX_SELECT;}
		if (auxReturnIndex != -1 && keyboard_check(auxReturnIndex))	{inputFlags |= MENU_AUX_RETURN;}
	}
	
	/// @description Processes the input state for the menu during a given frame. This function will only
	/// properly execute if "process_input" was called previously. It handles selection of a menu option,
	/// playing sound effects for select, deselection/closing, and cursor movement, as well as shifting
	/// the visible region of the menu to properly match where the cursor is currently in the menu relative
	/// to its given dimensions for immediately viewable options.
	static execute_menu_input = function(){
		// Don't bother updating the cursor or selection/deselection if the menu's dimensions haven't been 
		// properly initialized OR if the player has an option already selected.
		if (menuWidth * menuHeight == 0 || selOption == curOption) 
			return;
		
		// The player selects an option, which will cause any cursor movement to be ingored on this frame;
		// selecting whatever option is currently highlighted instead. This locks the cursor in place until
		// the value for "selOption" is reset back to its default of -1.
		if (MENU_SELECT_PRESSED || MENU_AUX_SELECT_PRESSED){
			// TODO -- Play menu selection sound effect here.
			selOption = curOption;
			return;
		}
		
		// Pressing the return key will play the sound assigned to the menu's deselection/closing action
		// (Depending on what is required in the context of the menu's state when the input(s) were pressed).
		// All cursor movement is ignored for the frame this code is triggered.
		if (MENU_RETURN_PRESSED || MENU_AUX_RETURN_PRESSED){
			// TODO -- Play menu closing OR deselection sound effect here.
			return;
		}
		
		// Gather cursor inputs by taking the values returned by the macros for their respective inputs (1 if
		// the input(s) are held, 0 if they are not) and throw the results into two local variables (0 = both
		// or none of the inputs are being held for that axis). After that, the auto scroll timer is handled.
		var _magnitudeX = sign(MENU_RIGHT_HELD - MENU_LEFT_HELD);
		var _magnitudeY = sign(MENU_DOWN_HELD - MENU_UP_HELD);
		if (_magnitudeX != 0 || _magnitudeY != 0){
			autoScrollTimer -= DELTA_TIME;
			// When the timer has reached or gone below zero, the menu will determine if this is the first 
			// auto scroll; making that one slightly longer than all subsequent auto scroll movements.
			if (autoScrollTimer <= 0.0){
				if (MENU_IN_AUTO_SCROLL)	{autoScrollTimer = MENU_FAST_SCROLL_INTERVAL;}
				else						{autoScrollTimer = MENU_SLOW_SCROLL_INTERVAL;}
				stateFlags |= MENU_AUTO_SCROLL | MENU_MOVE_CURSOR;
			}
		} else{ // Reset the menu's auto scrolling when no cursor inputs are being held.
			stateFlags &= ~MENU_AUTO_SCROLL;
			stateFlags |=  MENU_MOVE_CURSOR;
			autoScrollTimer = 0.0;
		}
		
		// Skip movement for the frame if the menu isn't allowed to move. If the flag for movement is toggled,
		// it will allow the function to continue on, and will instantly flip its bit back to zero.
		if (!MENU_CAN_MOVE_CURSOR) {return;}
		stateFlags &= ~MENU_MOVE_CURSOR;
		var _curOption = curOption; // Used for resetting the menu highlight flag after cursor movement.
		
		// Handling horizontal cursor movement and scrolling whenever required.
		if (_magnitudeX != 0){
			var _curColumn = curOption % menuWidth;
			
			// Determine how to update the values for "curOption" and the scrolling variables on the x axis
			// based on the column the cursor in on and the direction of the input (1 = right, -1 = left).
			if (_curColumn == menuWidth - 1 && _magnitudeX == 1){
				curOption -= (menuWidth - 1); // Places cursor onto first column.
				firstColumnOffset = 0;
			} else if (_curColumn == 0 && _magnitudeX == -1){
				curOption = min(ds_list_size(optionData), curOption + menuWidth) - 1;
				// Value is clamped to fix an issues with the last row potentially not being the full menu's
				// width. It places the viewable region at the correct place for that option instead of just
				// moving it all the way to the opposite side of the menu.
				firstColumnOffset = clamp(firstColumnOffset + menuWidth - numVisibleColumns, 
											0, curOption % menuWidth - columnShiftOffset);
			} else{
				curOption += _magnitudeX;
				
				// Handle an edge case where the end of the final row is before the menu's final column,
				// which will wrap it back to the first column early if it ever occurs.
				if (_magnitudeX == 1 && curOption >= ds_list_size(optionData)){
					curOption -= curOption % menuWidth;
					firstColumnOffset = 0;
				}
				
				// Shifting visible region based on the current column, the width of the menu, and the shift
				// offset for the view based on the cursor's column. Shifting doesn't occur if the the edge
				// of the menu's visible region is already on the first or last columns, respectively.
				if (menuWidth > 1){
					if (firstColumnOffset + numVisibleColumns < menuWidth && 
							_curColumn >= firstColumnOffset + numVisibleColumns - columnShiftOffset){
						firstColumnOffset++;
					} else if (firstColumnOffset > 0 && _curColumn < firstColumnOffset + columnShiftOffset){
						firstColumnOffset--;
					}
				}
			}
		}
		
		// Handling vertical cursor movement and scrolling whenever required.
		if (_magnitudeY != 0){
			var _totalOptions = ds_list_size(optionData);
			
			// Determine how the value for "curOption" will be updated based on the input direction along the
			// y-axis and if the highlighted option before moving was on the first row or last row, which each
			// have their own unique cases to consider.
			if (curOption - menuWidth < 0 && _magnitudeY == -1){
				curOption += (menuWidth * floor(_totalOptions / menuWidth));
				if (curOption >= _totalOptions) {curOption -= menuWidth;}
			} else if (curOption + menuWidth >= _totalOptions && _magnitudeY == 1){
				curOption = curOption % menuWidth;
				firstRowOffset = 0;
			} else{
				curOption += menuWidth * _magnitudeY;
				
				// Shift the menu's visible region offset for the y-axis depending on what row the 
				// cursor is on relative to the visible region AND the buffer from those edges that 
				// causes the region shift early.
				var _curRow = floor(curOption / menuWidth);
				if (firstRowOffset + numVisibleRows < menuHeight && 
						_curRow >= firstRowOffset + numVisibleRows - rowShiftOffset){
					firstRowOffset++;
				} else if (firstRowOffset > 0 && _curRow < firstRowOffset + rowShiftOffset){
					firstRowOffset--;
				}
			}
		}
		
		// Reset the timer for the highlighted option flash effect so it always starts in its "on" state on 
		// the newly highlighted option.
		if (curOption != _curOption){
			highlightTimer	= MENU_OPTION_HLGHT_INTERVAL;
			stateFlags	   |= MENU_HIGHLIGHT_OPTION;
		}
	}
	
	// GENERAL MENU RENDERING FUNCTIONS /////////////////////////////////////////////////////////////////////////////////////////
	
	/// @description Displays the menu's title to the screen (If there is one to display; leaving the 
	/// variable "title" as an empty string will cause this function to return early) at the specified
	/// position in the desired colors and opacity level. Note that this function assumes the outline
	/// shader has already been initialized in order to prevent constant initialization and resetting
	/// of that shader between the default menu rendering functions.
	/// @param {Asset.GMFont}		font		Font that will be to render the title string.
	/// @param {Real}				x			Position on the x axis to render the title at on screen.
	/// @param {Real}				y			Position on the y axis to render the title at on screen.
	/// @param {Constant.HAlign}	hAlign		Horizontal alignment of the rendered text against its actual position.
	/// @param {Constant.VAlign}	vAlign		Vertical alignment of the rendered text against its actual position.
	/// @param {Constant.Color}		inColor		The color of the text itself.
	/// @param {Array<Real>}		outColor	Color used for the outline around each character.
	/// @param {Real}				alpha		The opacity of all currently rendered menu options.
	static draw_menu_title = function(_font, _x, _y, _hAlign, _vAlign, _inColor, _outColor, _alpha){
		outline_set_font(_font);
		outline_set_color(_outColor);
		draw_set_text_align(_hAlign, _vAlign);
		draw_text_color(_x, _y, title, _inColor, _inColor, _inColor, _inColor, _alpha);
		draw_reset_text_align(); // Reset those alignments to prevent issues outside of the function.
	}
	
	/// @description Displays all of the menu's options at the desire position on screen; using the
	/// spacing along the x and y axes that are provided by the arguments for those values. The text
	/// colors (Aside from the colors used for selection, auxiliary section, and highlighting) and 
	/// opacity for all options are set here. Note that this function assumes the outline shader has 
	/// already been initialized in order to prevent constant initialization and resetting of that 
	/// shader between the default menu rendering functions.
	/// @param {Asset.GMFont}		font		Font that will be used for all menu options.
	/// @param {Real}				x			Position along the x axis to place all rendered options relative to.
	/// @param {Real}				y			Position along the y axis to place all rendered options relative to.
	/// @param {Real}				spacingX	Spacing in pixels between options along the x axis.
	/// @param {Real}				spacingY	Spacing in pixels between options along the y axis.
	/// @param {Constant.HAlign}	hAlign		Horizontal alignment of the rendered text against its actual position.
	/// @param {Constant.VAlign}	vAlign		Vertical alignment of the rendered text against its actual position.
	/// @param {Constant.Color}		inColor		The color of the text itself.
	/// @param {Array<Real>}		outColor	Color used for the outline around each character.
	/// @param {Real}				alpha		The opacity of all currently rendered menu options.
	static draw_menu_options = function(_font, _x, _y, _spacingX, _spacingY, _hAlign, _vAlign, _inColor, _outColor, _alpha){
		outline_set_font(_font);
		outline_set_color(_outColor);
		draw_set_text_align(_hAlign, _vAlign);
		
		// Loop through all the currently visible options; coloring and positioning them appropriately
		// on the screen based on the position provided for the options on-screen, and any offsets applied
		// to the option on top of that initial position. Color values are stored in local variables to
		// allow quicker access to them within the loop.
		var _optionInColor = _inColor;
		var _optionOutColor = _outColor;
		var _inactiveInColor = oInactiveInColor;
		var _inactiveOutColor = oInactiveOutColor;
		var _optionX = 0;
		var _optionY = 0;
		var _curOption = 0;
		for (var yy = firstRowOffset; yy < firstRowOffset + numVisibleRows; yy++){
			for (var xx = firstColumnOffset; xx + firstColumnOffset + numVisibleColumns; xx++){
				// Calculate the offset position for the current option being processed; getting
				// that index for the option by taking the y and x values and changing them to
				// a one-dimensional value.
				_optionX = _x + (xx * _spacingX);
				_optionY = _y + (yy * _spacingY);
				_curOption = xx + (yy * menuWidth);
				
				// Determine the color of the option based on what is currently highlighted, selected,
				// or just currently visible within the menu.
				if (_curOption == selOption){ // Option is selected; use menu's colors for selection.
					_optionInColor = oSelectInColor;
					_optionOutColor = oSelectOutColor;
				} else if (_curOption == auxSelOption){ // Option was selected and stored; use menu's colors for auxiliary selection.
					_optionInColor = oAuxSelectInColor;
					_optionOutColor = oAuxSelectOutColor;
				} else if (_curOption == curOption){ // Option is currently highlight, but not selected; use menu's highlight colors.
					_optionInColor = oHighlightInColor;
					_optionOutColor = oHighlightOutColor;
				} else{ // Return the colors back to the defaults for a visible menu option.
					_optionInColor = _inColor;
					_optionOutColor = _outColor;
				}
				
				// Use the resulting color combination to render the menu option properly relative to
				// its current state (Selected, selected and stored, highlighted, visible, or inactive).
				// Also render the option's icon if one exists. The option's information will also be
				// rendered if there is information to show the player.
				with(optionData[| _curOption]){
					_optionX += offsetX; // Apply whatever offset has been given to the menu option and icon prior to being drawn.
					_optionY += offsetY;
					if (!isActive){ // The option is inactive; overwrite the colors to use inactive colors instead.
						draw_option_info(_curOption, _optionX, _optionY, _inactiveInColor, 
							_inactiveOutColor, _alpha, _alpha);
						continue;
					}
					draw_option_info(_curOption, _optionX, _optionY, _optionInColor, 
						_optionOutColor, _alpha, _alpha);
				}
			}
		}
		
		draw_reset_text_align(); // Reset those alignments to prevent issues outside of the function.
	}
	
	/// @description Renders a given option to the screen at the desired position. It will also draw
	/// the option's icon and information (If there's any icon and info to display) to the screen at
	/// their own respective positions.
	/// @param {Real}			index		The index of the option, its icon, and optional info that is rendered using the function
	/// @param {Real}			x			The x position to render the option and its icon at (Not the option info).
	/// @param {Real}			y			The y position to render the option at (Not the option info).
	/// @param {Constant.Color}	inColor		Color used to render the characters themselves for the option and its info.
	/// @param {Array<Real>}	outColor	Color used to render the outline the surrounds all rendered characters.
	/// @param {Real}			alpha		The visible of the option and its associated icon.
	/// @param {Real}			infoAlpha	The opacity level of the option's displayed information.
	static draw_option_info = function(_index, _x, _y, _inColor, _outColor, _alpha, _infoAlpha){
		with(optionData[| _index]){
			var _optionX = _x + offsetX;
			var _optionY = _y + offsetY;
			draw_text_outline(_optionX, _optionY, optionText, _inColor, _outColor, _alpha);
			with(iconData){ // Icon is offset by 16 pixels so it doesn't overlap the text.
				if (sprite == NO_SPRITE) 
					break;
				draw_sprite_ext(sprite, 0, _optionX - 16, _optionY, 1, 1, 0, c_white, _alpha);
			}
			with(optionInfo) {draw_text_outline(infoX, infoY, infoText, _inColor, _outColor, _infoAlpha);}
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// FUNCTIONS FOR CREATING/DELETING AND DRAWING MENU OPTIONS /////////////////////////////////////////////////////////////////
	
	/// @description Creates a new menu option, placing it at the very end of the list of currently existing
	/// options--if there are any. The only requirement for an option to function is a string of text to
	/// represent it; icons, and info can be completely ignored if desired.
	/// @param {String}			optionText		The text to represent this option and what will occur upon its selection.
	/// @param {Struct}			optionInfo		(Optional) A struct contain information about the option's functionality.
	/// @param {Asset.GMSprite}	optionIcon		(Optional) A sprite that represents the option.
	/// @param {Real}			iconX			Offset along the x axis relative to the option's text position on that same axis.
	/// @param {Real}			iconY			Offset along the y axis relative to the option's text position on that same axis.
	/// @param {Bool}			isActive		Determines if this option can be selected by the player or not.
	static create_option = function(_optionText, _optionInfo = undefined, _optionIcon = undefined, _iconX = 0, _iconY = 0, _isActive = true){
		ds_list_add(optionData, new_option(_optionText, _optionInfo, _optionIcon, _iconX, _iconY, _isActive));
		menuHeight = ceil(ds_list_size(optionData) / menuWidth); // Update height based on menu based on number of inputs.
	}
	
	/// @description Deletes an option from a given menu; replacing it with a completely new one based on 
	/// the arguments provided that mimic the arguments required in the "create_option" function.
	/// @param {Real}			index			The position of the option that will be replaced.
	/// @param {String}			optionText		The text to represent this option and what will occur upon its selection.
	/// @param {Struct}			optionInfo		(Optional) A struct contain information about the option's functionality.
	/// @param {Asset.GMSprite}	optionIcon		(Optional) A sprite that represents the option.
	/// @param {Real}			iconX			Offset along the x axis relative to the option's text position on that same axis.
	/// @param {Real}			iconY			Offset along the y axis relative to the option's text position on that same axis.
	/// @param {Bool}			isActive		Determines if this option can be selected by the player or not.
	static replace_option = function(_index, _optionText, _optionInfo = undefined, _optionIcon = undefined, _iconX = 0, _iconY = 0, _isActive = true){
		if (_index < 0 || _index >= ds_list_size(optionData)) 
			return;
		
		// Remove all the structs that previously existed in the list at the desired position, but don't actually
		// remove the index from the list; doing so would completely screw up the original option order.
		with(optionData[| _index]){
			if (!is_undefined(optionInfo)) 
				delete optionInfo;
			delete iconData;
		}
		delete optionData[| _index];
		
		// Finally, set the newly undefined index to a completely new option struct based on the arguments provided.
		ds_list_set(optionData, _index, new_option(_optionText, _optionInfo, _optionIcon, 
			_iconX, _iconY, _isActive));
	}
	
	/// @description Removes the desired index from the menu's available list of options. Unlike "replace_option"
	/// this function will remove the index from the list completely; shifting all other options up by one.
	/// @param {Real}	index	The index into the list where the desired option is positioned.
	static delete_option = function(_index){
		if (_index < 0 || _index >= ds_list_size(optionData)) 
			return;
			
		with(optionData[_index]){
			if (!is_undefined(optionInfo)) 
				delete optionInfo;
			delete iconData;
		}
		delete optionData[| _index];
		
		ds_list_delete(optionData, _index);
		menuHeight = ceil(ds_list_size(optionData) / menuWidth); // Update height based on menu based on remaining number of inputs.
	}
	
	/// @description Returns a new instance of an option struct, which contains all the data relating to a 
	/// given menu option; its text representation; information to describe what it does to the user; icon
	/// for graphical representation; and some other variables to aid in certain animation effects.
	/// @param {String}			optionText		The text to represent this option and what will occur upon its selection.
	/// @param {Struct}			optionInfo		(Optional) A struct contain information about the option's functionality.
	/// @param {Asset.GMSprite}	optionIcon		(Optional) A sprite that represents the option.
	/// @param {Real}			iconX			Offset along the x axis relative to the option's text position on that same axis.
	/// @param {Real}			iconY			Offset along the y axis relative to the option's text position on that same axis.
	/// @param {Bool}			isActive		Determines if this option can be selected by the player or not.
	static new_option = function(_optionText, _optionInfo, _optionIcon, _iconX, _iconY, _isActive){
		return {
			optionText	:	_optionText,
			optionInfo	:	_optionInfo,
			iconData : { // Inner struct to store information about the icon; its position on screen and image to use.
				x		:	_iconX,
				y		:	_iconY,
				sprite	:	_optionIcon,
			},
			isActive	:	_isActive,
			
			// Variables that aren't explicitly set when the option is created like the above members are. 
			// Instead, these represent offsets to draw the option and (optionally) its icon relative to
			// their default positions. Used primarily for animations.
			offsetX	: 0,
			offsetY	: 0,
			
			// Determine what the values of "offsetX" and "offsetY" should be, and if they aren't equal they
			// will be interpolated to those values using the function "value_set_relative".
			offsetXTarget : 0,
			offsetYTarget : 0,
		};
	}
	
	/// @description Applies new colors for the menu's options depending on what state they're currently
	/// in; highlighted, selected, or any previously selected option that's considered "auxiliary". The
	/// normal color for menu options isn't required since the functional call to render them required
	/// those colors be set as two of its arguments. The same applies to option text alignment and font.
	/// @param {Constant.Color} highlightInColor		The color of the highlighted option's text.
	/// @param {Array<Real>}	highlightOutColor		Color used for the outline of all highlighted characters.
	/// @param {Constant.Color}	selectInColor			The color of the selected option's text.
	/// @param {Array<Real>}	selectOutColor			Color used for the outline of all selected characters.
	/// @param {Constant.Color}	auxSelectInColor		The color of the selected option that is considered an "auxiliary" option.
	/// @param {Array<Real>}	auxSelectOutColor		Color used for the outline of all auxiliary selected characters.
	/// @param {Constant.Color}	inactiveInColor			Inner color used for an inactive option.
	/// @param {Array<Real>}	inactiveOutColor		The outer color that will be used to outline all inactive option text.
	/// @param {Constant.Color}	inactiveInfoInColor		The color of an inactive option's information/
	/// @param {Array<Real>}	inactiveIntoOutColor	Outer color that will be used to outline an inactive option's text.
	static option_set_colors = function(_highlightInColor, _highlightOutColor, _selectInColor, _selectOutColor, _auxSelectInColor, _auxSelectOutColor, _inactiveInColor, _inactiveOutColor, _inactiveInfoInColor, _inactiveInfoOutColor){
		oHighlightInColor		= _highlightInColor;
		oHighlightOutColor		= _highlightOutColor;
		oSelectInColor			= _selectInColor;
		oSelectOutColor			= _selectOutColor;
		oAuxSelectInColor		= _auxSelectInColor;
		oAuxSelectOutColor		= _auxSelectOutColor;
		oInactiveInColor		= _inactiveInColor;
		oInactiveOutColor		= _inactiveOutColor;
		oInfoInactiveInColor	= _inactiveInfoInColor;
		oInfoInactiveOutColor	= _inactiveInfoOutColor;
	}
	
	/// @description Returns a new instance of the optional struct containing descriptive information about a
	/// given menu option. So, use for this function should only occur when also using "create_option" otherwise
	/// this new struct will be useless.
	/// @param {String}	infoText		The string of text to show the player whenever the option it represents is currently highlighted.
	/// @param {Real}	infoX			Position along the x axis that the info text will appear on the screen.
	/// @param {Real}	infoY			Position along the y axis that the info text will appear on the screen.
	/// @param {String}	inactiveText	(Optional) Displays a different message to the user when the option it represents isn't active.
	static new_option_info = function(_infoText, _infoX, _infoY, _inactiveText = ""){
		return {
			infoText		:	_infoText,
			inactiveText	:	_inactiveText,
			infoX			:	_infoX,
			infoY			:	_infoY,
		};
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// BASIC MENU ANIMATION FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////
	
	/// @description A simple animation state that will linearly move the menu's global alpha level towards
	/// a given target value (That value being within the range of 0 and 1) at a given speed. Optionally,
	/// the function can call an additional function after the animation is completed as it switches to the
	/// next state for the menu when the animation condition has been satisfied.
	/// @param {Real}		alphaTarget		The target value for the menu's alpha to hit before the animation is considered "complete".
	/// @param {Real}		animSpeed		Determines how fast the current menu alpha will approach the target at.
	/// @param {Function}	nextState		The state to apply to the menu after the animation's completion.
	/// @param {Function}	endFunction		(Optional) Function that can be called after the animation has been completed to execute additional code outside of any state restrictions.
	static state_animation_alpha = function(_alphaTarget, _animSpeed, _nextState = NO_STATE, _endFunction = NO_FUNCTION){
		alpha = value_set_linear(alpha, _alphaTarget, _animSpeed);
		if (alpha == _alphaTarget){ // Animation is completed; execute any required additional code and switch states.
			object_set_next_state(_nextState);
			if (_endFunction != NO_FUNCTION) 
				_endFunction();
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

#endregion

#region Global functions related to par_menu

/// @description A modification to the standard function "object_set_next_state" that allows the addition
/// of arguments to a state. This will be primarily utilized by animation states that can be used by menu
/// structs, which require their own variables and target values that represent the ending condition of
/// that animation.
/// @param {Function}		nextState	The function that will execute on every frame after the frame this function was called in.
/// @param {Array<Real>}	arguments	An optional array that contains information for the state to utilize when it's called.
function menu_set_next_state(_nextState, _arguments = array_create(0, 0)){
	object_set_next_state(_nextState);
	array_copy(stateArgs, 0, _arguments, 0, array_length(_arguments));
}

/// @description A simple function that createds an instance of a menu, but only a single instance of that
/// menu at any given time to prevent accidental duplication. It initializes the newly created menu, adds it
/// to the list of existing menu structs, and the returns the new struct's ID for any use that is required
/// after this function is called by whatever had called it.
/// @param {Function}	struct
function instance_create_menu_struct(_struct){
	// Prevent the menu from being created if it already exists in the menu instance list OR if the struct
	// provided to the function isn't a valid menu struct.
	if (get_menu_struct(_struct) != undefined || !is_menu_struct(_struct)) 
		return noone;
	
	// Store the new menu instance into the list that manages existing menus upon said menu's creation. Also
	// returns that instance's "id" values, which allows reference to it specifically during runtime while it
	// is still exists in memory.
	var _instance = instance_create_struct(_struct);
	ds_list_add(global.menuInstances, _instance);
	return _instance;
}

/// @description A simple function that destroys a menu struct; clearing it from memory and also removing its
/// instance ID from the menu management list. However, it will only perform these actions if the supplied
/// struct was found within that list to begin with.
/// @param {Function}	struct
function instance_destroy_menu_struct(_struct){
	var _structIndex = get_menu_struct(_struct);
	if (_structIndex != undefined){
		instance_destroy_struct(global.menuInstances[| _structIndex]);
		ds_list_delete(global.menuInstances, _structIndex);
	}
}

/// @description A simple function that will search through the menu struct list to see if the provided
/// struct index doesn't already currently exist. This is done by linearly going through said list to see
/// if one of the menu object's object_index variable matches up with the provided struct's index. If so,
/// the function returns true. Otherwise, it will return false.
/// @param {Function}	struct
function get_menu_struct(_struct){
	var _length = ds_list_size(global.menuInstances);
	for (var i = 0; i < _length / 2; i++){
		if (global.menuInstances[| i].object_index == _struct ||
			global.menuInstances[| _length - i - 1].object_index == _struct) 
				return i;
	}
	return undefined;
}

/// @description A simple function that checks to see if the struct being referenced is a menu struct; 
/// meaning that it inherits from the "par_menu" constructor. OR actually is that "par_menu" struct. In 
/// short, if it is  found in the switch/case statement, the function will return true, and by default it 
/// will return false.
/// @param {Function}	struct
function is_menu_struct(_struct){
	switch(_struct){
		case par_menu:						return true;
		case obj_main_menu:					return true;
		case obj_item_collection_screen:	return true;
		default:							return false;
	}
}

#endregion