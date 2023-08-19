#region	Initializing any macros that are useful/related to obj_map_manager

// 
#macro	MAP_GRID_WIDTH			160
#macro	MAP_GRID_HEIGHT			90

// 
#macro	TILE_EMPTY				0

#endregion

#region Initializing enumerators that are useful/related to obj_map_manager
#endregion

#region Initializing any globals that are useful/related to obj_map_manager
#endregion

#region The main object code for obj_map_manager

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_map_manager(_index) : base_struct(_index) constructor{
	// 
	mapData = -1;
	
	// 
	cells = ds_grid_create(MAP_GRID_WIDTH, MAP_GRID_HEIGHT);
	ds_grid_clear(cells, noone);
	
	// 
	cellWidth	= 0;
	cellHeight	= 0;
	
	// 
	rOriginX	= 12;
	rOriginY	= 12;
	pMapX		= 0.0;
	pMapY		= 0.0;
	
	/// @description 
	end_step = function(){
		var _playerX = 0;
		var _playerY = 0;
		with(PLAYER){
			_playerX = x;
			_playerY = y;
		}
		
		pMapX = rOriginX + (_playerX / cellWidth);
		pMapY = rOriginY + (_playerY / cellHeight);
	}
	
	/// @description 
	cleanup = function(){
		var _cell = noone;
		for (var xx = 0; xx < MAP_GRID_WIDTH; xx++){
			for (var yy = 0; yy < MAP_GRID_HEIGHT; yy++){
				_cell = cells[# xx, yy];
				if (_cell != noone) {delete _cell;}
			}
		}
		ds_grid_destroy(cells);
	}
	
	/// @description 
	/// @param {Real}	x			
	/// @param {Real}	y		
	/// @param {Real}	tileData		
	/// @param {Real}	isExplored
	initialize_map_cell = function(_x, _y, _tileData, _isExplored){
		// 
		if (_x < 0 || _x >= MAP_GRID_WIDTH || _y < 0 || _y >= MAP_GRID_HEIGHT 
				|| cells[# _x, _y] != noone) {return;}
				
		// 
		//cells[# _x, _y] = {
		//	tileData	:	_tileData,
		//	//	NOTE -- The variable "tileData" stores multiple pieces of data inside itself to determine how 
		//	//	it will be drawn on the map. This data is stored in the following order; from its lowest bit to 
		//	//	its highest bit--using 8 bit chunks:
		//	//
		//	//			1	--	Border Image
		//	//			2	--	Icon Image		(Optional)
		//	//			3	--	Door Formation	(Optional)
		//	//			4	--	UNUSED
		//	// 
		//	isExplored	:	false,
		//};
	}
}

#endregion

#region Global functions related to obj_map_manager

/// @description Sets the current room's origin, which is used in tandem with Samus's "room cell" position to
/// determine which cell she appears to be occupying on the current world map.
/// @param {Real}	x	Position on the x-axis for the top-left cell of the current room on the map.
/// @param {Real}	y	Position on the y-axis for the top-left cell of the current room on the map.
function map_set_room_origin(_x, _y){
	if (_x < 0 || _x >= MAP_GRID_WIDTH || _y < 0 || _y >= MAP_GRID_HEIGHT) {return;}
	with(MAP_MANAGER){
		rOriginX = _x;
		rOriginY = _y;
	}
}

#endregion