/// @description Exiting the Game if Necessary
// You can write your code in this editor

if (exitingGame){
	game_end();	
} else{
	// Call the parent object's destroy event
	event_inherited();
}