#region	Initializing any macros that are useful/related to obj_map_manager

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MAP_PLAYER_VISIBLE		0x00000001
#macro	MAP_FOUND_AREA_ONE		0x08000000
#macro	MAP_SET_ROOM_OFFSET		0x10000000
#macro	MAP_INIT_SURFACE		0x20000000
#macro	MAP_UPDATE_SURFACE		0x40000000
#macro	MAP_ACTIVE				0x80000000

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MAP_IS_PLAYER_VISIBLE	(stateFlags & MAP_PLAYER_VISIBLE)
#macro	MAP_AREA_ONE_IS_FOUND	(stateFlags & MAP_FOUND_AREA_ONE)
#macro	MAP_CAN_SET_ROOM_OFFSET	(stateFlags & MAP_SET_ROOM_OFFSET)
#macro	MAP_SHOULD_INITIALIZE	(stateFlags & MAP_INIT_SURFACE)
#macro	MAP_SHOULD_UPDATE		(stateFlags & MAP_UPDATE_SURFACE)
#macro	MAP_IS_ACTIVE			(stateFlags & MAP_ACTIVE)

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MAP_AREA_UNDEFINED		0xFF
#macro	MAP_AREA_ONE			0x00
#macro	MAP_AREA_TWO			0x01
#macro	MAP_TOTAL_AREAS			0x02

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	MAP_POS_FLASH_INTERVAL	20.0

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	CELL_BORDER_ROTATE1		0x00000001	// Each rotation flag will rotate the map tile by 90 degrees.
#macro	CELL_BORDER_ROTATE2		0x00000002	// With all three being set adding up to a rotation of 270 degrees.
#macro	CELL_BORDER_ROTATE3		0x00000004	// Only two being set means a rotation of 180 degrees.
#macro	CELL_HIDDEN				0x40000000
#macro	CELL_EXPLORED			0x80000000

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	CELL_DOOR_EAST			0x00
#macro	CELL_DOOR_NORTH			0x01
#macro	CELL_DOOR_WEST			0x02
#macro	CELL_DOOR_SOUTH			0x03
#macro	CELL_DOOR_LIMIT			0x04

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	CELL_DOOR_UNDEFINED		0x00
#macro	CELL_DOOR_ANYWEAPON		0x01
#macro	CELL_DOOR_WAVEBEAM		0x02
#macro	CELL_DOOR_ICEBEAM		0x03
#macro	CELL_DOOR_PLASMABEAM	0x04
#macro	CELL_DOOR_MISSILE		0x05
#macro	CELL_DOOR_SPR_MISSILE	0x06
#macro	CELL_DOOR_POWER_BOMB	0x07

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	CELL_ZERO				0x00	// First image in "spr_map_borders"
#macro	CELL_ONE				0x01	// Second image in "spr_map_borders"
#macro	CELL_TWO_A				0x02	// Third image in "spr_map_borders"
#macro	CELL_TWO_B				0x03	//		Rotated by  90 degrees
#macro	CELL_TWO_C				0x04	//				by 180 degrees
#macro	CELL_TWO_D				0x05	//				by 270 degrees
#macro	CELL_THREE_A			0x06	// Fourth image in "spr_map_borders"
#macro	CELL_THREE_B			0x07	//		Rotated by  90 degrees
#macro	CELL_FOUR_A				0x08	// Fifth image in "spr_map_borders"
#macro	CELL_FOUR_B				0x09	//		Rotated by  90 degrees
#macro	CELL_FOUR_C				0x0A	//				by 180 degrees
#macro	CELL_FOUR_D				0x0B	//				by 270 degrees
#macro	CELL_FIVE				0x0C	// Sixth image in "spr_map_borders"
#macro	CELL_SIX_A				0x0D	// Seventh image in "spr_map_borders"
#macro	CELL_SIX_B				0x0E	//		Rotated by  90 degrees
#macro	CELL_SIX_C				0x0F	//				by 180 degrees
#macro	CELL_SIX_D				0x10	//				by 270 degrees
#macro	CELL_SEVEN_A			0x11	// Eighth image in "spr_map_borders"
#macro	CELL_SEVEN_B			0x12	//		Rotated by  90 degrees
#macro	CELL_SEVEN_C			0x13	//				by 180 degrees
#macro	CELL_SEVEN_D			0x14	//				by 270 degrees
#macro	CELL_EIGHT_A			0x15	// Ninth image in "spr_map_borders"
#macro	CELL_EIGHT_B			0x16	//		Rotated by  90 degrees
#macro	CELL_EIGHT_C			0x17	//				by 180 degrees
#macro	CELL_EIGHT_D			0x18	//				by 270 degrees
#macro	CELL_NINE_A				0x19	// Tenth image in "spr_map_borders"
#macro	CELL_NINE_B				0x1A	//		Rotated by  90 degrees
#macro	CELL_NINE_C				0x1B	//				by 180 degrees
#macro	CELL_NINE_D				0x1C	//				by 270 degrees
#macro	CELL_TEN_A				0x1D	// Eleventh image in "spr_map_borders"
#macro	CELL_TEN_B				0x1E	//		Rotated by  90 degrees
#macro	CELL_TEN_C				0x1F	//				by 180 degrees
#macro	CELL_TEN_D				0x20	//				by 270 degrees
#macro	CELL_ELEVEN_A			0x21	// Twelfth image in "spr_map_borders"
#macro	CELL_ELEVEN_B			0x22	//		Rotated by  90 degrees
#macro	CELL_ELEVEN_C			0x23	//				by 180 degrees
#macro	CELL_ELEVEN_D			0x24	//				by 270 degrees
#macro	CELL_TWELVE_A			0x25	// Thirteenth image in "spr_map_borders"
#macro	CELL_TWELVE_B			0x26	//		Rotated by  90 degrees
#macro	CELL_TWELVE_C			0x27	//				by 180 degrees
#macro	CELL_TWELVE_D			0x28	//				by 270 degrees
#macro	CELL_THIRTEEN_A			0x29	// Fourteenth image in "spr_map_borders"
#macro	CELL_THIRTEEN_B			0x2A	//		Rotated by  90 degrees
#macro	CELL_FOURTEEN_A			0x2B	// Fifteenth image in "spr_map_borders"
#macro	CELL_FOURTEEN_B			0x2C	//		Rotated by  90 degrees
#macro	CELL_FIFTEEN_A			0x2D	// Sixteenth image in "spr_map_borders"
#macro	CELL_FIFTEEN_B			0x2E	//		Rotated by  90 degrees
#macro	CELL_FIFTEEN_C			0x2F	//				by 180 degrees
#macro	CELL_FIFTEEN_D			0x30	//				by 270 degrees
#macro	CELL_SIXTEEN_A			0x31	// Seventeenth image in "spr_map_borders"
#macro	CELL_SIXTEEN_B			0x32	//		Rotated by  90 degrees
#macro	CELL_SIXTEEN_C			0x33	//				by 180 degrees
#macro	CELL_SIXTEEN_D			0x34	//				by 270 degrees
#macro	CELL_SEVENTEEN_A		0x35	// Eighteenth image in "spr_map_borders"
#macro	CELL_SEVENTEEN_B		0x36	//		Rotated by  90 degrees
#macro	CELL_SEVENTEEN_C		0x37	//				by 180 degrees
#macro	CELL_SEVENTEEN_D		0x38	//				by 270 degrees
#macro	CELL_EIGHTEEN_A			0x39	// Nineteenth image in "spr_map_borders"
#macro	CELL_EIGHTEEN_B			0x3A	//		Rotated by  90 degrees
#macro	CELL_EIGHTEEN_C			0x3B	//				by 180 degrees
#macro	CELL_EIGHTEEN_D			0x3C	//				by 270 degrees
#macro	CELL_NINETEEN_A			0x3D	// Twentieth image in "spr_map_borders"
#macro	CELL_NINETEEN_B			0x3E	//		Rotated by  90 degrees
#macro	CELL_NINETEEN_C			0x3F	//				by 180 degrees
#macro	CELL_NINETEEN_D			0x40	//				by 270 degrees
#macro	CELL_TWENTY_A			0x41	// Twenty-first image in "spr_map_borders"
#macro	CELL_TWENTY_B			0x42	//		Rotated by  90 degrees
#macro	CELL_TWENTY_C			0x43	//				by 180 degrees
#macro	CELL_TWENTY_D			0x44	//				by 270 degrees
#macro	CELL_TWENTYONE_A		0x45	// Twenty-second image in "spr_map_borders"
#macro	CELL_TWENTYONE_B		0x46	//		Rotated by  90 degrees
#macro	CELL_TWENTYONE_C		0x47	//				by 180 degrees
#macro	CELL_TWENTYONE_D		0x48	//				by 270 degrees
#macro	CELL_TWENTYTWO_A		0x49	// Twenty-third image in "spr_map_borders"
#macro	CELL_TWENTYTWO_B		0x4A	//		Rotated by  90 degrees
#macro	CELL_TWENTYTWO_C		0x4B	//				by 180 degrees
#macro	CELL_TWENTYTWO_D		0x4C	//				by 270 degrees
#macro	CELL_TWENTYTHREE_A		0x4D	// Twenty-fourth image in "spr_map_borders"
#macro	CELL_TWENTYTHREE_B		0x4E	//		Rotated by  90 degrees
#macro	CELL_TWENTYTHREE_C		0x4F	//				by 180 degrees
#macro	CELL_TWENTYTHREE_D		0x50	//				by 270 degrees
#macro	CELL_TWENTYFOUR_A		0x51	// Twenty-fifth image in "spr_map_borders"
#macro	CELL_TWENTYFOUR_B		0x52	//		Rotated by  90 degrees
#macro	CELL_TWENTYFOUR_C		0x53	//				by 180 degrees
#macro	CELL_TWENTYFOUR_D		0x54	//				by 270 degrees
#macro	CELL_TWENTYFIVE_A		0x55	// Twenty-sixth image in "spr_map_borders"
#macro	CELL_TWENTYFIVE_B		0x56	//		Rotated by  90 degrees
#macro	CELL_TWENTYFIVE_C		0x57	//				by 180 degrees
#macro	CELL_TWENTYFIVE_D		0x58	//				by 270 degrees
#macro	CELL_TWENTYSIX_A		0x59	// Twenty-seventh image in "spr_map_borders"
#macro	CELL_TWENTYSIX_B		0x5A	//		Rotated by  90 degrees
#macro	CELL_TWENTYSIX_C		0x5B	//				by 180 degrees
#macro	CELL_TWENTYSIX_D		0x5C	//				by 270 degrees
#macro	CELL_TWENTYSEVEN_A		0x5D	// Twenty-eighth image in "spr_map_borders"
#macro	CELL_TWENTYSEVEN_B		0x5E	//		Rotated by  90 degrees
#macro	CELL_TWENTYSEVEN_C		0x5F	//				by 180 degrees
#macro	CELL_TWENTYSEVEN_D		0x60	//				by 270 degrees
#macro	CELL_TWENTYEIGHT_A		0x61	// Twenty-ninth image in "spr_map_borders"
#macro	CELL_TWENTYEIGHT_B		0x62	//		Rotated by  90 degrees
#macro	CELL_TWENTYEIGHT_C		0x63	//				by 180 degrees
#macro	CELL_TWENTYEIGHT_D		0x64	//				by 270 degrees
#macro	CELL_TWENTYNINE_A		0x65	// Thirtieth image in "spr_map_borders"
#macro	CELL_TWENTYNINE_B		0x66	//		Rotated by  90 degrees
#macro	CELL_TWENTYNINE_C		0x67	//				by 180 degrees
#macro	CELL_TWENTYNINE_D		0x68	//				by 270 degrees

