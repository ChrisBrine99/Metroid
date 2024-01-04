// Call the code for this event from par_collectible, which is responsible for checking if the item needs to be
// deleted if it has already been collected by Samus.
event_inherited();

// If Samus doesn't have access to her Missile Launcher prior to collecting this tank of missiles, the fanfare
// and item ID will be changed to signify that the item is currently unknown to her Power Suit and cannot be used
// until another item (The Missile Launcher) is collected first.
if (!event_get_flag(FLAG_MISSILES)){
	itemID = ID_UNKNOWN_ITEM;
	// TODO -- Change fanfare to an 8-bit rendition of the unknown item found fanfare from Zero Mission.
}