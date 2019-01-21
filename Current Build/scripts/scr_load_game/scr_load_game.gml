/// @description Loads the desired save file if it exists.
/// @param filename

// Variable to hold the name of the file that is gonna be loaded
var filename = argument0 + ".dat";
if (file_exists(filename)){
	var data, samusX, samusY;
	// Load up the file
	data = ds_map_secure_load(filename);
	
	// Load in Samus's saved position
	samusX = ds_map_find_value(data, "xPos");
	samusY = ds_map_find_value(data, "yPos");
	instance_create_depth(samusX, samusY, 300, obj_samus);
				
	// Go to the correct save room
	room = asset_get_index(ds_map_find_value(data, "curRoom"));
	
	// Reload how long the player has been playing
	global.hours = ds_map_find_value(data, "Hours");
	global.minutes = ds_map_find_value(data, "Minutes");
	global.seconds = ds_map_find_value(data, "Seconds");
				
	// Load in the item data
	global.morphball = ds_map_find_value(data, "Morphball");
	global.bombs = ds_map_find_value(data, "Bombs");
	global.spiderBall = ds_map_find_value(data, "SpiderBall");
	global.springBall = ds_map_find_value(data, "SpringBall");
	global.highJump = ds_map_find_value(data, "HighJump");
	global.spaceJump = ds_map_find_value(data, "SpaceJump");
	global.screwAttack = ds_map_find_value(data, "ScrewAttack");
	global.variaSuit = ds_map_find_value(data, "VariaSuit");
	global.gravitySuit = ds_map_find_value(data, "GravSuit");
	global.iceBeam = ds_map_find_value(data, "IceBeam");
	global.waveBeam = ds_map_find_value(data, "WaveBeam");
	global.spazerBeam = ds_map_find_value(data, "SpazerBeam");
	global.plasmaBeam = ds_map_find_value(data, "PlasmaBeam");
				
	// Loading in the current and max number of missiles, super missiles, and power 
	global.missiles = ds_map_find_value(data, "NumMiss");
	global.missilesMax = ds_map_find_value(data, "NumMissMax");
	global.sMissiles = ds_map_find_value(data, "NumSMiss");
	global.sMissilesMax = ds_map_find_value(data, "NumSMissMax");
	global.pBombs = ds_map_find_value(data, "NumPBombs");
	global.pBombsMax = ds_map_find_value(data, "NumPBombsMax");
				
	// Loading in Samus' current energy
	global.energy = ds_map_find_value(data, "Energy");
	global.eTanks = ds_map_find_value(data, "EnergyTanks");
	global.eTanksMax = ds_map_find_value(data, "MaxEnergyTanks");
				
	// Load in the current equipment and beam indexes
	global.curEquipmentIndex = ds_map_find_value(data, "CurEquipIndex");
	global.maxEquipmentIndex = ds_map_find_value(data, "MaxEquipIndex");
	global.curBeamIndex = ds_map_find_value(data, "CurBeamIndex");
	global.maxBeamIndex = ds_map_find_value(data, "MaxBeamIndex");
				
	// Load in what missiles, super missiles, and power bombs have been acquired; along with energy tanks
	for (var m = 0; m < array_length_1d(global.missile); m++){
		global.missile[m] = ds_map_find_value(data, "Miss" + string(m));
	}
	for (var sm = 0; sm < array_length_1d(global.sMissile); sm++){
		global.sMissile[sm] = ds_map_find_value(data, "SMiss" + string(sm));
	}
	for (var pb = 0; pb < array_length_1d(global.pBomb); pb++){
		global.pBomb[pb] = ds_map_find_value(data, "PBomb" + string(pb));
	}
	for (var e = 0; e < array_length_1d(global.eTank); e++){
		global.eTank[e] = ds_map_find_value(data, "ETank" + string(e));
	}
	
	// Load in what events have already been triggered and what special doors have been opened
	for (var sp = 0; sp < array_length_1d(global.spDoor); sp++){
		global.spDoor[sp] = ds_map_find_value(data, "SpDoors" + string(sp));
	}
	for (var ev = 0; ev < array_length_1d(global.event); ev++){
		global.event[ev] = ds_map_find_value(data, "Event" + string(ev));
	}
}