#endregion

#region Initializing enumerators that are useful/related to obj_map_manager
#endregion

#region Initializing any globals that are useful/related to obj_map_manager
#endregion

#region The main object code for obj_map_manager

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_map_manager(_index) : base_struct(_index) constructor{
	// 
	stateFlags		= 0;
	
	// 
	mapData			= array_create(MAP_TOTAL_AREAS, -1);
	mapWidth		= 0;
	mapHeight		= 0;
	mapSurf			= -1;
	mapSurfBuffer	= -1;
	
	// 
	iconData		= array_create(MAP_TOTAL_AREAS, -1);
	doorData		= array_create(MAP_TOTAL_AREAS, -1);
	
	// 
	curArea			= MAP_AREA_UNDEFINED;
	curRoomX		= 0;
	curRoomY		= 0;
	
	// 
	playerCellX		= 0;
	playerCellY		= 0;
	playerMapX		= 0.0;
	playerMapY		= 0.0;
	
	// 
	posFlashTimer = 0.0;
	
	/// @description Called by the global struct manager when the Map Manager is destroyed (It should only ever 
	/// be destroyed at the end of the game's execution). It will free any memory that is allocated for map
	/// cells, icons, and surfaces that are all utilized for the game's map system.
	cleanup = function(){
		// Increment through all indexes of the mapData array as they could contain lists of struct references
		// relative to the areas the player has explored during their current playthrough. It also unloads the
		// icon data for these maps if they exist as well.
		var _key = -1;
		var _map = -1;
		for (var i = 0; i < MAP_TOTAL_AREAS; i++){
			_map = mapData[i];
			if (_map == -1) // Ignore all areas that have never been loaded into memory.
				continue;
			
			// Loop through all cell struct instances so they can be cleared from memory before the ds_map that
			// contains the references to these structs is destroyed. Otherwise, a memory leak may occur.
			_key = ds_map_find_first(_map);
			while(!is_undefined(_key)){
				delete _map[? _key];
				_key = ds_map_find_next(_map, _key);	
			}
			ds_map_clear(_map); // "Clears" the pointers to further help the garbage collector know these instances are no longer needed.
			ds_map_destroy(_map);
			
			// After all the cells have been cleared from memory, the icon data and door data will have their
			// maps deleted from memory (They don't store structs, so no looping through values are necessary
			// for either data strcuture).
			ds_map_destroy(iconData[i]);
			ds_map_destroy(doorData[i]);
		}
		
		// Free the map's surface from memory if it hasn't been flushed from memory yet and also delete the
		// buffer that contains a copy of that surface in case of it being flushed while in use.
		if (surface_exists(mapSurf))	
			surface_free(mapSurf);
		buffer_delete(mapSurfBuffer);
	}
	
	/// @description A function that should be called within the "End Step" event of whatever object is 
	/// managing this map manager object. It's responsible for determining the current cell the player is
	/// occupying relative to the room's origin (The very top-left cell that can be explored) on the map
	/// and the player's position within the room.
	end_step = function(){
		// Don't bother wasting time determining the player's current cell position within the map if it isn't
		// even active to begin with.
		if (!MAP_IS_ACTIVE)
			return;
		
		// First, grab the position of the player within the room and store the x and y values into their
		// respective temporary variables.
		var _playerX = 0;
		var _playerY = 0;
		with(PLAYER){
			_playerX = x;
			_playerY = y;
		}
		
		// After the player's position is obtained, the player's "map" position (This is the cell position
		// including the decimal that represents their exact position in the cell relative to the size of a
		// cell in pixels [320 by 180 in this case]) is calculated including the room's position on the map.
		var _camera	= CAMERA.camera;
		playerMapX	= curRoomX + (_playerX / camera_get_view_width(_camera));
		playerMapY	= curRoomY + (_playerY / camera_get_view_height(_camera));
		
		// Then, the player's cell position is updated by flooring their current map position. The previous
		// cell position is stored and then a check is performed to see if the new position is different on
		// either axis. If so, the map may need to be updated.
		var _cellX	= playerCellX;
		var _cellY	= playerCellY;
		playerCellX = floor(playerMapX);
		playerCellY = floor(playerMapY);
		if (_cellX != playerCellX || _cellY != playerCellY){
			// Check if the map cell has already been explored by the player. If so, the surface isn't updated.
			// Otherwise, it is updated so it is colored to match other explored cells.
			var _isExplored = false;
			with(mapData[curArea][? playerCellX + (playerCellY * mapWidth)]){
				if (flags & CELL_EXPLORED)
					_isExplored = true;
			}
			
			// Only flip the flag that causes a surface update to occur if the cell isn't explored yet.
			if (!_isExplored) {stateFlags |= MAP_UPDATE_SURFACE;}
		}
		
		// Finally, increment the timer based on the current delta time until it reaches or exceeds the value
		// set for the player's current cell flashing effect. The bit that determines if this flash is visible
		// is flipped and the timer ir reset to repeat the process indefinitely.
		posFlashTimer += DELTA_TIME;
		if (posFlashTimer >= MAP_POS_FLASH_INTERVAL){
			if (MAP_IS_PLAYER_VISIBLE)	{stateFlags &= ~MAP_PLAYER_VISIBLE;}
			else						{stateFlags |=  MAP_PLAYER_VISIBLE;}
			posFlashTimer = 0.0;
		}
	}
	
	/// @description A function that should be called within the "Draw GUI" event of whatever object is
	/// managing this map manager object. It handles initialization of the map surface (Filling it with empty
	/// cells immediately after an area's map has been initialized) and updating of a map cell if it needs to
	/// be set to explored by the player moving to a new and currently unexplored cell.
	draw_gui = function(){
		// Don't bother processing anything if the map isn't actually active. Otherwise the game will crash
		// attempting to generate a surface that has a width and height of zero.
		if (!MAP_IS_ACTIVE || curArea == MAP_AREA_UNDEFINED || curArea >= array_length(mapData))
			return;
		
		// Ensure the surface exists. If it doesn't, a new one will be generated that is the desired size for
		// the current map that is loaded. Then, the buffer will be copied into that surface to ensure what
		// was already rendered onto the map isn't lost alongside the surface.
		if (!surface_exists(mapSurf)){
			var _cellWidth	= sprite_get_width(spr_map_borders);
			var _cellHeight	= sprite_get_height(spr_map_borders);
			mapSurf			= surface_create(mapWidth * _cellWidth, mapHeight * _cellHeight);
			buffer_set_surface(mapSurfBuffer, mapSurf, 0);
		}
		
		// Initializes the current map by filling it with empty map tiles. This code should only ever be run
		// during the creation of the map itself, and the "MAP_INIT_SURFACE" should never be set after that.
		if (MAP_SHOULD_INITIALIZE){
			surface_set_target(mapSurf);
			
			// Determine the total number of columns and rows that the map contains. Then, loop through all
			// those cells and draw the empty tile so all cells in the map are filled.
			var _cellWidth	= sprite_get_width(spr_map_borders);
			var _cellHeight	= sprite_get_height(spr_map_borders);
			var _originX	= sprite_get_xoffset(spr_map_borders);
			var _originY	= sprite_get_yoffset(spr_map_borders);
			var _numColumns = mapWidth * _cellWidth;
			var _numRows	= mapHeight * _cellHeight;
			for (var yy = 0; yy < _numRows; yy++){
				for (var xx = 0; xx < _numColumns; xx++)
					draw_sprite_ext(spr_map_borders, 0, (xx * _cellWidth) + _originX, 
						(yy * _cellHeight) + _originY, 1.0, 1.0, 0, c_white, 1.0);
			}
			
			surface_reset_target();
			
			// After the map has been initialized with empty cells and the structs containing the data for
			// actual map cells themselves, the surface is copied into a buffer so the data won't be lost if
			// the surface is ever flushed from memory by the GPU.
			buffer_get_surface(mapSurfBuffer, mapSurf, 0);
			stateFlags &= ~MAP_INIT_SURFACE; // Flip the flag back to zero to avoid processing everything again.
		}
		
		// Exit the event early if the map isn't set tp update itself. This update should only occur on the
		// exact frame that the player moves from one cell to another during gameplay.
		if (!MAP_SHOULD_UPDATE)
			return;
		stateFlags &= ~MAP_UPDATE_SURFACE;
		
		// Switch surface targets so that everything from this point onward is rendered onto the map surface.
		surface_set_target(mapSurf);

		// Create some local variables that are used throughout the rest of te event in order to properly
		// render the background and border to the map cell, as well any potential icon and doors that could
		// also exist within the cell being currently drawn.
		var _cellWidth	= sprite_get_width(spr_map_borders);
		var _cellHeight	= sprite_get_height(spr_map_borders);
		var _offsetX	= sprite_get_xoffset(spr_map_borders);
		var _offsetY	= sprite_get_yoffset(spr_map_borders);
		var _xx			= (playerCellX * _cellWidth);
		var _yy			= (playerCellY * _cellHeight);
		var _index		= playerCellX + (playerCellY * mapWidth);
		with(mapData[curArea][? _index]){
			// If the cell has already been explored, don't bother wasting time drawing the exact same thing
			// again. Otherwise, flip the flag within the map cell's struct to signify it has been explored
			// and drawn to the surface already.
			if (flags & CELL_EXPLORED)
				break;
			flags |= CELL_EXPLORED;

			// Borders have their orientation and color dynamically determined based on certain flags being 
			// set right here, which saves a ton of space on the game's texture page that would have to be
			// filled with all these variations in direction/color that could potentially arise within the
			// game's maps.
			var _direction	= 0.0;
			var _color		= HEX_LIGHT_BLUE;
			
			// Rotate the border by 90 degrees for every rotation flag that is set for the map cell. On top
			// of that, the color is switch to a green hue to signify if any area is hidden from being mapped
			// or not.
			for (var i = 0; i < 3; i++){
				if (flags & (1 << i))
					_direction += 90.0;
			}
			if (flags & CELL_HIDDEN) {_color = HEX_LIGHT_GREEN;}
			
			// With the proper color and direction found, the cell's background (Uses the color value) and its 
			// border (Uses the direction value) are render onto the map surface.
			draw_sprite_ext(spr_rectangle, 0, _xx, _yy, _cellWidth, _cellHeight, 0.0, _color, 1.0);
			draw_sprite_ext(spr_map_borders, borderIndex, _xx + _offsetX, _yy + _offsetY, 
				1.0, 1.0, _direction, c_white, 1.0);
		}
		
		// Determine if an icon exists for this map cell. If so, it will be drawn on top of the cell's back
		// and border, but below any of the possible doorways that can exist on a single cell.
		var _iconData = iconData[curArea];
		if (ds_exists(_iconData, ds_type_map) && !is_undefined(_iconData[? _index])){
			draw_sprite_ext(spr_map_icons, iconData[? _index], _xx + _offsetX, _yy + _offsetY, 
				1.0, 1.0, 0.0, c_white, 1.0);
		}
		
		// Check if there is any door data for the map cell that is being drawn to the surface. If so, the
		// array contained for that cell's door data is looped through in order to render all that exist.
		var _doorData = doorData[curArea];
		if (ds_exists(_doorData, ds_type_map) && !is_undefined(_doorData[? _index])){
			var _doorType	= CELL_DOOR_UNDEFINED;
			var _doorX		= 0;
			var _doorY		= 0;
			var _xScale		= 1.0;
			var _yScale		= 1.0;
			for (var i = 0; i < CELL_DOOR_LIMIT; i++){
				_doorType = _doorData[? _index][i];
				if (_doorType == CELL_DOOR_UNDEFINED) // Don't bother drawing a non-existent doorway.
					continue;
				_doorX = _xx;
				_doorY = _yy;
				
				// Determine the positional offset and "scaling" of the doorway based on the index within the
				// array that is currently being processed. The "scaling" simply determines if the door is a
				// 2x1 rectangle (For north and south doors) or a 1x2 rectangle (For east and west doors).
				switch(i){
					case CELL_DOOR_EAST:
						_doorX += _cellWidth - 1;
					case CELL_DOOR_WEST:
						_xScale	= 1.0;
						_yScale = 2.0;
						_doorY	= _yy + 3;
						break;
					case CELL_DOOR_SOUTH:
						_doorY += _cellHeight - 1;
					case CELL_DOOR_NORTH:
						_xScale = 2.0;
						_yScale = 1.0;
						_doorX  = _xx + 3;
						break;
				}
				
				// Display the door at the determined position relative to the map cell being drawn. Its color
				// is determined by the type of door that is being rendering onto the map.
				draw_sprite_ext(spr_rectangle, 0, _doorX, _doorY, _xScale, _yScale, 
					0.0, door_get_color(_doorType), 1.0);
			}
		}
		
		// Finally, reset the target surface so drawing to the application surface is re-enabled and store the
		// map surface into its backup buffer so it doesn't get lost due to surface volatility.
		surface_reset_target();
		buffer_get_surface(mapSurfBuffer, mapSurf, 0);
	}
	
	/// @description Displays a given portion of the map onto the game's GUI. The first two arguments are
	/// where the map is displayed on the GUI, and the last four arguments determine which region of the
	/// map is displayed; the last two arguments determining the width and height of the drawn portion.
	/// @param {Real}	x			The position along the x-axis of the screen to display the map at.
	/// @param {Real}	y			The position along the y-axis of the screen to display the map at.
	/// @param {Real}	startX		Determines the first visible column of map tiles.
	/// @param {Real}	startY		Determines the first visible row of map tiles.
	/// @param {Real}	numColumns	The total number of visible columns drawn by the map.
	/// @parma {Real}	numRows		The total number of visible rows drawn by the map.
	draw_map_to_screen = function(_x, _y, _startX, _startY, _numColumns, _numRows){
		// Converts the cell-based values of the argument parameters into actual pixel values that can be used
		// to determine which region of map cells will be shown on the screen.
		var _cellWidth	= sprite_get_width(spr_map_borders);
		var _cellHeight = sprite_get_height(spr_map_borders);
		var _cellX		= _startX * _cellWidth;
		var _cellY		= _startY * _cellHeight;
		var _mapWidth	= _numColumns * _cellWidth;
		var _mapHeight	= _numRows * _cellHeight;
		
		// Check to see if the map surface isn't flushed out of the GPUs memory for whatever reason. If so, it
		// will be recreated and the buffer's date will be copied back into the map surface before the visible
		// section is drawn on the screen at the desired position.
		if (!surface_exists(mapSurf)){
			mapSurf	= surface_create(mapWidth * _cellWidth, mapHeight * _cellHeight);
			buffer_set_surface(mapSurfBuffer, mapSurf, 0);
		}
		draw_surface_part(mapSurf, _cellX, _cellY, _mapWidth, _mapHeight, _x, _y);
	}
	
	/// @description Creates a map cell, which is stored in a ds_map at the position determined by the "cellX"
	/// and "cellY" parameters alongside the map's width. If a map cell already occupies that cell, the new
	/// cell will not be created and this function will exit early.
	/// @param {Real}			cellX			One part of what determines the map cell's index value within the ds_map storing each cell.
	/// @param {Real}			cellY			The second part of what determines the map cell's index value.
	///	@param {Real}			borderIndex		Determines which rotation flags to toggled, as well as what border image to use for the cell.
	/// @param {Real}			flags			(Optional) Allows a map cell to be flagged as hidden, explored, its border rotated, and so on.
	create_map_cell = function(_cellX, _cellY, _borderIndex, _flags = 0){
		// No map cells will ever be initialized if the map isn't actually active, as that would be wasting
		// time creating useless data that won't be utilized at that current moment in the game.
		if (!MAP_IS_ACTIVE || curArea == MAP_AREA_UNDEFINED || curArea >= MAP_TOTAL_AREAS)
			return;
		var _curArea = mapData[curArea];
		if (_curArea == -1) // Map data structure doesn't exist. Don't create a map cell struct.
			return;
		
		// Determine the cell's index value, which is the one-dimensional conversion of its two-dimensional
		// position within the map itself. Then, check if that cell is already occupied before creating another.
		var _cellIndex = _cellX + (_cellY * mapWidth);
		if (!is_undefined(_curArea[? _cellIndex]))
			return;
		
		// Determine the required rotation flags based on the border index that the map cell is using, and then
		// logically OR that against any other toggled flags within the "_flags" argument parameter.
		var _borderFlags = get_border_index_flags(_borderIndex);
		var _cellStruct = {
			borderIndex	: get_border_index_image(_borderIndex),
			flags		: _borderFlags | _flags,
		};
		ds_map_add(_curArea, _cellIndex, _cellStruct);
	}
	
	/// @description Creates a map icon, which exists independently of any existing map cells. This allows them
	/// to be placed on cells that are otherwise unoccupied by a cell (Ex. Player placed markers). However, they
	/// can also be linked to the map cell they share a position with, and will only be visible if that map cell
	/// has been explored or shown due to the player having the area's map.
	/// @param {Real}	cellX		One part of what determines the icon's index value within the ds_map storing each map icon.
	/// @param {Real}	cellY		The second part of what determines the icon's index value.			
	/// @param {Real}	iconIndex	Determine which icon should be used for the desired map cell.
	create_map_icon = function(_cellX, _cellY, _iconIndex){
		// No map icons will ever be initialized if the map isn't actually active, as that would be wasting
		// time creating useless data that won't be utilized at that current moment in the game.
		if (!MAP_IS_ACTIVE || curArea == MAP_AREA_UNDEFINED || curArea >= MAP_TOTAL_AREAS)
			return;
		var _icons = iconData[curArea];
		if (_icons == noone) // Don't add an icon to an area's map if its data structure doesn't exist.
			return;
			
		// Make sure that there isn't already an icon occupying the current map cell. If so, the function
		// exits. Otherwise, the icon's image index is stored in the map.
		var _cellIndex = _cellX + (_cellY * mapWidth);
		if (!is_undefined(_icons[? _cellIndex]))
			return;
		ds_map_add(_icons, _cellIndex, _iconIndex);
	}
	
	/// @description Create an array of four numbers that represent a map cell's potential doorways (Each array 
	/// has a size of 4 since doors can only exist on the four cardinal directions). The numbers stored at each
	/// index relates to one of the game's door types as it is displayed on the map.
	/// @param {Real}	cellX		One part of the value that determines the "index" used to reference a map cell's door data.
	///	@param {Real}	cellY		The second part of the value that determine's a map cell's door data.
	///	@param {Real}	index		Which direction the door will be facing on the map (North, South, East, and West).
	/// @param {Real}	type		Determines the color of the door to match what type of door is found there in the game.
	create_map_door = function(_cellX, _cellY, _index, _type){
		// No door array can be created if the map system itself isn't currently active OR the current area
		// index not match up with any of the valid area indices. Another fallthrough occurs if the provided
		// door index is outside of the valid bounds of 0 to 3.
		if (!MAP_IS_ACTIVE || curArea == MAP_AREA_UNDEFINED || curArea >= MAP_TOTAL_AREAS 
				|| _index < 0 || _index >= CELL_DOOR_LIMIT)
			return;
		var _doors = doorData[curArea];
		if (_doors == -1) // Don't add any door data to an area's map if that map doesn't actually exist.
			return;
			
		// Determine if the cell already has an array containing data for potential doorways that might already
		// exist. If this array exists, the index for the desired door is simply set to the value passed into
		// the function's parameter and the function exits.
		var _cellIndex = _cellX + (_cellY * mapWidth);
		if (!is_undefined(_doors[? _cellIndex])){
			_doors[? _cellIndex][_index] = _type;
			return;
		}
		
		// Create the array that will store the door information for the desired map cell. Then, the index
		// that represents the door that the function is creating this array for is set before it is added to
		// the data structure containing the area's current door information.
		var _data		= array_create(CELL_DOOR_LIMIT, CELL_DOOR_UNDEFINED);
		_data[_index]	= _type;
		ds_map_add(_doors, _cellIndex, _data);
	}
	
	/// @description Determines how many of the three rotation flags should be toggled to a value of one within
	/// a map cell's flags variable. If the value passed in cannot be found within the range of valid indexes
	/// the default value returned will be 0 AKA no rotations at all to the cell border being used.
	/// @param {Real}	borderIndex		Value that determines how many rotation flags will be toggled to true.
	get_border_index_flags = function(_borderIndex){
		switch(_borderIndex){
			default:					// No rotation adjustments required for border tile.
			case CELL_ZERO:				//						''
			case CELL_ONE:				//						''
			case CELL_TWO_A:			//						''
			case CELL_THREE_A:			//						''
			case CELL_FOUR_A:			//						''
			case CELL_FIVE:				//						''
			case CELL_SIX_A:			//						''
			case CELL_SEVEN_A:			//						''
			case CELL_EIGHT_A:			//						''
			case CELL_NINE_A:			//						''
			case CELL_TEN_A:			//						''
			case CELL_ELEVEN_A:			//						''
			case CELL_TWELVE_A:			//						''
			case CELL_THIRTEEN_A:		//						''
			case CELL_FOURTEEN_A:		//						''
			case CELL_FIFTEEN_A:		//						''
			case CELL_SIXTEEN_A:		//						''
			case CELL_SEVENTEEN_A:		//						''
			case CELL_EIGHTEEN_A:		//						''
			case CELL_NINETEEN_A:		//						''
			case CELL_TWENTY_A:			//						''
			case CELL_TWENTYONE_A:		//						''
			case CELL_TWENTYTWO_A:		//						''
			case CELL_TWENTYTHREE_A:	//						''
			case CELL_TWENTYFOUR_A:		//						''
			case CELL_TWENTYFIVE_A:		//						''
			case CELL_TWENTYSIX_A:		//						''
			case CELL_TWENTYSEVEN_A:	//						''
			case CELL_TWENTYEIGHT_A:	//						''
			case CELL_TWENTYNINE_A:		// No rotation adjustments required for border tile.
				return 0x00000000;
			case CELL_TWO_B:			// A rotation of 90 degrees is required for the border tile.
			case CELL_THREE_B:			//						''
			case CELL_FOUR_B:			//						''
			case CELL_SIX_B:			//						''
			case CELL_SEVEN_B:			//						''
			case CELL_EIGHT_B:			//						''
			case CELL_NINE_B:			//						''
			case CELL_TEN_B:			//						''
			case CELL_ELEVEN_B:			//						''
			case CELL_TWELVE_B:			//						''
			case CELL_THIRTEEN_B:		//						''
			case CELL_FOURTEEN_B:		//						''
			case CELL_FIFTEEN_B:		//						''
			case CELL_SIXTEEN_B:		//						''
			case CELL_SEVENTEEN_B:		//						''
			case CELL_EIGHTEEN_B:		//						''
			case CELL_NINETEEN_B:		//						''
			case CELL_TWENTY_B:			//						''
			case CELL_TWENTYONE_B:		//						''
			case CELL_TWENTYTWO_B:		//						''
			case CELL_TWENTYTHREE_B:	//						''
			case CELL_TWENTYFOUR_B:		//						''
			case CELL_TWENTYFIVE_B:		//						''
			case CELL_TWENTYSIX_B:		//						''
			case CELL_TWENTYSEVEN_B:	//						''
			case CELL_TWENTYEIGHT_B:	//						''
			case CELL_TWENTYNINE_B:		// A rotation of 90 degrees is required for the border tile.
				return CELL_BORDER_ROTATE1;
			case CELL_TWO_C:			// A rotation of 180 degrees is required for the border tile.
			case CELL_FOUR_C:			//						''
			case CELL_SIX_C:			//						''
			case CELL_SEVEN_C:			//						''
			case CELL_EIGHT_C:			//						''
			case CELL_NINE_C:			//						''
			case CELL_TEN_C:			//						''
			case CELL_ELEVEN_C:			//						''
			case CELL_TWELVE_C:			//						''
			case CELL_FIFTEEN_C:		//						''
			case CELL_SIXTEEN_C:		//						''
			case CELL_SEVENTEEN_C:		//						''
			case CELL_EIGHTEEN_C:		//						''
			case CELL_NINETEEN_C:		//						''
			case CELL_TWENTY_C:			//						''
			case CELL_TWENTYONE_C:		//						''
			case CELL_TWENTYTWO_C:		//						''
			case CELL_TWENTYTHREE_C:	//						''
			case CELL_TWENTYFOUR_C:		//						''
			case CELL_TWENTYFIVE_C:		//						''
			case CELL_TWENTYSIX_C:		//						''
			case CELL_TWENTYSEVEN_C:	//						''
			case CELL_TWENTYEIGHT_C:	//						''
			case CELL_TWENTYNINE_C:		// A rotation of 180 degrees is required for the border tile.
				return CELL_BORDER_ROTATE1 | CELL_BORDER_ROTATE2;
			case CELL_TWO_D:			// A rotation of 270 degrees is required for the border tile.
			case CELL_FOUR_D:			//						''
			case CELL_SIX_D:			//						''
			case CELL_SEVEN_D:			//						''
			case CELL_EIGHT_D:			//						''
			case CELL_NINE_D:			//						''
			case CELL_TEN_D:			//						''
			case CELL_ELEVEN_D:			//						''
			case CELL_TWELVE_D:			//						''
			case CELL_FIFTEEN_D:		//						''
			case CELL_SIXTEEN_D:		//						''
			case CELL_SEVENTEEN_D:		//						''
			case CELL_EIGHTEEN_D:		//						''
			case CELL_NINETEEN_D:		//						''
			case CELL_TWENTY_D:			//						''
			case CELL_TWENTYONE_D:		//						''
			case CELL_TWENTYTWO_D:		//						''
			case CELL_TWENTYTHREE_D:	//						''
			case CELL_TWENTYFOUR_D:		//						''
			case CELL_TWENTYFIVE_D:		//						''
			case CELL_TWENTYSIX_D:		//						''
			case CELL_TWENTYSEVEN_D:	//						''
			case CELL_TWENTYEIGHT_D:	//						''
			case CELL_TWENTYNINE_D:		// A rotation of 270 degrees is required for the border tile.
				return CELL_BORDER_ROTATE1 | CELL_BORDER_ROTATE2 | CELL_BORDER_ROTATE3;
		}
	}
	
	/// @description Determines which base image out of the sprite "spr_map_borders" to utilize for a map cell's
	/// border depending on what its unique index value is. If the value passed in cannot be found by the function,
	/// the default image will be the very first image in the spritesheet.
	/// @param {Real}	borderIndex		Value to convert into a valid image index for a map cell's border.
	get_border_index_image = function(_borderIndex){
		switch(_borderIndex){
			default:					// Uses the first image found in "spr_map_borders".
			case CELL_ZERO:				//						''
				return 0;
			case CELL_ONE:				// Uses the second image found in "spr_map_borders".
				return 1;
			case CELL_TWO_A:			// Uses the third image found in "spr_map_borders".
			case CELL_TWO_B:			//						''
			case CELL_TWO_C:			//						''
			case CELL_TWO_D:			//						''
				return 2;
			case CELL_THREE_A:			// Uses the fourth image found in "spr_map_borders".
			case CELL_THREE_B:			//						''
				return 3;
			case CELL_FOUR_A:			// Uses the fifth image found in "spr_map_borders".
			case CELL_FOUR_B:			//						''
			case CELL_FOUR_C:			//						''
			case CELL_FOUR_D:			//						''
				return 4;
			case CELL_FIVE:				// Uses the sixth image found in "spr_map_borders".
				return 5;
			case CELL_SIX_A:			// Uses the seventh image found in "spr_map_borders".
			case CELL_SIX_B:			//						''
			case CELL_SIX_C:			//						''
			case CELL_SIX_D:			//						''
				return 6;
			case CELL_SEVEN_A:			// Uses the eighth image found in "spr_map_borders".
			case CELL_SEVEN_B:			//						''
			case CELL_SEVEN_C:			//						''
			case CELL_SEVEN_D:			//						''
				return 7;
			case CELL_EIGHT_A:			// Uses the ninth image found in "spr_map_borders".
			case CELL_EIGHT_B:			//						''
			case CELL_EIGHT_C:			//						''
			case CELL_EIGHT_D:			//						''
				return 8;
			case CELL_NINE_A:			// Uses the tenth image found in "spr_map_borders".
			case CELL_NINE_B:			//						''
			case CELL_NINE_C:			//						''
			case CELL_NINE_D:			//						''
				return 9;
			case CELL_TEN_A:			// Uses the eleventh image found in "spr_map_borders".
			case CELL_TEN_B:			//						''
			case CELL_TEN_C:			//						''
			case CELL_TEN_D:			//						''
				return 10;
			case CELL_ELEVEN_A:			// Uses the twelfth image found in "spr_map_borders".
			case CELL_ELEVEN_B:			//						''
			case CELL_ELEVEN_C:			//						''
			case CELL_ELEVEN_D:			//						''
				return 11;
			case CELL_TWELVE_A:			// Uses the thirteenth image found in "spr_map_borders".
			case CELL_TWELVE_B:			//						''
			case CELL_TWELVE_C:			//						''
			case CELL_TWELVE_D:			//						''
				return 12;
			case CELL_THIRTEEN_A:		// Uses the fourteenth image found in "spr_map_borders".
			case CELL_THIRTEEN_B:		//						''
				return 13;
			case CELL_FOURTEEN_A:		// Uses the fifteenth image found in "spr_map_borders".
			case CELL_FOURTEEN_B:		//						''
				return 14;
			case CELL_FIFTEEN_A:		// Uses the sixteenth image found in "spr_map_borders".
			case CELL_FIFTEEN_B:		//						''
			case CELL_FIFTEEN_C:		//						''
			case CELL_FIFTEEN_D:		//						''
				return 15;
			case CELL_SIXTEEN_A:		// Uses the seventeenth image found in "spr_map_borders".
			case CELL_SIXTEEN_B:		//						''
			case CELL_SIXTEEN_C:		//						''
			case CELL_SIXTEEN_D:		//						''
				return 16;
			case CELL_SEVENTEEN_A:		// Uses the eighteenth image found in "spr_map_borders".
			case CELL_SEVENTEEN_B:		//						''
			case CELL_SEVENTEEN_C:		//						''
			case CELL_SEVENTEEN_D:		//						''
				return 17;
			case CELL_EIGHTEEN_A:		// Uses the nineteenth image found in "spr_map_borders".
			case CELL_EIGHTEEN_B:		//						''
			case CELL_EIGHTEEN_C:		//						''
			case CELL_EIGHTEEN_D:		//						''
				return 18;
			case CELL_NINETEEN_A:		// Uses the twentieth image found in "spr_map_borders".
			case CELL_NINETEEN_B:		//						''
			case CELL_NINETEEN_C:		//						''
			case CELL_NINETEEN_D:		//						''
				return 19;
			case CELL_TWENTY_A:			// Uses the twenty-first image found in "spr_map_borders".
			case CELL_TWENTY_B:			//						''
			case CELL_TWENTY_C:			//						''
			case CELL_TWENTY_D:			//						''
				return 20;
			case CELL_TWENTYONE_A:		// Uses the twenty-second image found in "spr_map_borders".
			case CELL_TWENTYONE_B:		//						''
			case CELL_TWENTYONE_C:		//						''
			case CELL_TWENTYONE_D:		//						''
				return 21;
			case CELL_TWENTYTWO_A:		// Uses the twenty-third image found in "spr_map_borders".
			case CELL_TWENTYTWO_B:		//						''
			case CELL_TWENTYTWO_C:		//						''
			case CELL_TWENTYTWO_D:		//						''
				return 22;
			case CELL_TWENTYTHREE_A:	// Uses the twenty-fourth image found in "spr_map_borders".
			case CELL_TWENTYTHREE_B:	//						''
			case CELL_TWENTYTHREE_C:	//						''
			case CELL_TWENTYTHREE_D:	//						''
				return 23;
			case CELL_TWENTYFOUR_A:		// Uses the twenty-fifth image found in "spr_map_borders".
			case CELL_TWENTYFOUR_B:		//						''
			case CELL_TWENTYFOUR_C:		//						''
			case CELL_TWENTYFOUR_D:		//						''
				return 24;
			case CELL_TWENTYFIVE_A:		// Uses the twenty-sixth image found in "spr_map_borders".
			case CELL_TWENTYFIVE_B:		//						''
			case CELL_TWENTYFIVE_C:		//						''
			case CELL_TWENTYFIVE_D:		//						''
				return 25;
			case CELL_TWENTYSIX_A:		// Uses the twenty-seventh image found in "spr_map_borders".
			case CELL_TWENTYSIX_B:		//						''
			case CELL_TWENTYSIX_C:		//						''
			case CELL_TWENTYSIX_D:		//						''
				return 26;
			case CELL_TWENTYSEVEN_A:	// Uses the twenty-eighth image found in "spr_map_borders".
			case CELL_TWENTYSEVEN_B:	//						''
			case CELL_TWENTYSEVEN_C:	//						''
			case CELL_TWENTYSEVEN_D:	//						''
				return 27;
			case CELL_TWENTYEIGHT_A:	// Uses the twenty-ninth image found in "spr_map_borders".
			case CELL_TWENTYEIGHT_B:	//						''
			case CELL_TWENTYEIGHT_C:	//						''
			case CELL_TWENTYEIGHT_D:	//						''
				return 28;
			case CELL_TWENTYNINE_A:		// Uses the thirtieth image found in "spr_map_borders".
			case CELL_TWENTYNINE_B:		//						''
			case CELL_TWENTYNINE_C:		//						''
			case CELL_TWENTYNINE_D:		//						''
				return 28;
		}
	}
	
	/// @description Gets the corresponding color that matches the type of door that is passed into the function's
	/// argument parameter. If an invalid index is provided, the "any beam" doorway's color is returned.
	/// @param {Real}	doorIndex		// Value relating to the door's internal numerical type within the map system's data.
	door_get_color = function(_doorIndex){
		switch(_doorIndex){
			default:
			case CELL_DOOR_ANYWEAPON:		return HEX_BLUE;
			case CELL_DOOR_ICEBEAM:			return HEX_VERY_LIGHT_BLUE;
			case CELL_DOOR_WAVEBEAM:		return HEX_PURPLE;
			case CELL_DOOR_PLASMABEAM:		return HEX_DARK_ORANGE;
			case CELL_DOOR_MISSILE:			return HEX_RED;
			case CELL_DOOR_SPR_MISSILE:		return HEX_LIGHT_GREEN;
			case CELL_DOOR_POWER_BOMB:		return HEX_YELLOW;
		}
	}
}

