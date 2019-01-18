/// @description Insert description here
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Button Functionality
if (selectedOption == curOption){
	switch(selectedOption){
		case 0: // Deleting the file
			with(obj_main_menu){
				var filename = "File0" + string(curOption + 1) + ".dat";
				// Check if the file exists
				if (file_exists(filename)){
					file_delete(filename);
					// Return all the menu display variables to zero
					enData[curOption] = 0;
					eTankData[curOption] = 0;
					eTankMaxData[curOption] = 0;
					hourData[curOption] = 0;
					minuteData[curOption] = 0;
					beamData[curOption] = 0;
					missData[curOption] = 0;
					sMissData[curOption] = 0;
					pBombData[curOption] = 0;
				}
			}
			break;
	}
	nextMenu = -1;
	menuTransition = true;
}