/// @description Saves all of the required data into a single encrypted .dat file.
/// @param filename

// Temporary variables to hold the filename and ds_map
var filename, data, txtFile;
filename = argument0 + ".dat";
data = ds_map_create();
			
// Save the current room and samus's position within the room
ds_map_add(data, "xPos", obj_samus.x);
ds_map_add(data, "yPos", obj_samus.y);
ds_map_add(data, "curRoom", room_get_name(room));

// Save the current time that the player has played
ds_map_add(data, "Hours", global.hours);
ds_map_add(data, "Minutes", global.minutes);
ds_map_add(data, "Seconds", global.seconds);
			
// Saving all item variables
ds_map_add(data, "Morphball", global.morphball);
ds_map_add(data, "Bombs", global.bombs);
ds_map_add(data, "SpiderBall", global.spiderBall);
ds_map_add(data, "SpringBall", global.springBall);
ds_map_add(data, "HighJump", global.highJump);
ds_map_add(data, "SpaceJump", global.spaceJump);
ds_map_add(data, "ScrewAttack", global.screwAttack);
ds_map_add(data, "VariaSuit", global.variaSuit);
ds_map_add(data, "GravSuit", global.gravitySuit);
ds_map_add(data, "IceBeam", global.iceBeam);
ds_map_add(data, "WaveBeam", global.waveBeam);
ds_map_add(data, "SpazerBeam", global.spazerBeam);
ds_map_add(data, "PlasmaBeam", global.plasmaBeam);
			
// Saving the current and max number of missiles, super missiles and power bombs
ds_map_add(data, "NumMiss", global.missiles);
ds_map_add(data, "NumMissMax", global.missilesMax);
ds_map_add(data, "NumSMiss", global.sMissiles);
ds_map_add(data, "NumSMissMax", global.sMissilesMax);
ds_map_add(data, "NumPBombs", global.pBombs);
ds_map_add(data, "NumPBombsMax", global.pBombsMax);
			
// Saving Samus's current energy and how many energy tanks she has
ds_map_add(data, "Energy", global.energy);
ds_map_add(data, "EnergyTanks", global.eTanks);
ds_map_add(data, "MaxEnergyTanks", global.eTanksMax);
			
// Saving the max and current equipment index/beam index
ds_map_add(data, "CurEquipIndex", global.curEquipmentIndex);
ds_map_add(data, "MaxEquipIndex", global.maxEquipmentIndex);
ds_map_add(data, "CurBeamIndex", global.curBeamIndex);
ds_map_add(data, "MaxBeamIndex", global.maxBeamIndex);
			
// Saving what missile, super missile, and power bomb tanks have been acquired; along with energy tanks
for (var m = 0; m < array_length_1d(global.missile); m++){
	ds_map_add(data, "Miss" + string(m), global.missile[m]);
}
for (var sm = 0; sm < array_length_1d(global.sMissile); sm++){
	ds_map_add(data, "SMiss" + string(sm), global.sMissile[sm]);
}
for (var pb = 0; pb < array_length_1d(global.pBomb); pb++){
	ds_map_add(data, "PBomb" + string(pb), global.pBomb[pb]);
}
for (var e = 0; e < array_length_1d(global.eTank); e++){
	ds_map_add(data, "ETank" + string(e), global.eTank[e]);
}

// Saving what events have already been triggered and what special doors have been opened
for (var sp = 0; sp < array_length_1d(global.spDoor); sp++){
	ds_map_add(data, "SpDoors" + string(sp), global.spDoor[sp]);	
}
for (var ev = 0; ev < array_length_1d(global.event); ev++){
	ds_map_add(data, "Event" + string(ev), global.event[ev]);	
}
			
// Encrypt the file
ds_map_secure_save(data, filename);