#endregion

#region Global functions related to obj_map_manager

/// @description Initializes the visual portion of the map system by setting the width and height of said map
/// in cells, which then determines how large the surface/buffer for the visual aspect of the map will be. 
/// This also activates the map so it can update itself during the player's gameplay.
/// @param {Real}	areaIndex		The index for the area that will have its map initialized.
/// @param {Real}	width			How many columns exist for the initialized area's map.
/// @param {Real}	height			How many rows exist for the initialized area's map.
function map_initialize(_areaIndex, _width, _height){
	with(MAP_MANAGER){
		// Don't attempt to initialize a map for an area if the map is currently set to active.
		if (MAP_IS_ACTIVE) {return;}
		stateFlags |= MAP_ACTIVE | MAP_INIT_SURFACE;
		
		// Always delete the previous buffer if one happens to exist.
		if (mapSurfBuffer != -1) 
			buffer_delete(mapSurfBuffer);
			
		// Determine the total size of the buffer by multiplying the width and height of the map in cells by
		// the dimensions of the cell itself on the map's surface. These values are multiplied with each other
		// and then multiplied again by 4 to account for the fact that each color is a 32-bit number.
		var _bufferWidth	= _width * sprite_get_width(spr_map_borders);
		var _bufferHeight	= _height * sprite_get_height(spr_map_borders);
		mapSurfBuffer		= buffer_create(_bufferWidth * _bufferHeight * 4, buffer_fast, buffer_u8);
	
		// Create the area's required data structures should it not exist yet, and populate each with the data
		// that said data structure represents. If these data structures already exist, this step is skipped.
		if (!ds_exists(mapData[_areaIndex], ds_type_map)){
			mapData[_areaIndex]		= ds_map_create();
			iconData[_areaIndex]	= ds_map_create();
			doorData[_areaIndex]	= ds_map_create();
			
			// TODO -- Call to load the area's map here.
		}
		
		// Assign the map's width and height to their respective variables, and then update the current area
		// index to match the one that just had its map initialized.
		mapWidth	= _width;
		mapHeight	= _height;
		curArea		= _areaIndex;
	}
}

/// @description Determines the positional offset of the current room on the current area's map. The player's
/// current cell is then derived using this origin value alongside their current position within the room.
/// @param {Real}	x	The column that the top-left cell of the room is found at on the map.
/// @param {Real}	y	The row that the top-left cell of the room is found at on the map.
function map_set_room_origin(_x, _y){
	with(MAP_MANAGER){
		if (!MAP_CAN_SET_ROOM_OFFSET)
			return;
		
		curRoomX = _x;
		curRoomY = _y;
	}
}

#endregion