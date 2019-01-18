/// @description Initializing menu stuff
// You can write your code in this editor

// Call the parent's create event
event_inherited();

yOffset = 30;
textGap = 30;

// Create the menu
menuSize = 5;
scr_create_menu(menuSize);

// Editing the menu option's for the Main Menu
menuOption[0] = "File 01";
menuOption[1] = "File 02";
menuOption[2] = "File 03";
menuOption[3] = "Options";
menuOption[4] = "Exit Game";

// Create an array to hold all of the energy and time data form the save file
for (var i = 0; i < 3; i++){
	if (file_exists("File0" + string(i + 1) + ".dat")){
		var data = ds_map_secure_load("File0" + string(i + 1) + ".dat");
		// Loading in the file's energy tank data
		enData[i] = ds_map_find_value(data, "Energy");
		eTankData[i] = ds_map_find_value(data, "EnergyTanks");
		eTankMaxData[i] = ds_map_find_value(data, "MaxEnergyTanks");
		// Loading in the file's time data
		hourData[i] = ds_map_find_value(data, "Hours");
		minuteData[i] = ds_map_find_value(data, "Minutes");
		// Loading in the file's missile, super missile, power bomb, and beam data
		beamData[i] = ds_map_find_value(data, "MaxBeamIndex") + 1;
		missData[i] = ds_map_find_value(data, "NumMissMax");
		sMissData[i] = ds_map_find_value(data, "NumSMissMax");
		pBombData[i] = ds_map_find_value(data, "NumPBombsMax");
	}
	else{
		enData[i] = 0;
		eTankData[i] = 0;
		eTankMaxData[i] = 0;
		hourData[i] = 0;
		minuteData[i] = 0;
		beamData[i] = 0;
		missData[i] = 0;
		sMissData[i] = 0;
		pBombData[i] = 0;
	}
}