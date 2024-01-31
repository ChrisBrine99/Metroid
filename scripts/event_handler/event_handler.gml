#region Initializing any macros that are useful/related to the event handler

// ------------------------------------------------------------------------------------------------------- //
//	A macro to simplify the look of the code whenever the event flag buffer needs to be referenced.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	EVENT_HANDLER			global.eventFlags

// ------------------------------------------------------------------------------------------------------- //
//	Macro that determines the total number of event flags that exist for the game to use. The value is     //
//	1/8th of the total number of flags because buffers can only be created in bytes at the smallest. The   //
//	true value will be the macro times 8, as a result.													   //
// ------------------------------------------------------------------------------------------------------- //

#macro	TOTAL_EVENT_FLAG_BYTES	64	// 64 bytes * 8 = 512 flags

// ------------------------------------------------------------------------------------------------------- //
//	Macro to represent a value that will cause the functions "event_set_flag" and "event_get_flag" to	   //
//	perform no event flag manipulation. Useful for systems that have to automatically call either function //
//	in order to account for scenarios where a flag is used and also not used.							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	INVALID_FLAG		   -100

// ------------------------------------------------------------------------------------------------------- //
//	Item event flags. When these are true, Samus will have access to the abilities they provide and the	   //
//	item objects that exist in the world representing these items for her to collect will also no longer   //
//	spawn.																								   //
// ------------------------------------------------------------------------------------------------------- //

#macro	FLAG_VARIA_SUIT			0x00	// Suit upgrades
#macro	FLAG_GRAVITY_SUIT		0x01
#macro	FLAG_HIJUMP_BOOTS		0x02	// Jump upgrades
#macro	FLAG_SPACE_JUMP			0x03
#macro	FLAG_SCREW_ATTACK		0x04
#macro	FLAG_ICE_BEAM			0x05	// Arm cannon upgrades
#macro	FLAG_WAVE_BEAM			0x06
#macro	FLAG_PLASMA_BEAM		0x07
#macro	FLAG_BEAM_SPLITTER		0x08
#macro	FLAG_CHARGE_BEAM		0x09
#macro	FLAG_ENERGY_SHIELD		0x0A	// Aeion abilities
#macro	FLAG_PHASE_SHIFT		0x0B
#macro	FLAG_SCAN_PULSE			0x0C
#macro	FLAG_MORPHBALL			0x0D	// Morphball and its abilities
#macro	FLAG_SPRING_BALL		0x0E
#macro	FLAG_SPIDER_BALL		0x0F
#macro	FLAG_BOMBS				0x10
#macro	FLAG_PULSE_BOMBS		0x11
#macro	FLAG_POWER_BOMBS		0x12
#macro	FLAG_MISSILES			0x13	// Missiles and their upgrades
#macro	FLAG_SUPER_MISSILES		0x14
#macro	FLAG_ICE_MISSILES		0x15
#macro	FLAG_SHOCK_MISSILES		0x16
#macro	FLAG_LOCK_ON_MISSILES	0x17
// Bits 24 to 31 are left unused in case new items are added throughout development.

// ------------------------------------------------------------------------------------------------------- //
//	Missile tank flags; collecting one in the world will flip this flag and prevent it from spawning	   //
//	again. There are 60 total to find in the game, and will occupy the bits 32-91 as a reault. Each small  //
//	missile tank object will have its own offset out of 60 relative to this initial bit's position, so	   //
//	this is the only macro that is required.															   //
// ------------------------------------------------------------------------------------------------------- //

#macro	SMALL_MISSILE_TANK01	0x20
//								 .
//								 .
//								0x5B

// ------------------------------------------------------------------------------------------------------- //
//	The bit flags used for the large missile tanks that can be found in the game, of which there are 12	   //
//	total. As a result, they will occupy bits 92-103 in the event flag buffer.							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	LARGE_MISSILE_TANK01	0x5C
//								 .
//								 .
//								0x67

// ------------------------------------------------------------------------------------------------------- //
//	Power bomb tanks flags. They function just like the small and large missile tank flags, but they	   //
//	occupy the 104-115th bits in the buffer, so the 12 bit flags ahead of the 12 large missile tank flags. //
// ------------------------------------------------------------------------------------------------------- //

#macro	POWER_BOMB_TANK0		0x68
//								 .
//								 .
//								0x73

// ------------------------------------------------------------------------------------------------------- //
//	Bit flags from the 116th bit to the 123rd that are occupied by the complete energy tanks that Samus	   //
//	can pick up in the game world. They function just like every other "expansion item" that can be		   //
//	collected.																							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENERGY_TANK0			0x74
//								 .
//								 .
//								0x7B

// ------------------------------------------------------------------------------------------------------- //
//	The bit flags that are occupied by each of the 16 energy tank pieces that the player can find		   //
//	throughout the game's world. They represent 1/4th of a full energy tank, so collecting 4 will expand   //
//	Samus's energy by 100 units. There are sixteen, so bits 124-137 will be used for these collectibles.   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENERGY_TANK_PIECE0		0x7C
//								 .
//								 .
//								0x89

// ------------------------------------------------------------------------------------------------------- //
//	Reserve tank bit flags, which will occupy the 138th to the 141st bits in the buffer. They allow Samus  //
//	to store energy that is consumed when she would've died by her main energy reaching 0.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	RESERVE_TANK0			0x8A
//								 .
//								 .
//								0x8D

// ------------------------------------------------------------------------------------------------------- //
//	Bit flags for the aeion tanks that Samus can collect throughout the game world. There are a total of   //
//	four to find, which expand her aeion storage by 10 units each. Their collection flags occupy the 142nd //
//	to the 145th bits in the event flag buffer.															   //
// ------------------------------------------------------------------------------------------------------- //

#macro	AEION_TANK0				0x8E
//								 .
//								 .
//								0x91

// ------------------------------------------------------------------------------------------------------- //
// 
// ------------------------------------------------------------------------------------------------------- //

#macro	FLAG_SPECIAL_DOOR0		0x96
#macro	FLAG_SPECIAL_DOOR1		0x97

#endregion

#region Initializing enumerators that are useful/related to the event handler
#endregion

#region Initializing any globals that are useful/related to the event handler

// The buffer that stores all the event flags in the game. It is aligned to the smallest value possible of
// a single bit, so the total number of event flags is the buffer's size multiplied by 8. As a result, it
// uses basically no memory, and it's extremely efficient when setting/getting flag states.
global.eventFlags = buffer_create(TOTAL_EVENT_FLAG_BYTES, buffer_fast, 1);

#endregion

#region Global functions related to the event handler

/// @description Sets the desired bit within the event flag buffer to the desired state value. If the ID value
/// for the flag exceeds the total number of bits found in the buffer no flag will be set and the function will
/// simply exit prematurely.
/// @param {Real}	flagID		The position of this flag's bit relative to the start of the buffer.
/// @param {Bool}	flagState	The state to set the flag bit. (0 = False, 1 = True).
function event_set_flag(_flagID, _flagState){
	var _offset = (_flagID >> 3); // Calculates the byte-aligned offset that the flag bit is found.
	if (_flagID == INVALID_FLAG || _offset >= TOTAL_EVENT_FLAG_BYTES) {return;}
	
	// Grab the byte that contains the desired bit from the event flag buffer (There's no way to grab a single
	// bit from a buffer; smallest amount is 8 bits per read) and set the flag bit or clear it depending on
	// what the function calls for. Then, overwrite that original buffer byte with the new data.
	var _data = buffer_peek(EVENT_HANDLER, _offset, buffer_u8);
	if (_flagState)	{_data = _data |	(1 << (_flagID & 7));}
	else			{_data = _data &   ~(1 << (_flagID & 7));}
	buffer_poke(EVENT_HANDLER, _offset, buffer_u8, _data);
}

/// @description Grabs the state of the flag given the ID value provided. Exceeding the total number of bytes
/// in the event flag buffer with a given ID value will prevent any flag check and simply return false.
/// @param {Real}	flagID		The position of this requested flag's bit relative to the first bit in the buffer.
function event_get_flag(_flagID){
	var _offset = (_flagID >> 3); // Calculates the byte-aligned offset that the flag bit is found.
	if (_flagID == INVALID_FLAG || _offset >= TOTAL_EVENT_FLAG_BYTES) {return false;}
	
	// Grab the byte that contains the bit from the buffer. Then, perform a bitwise and with a value that will
	// have the desired bit set to 1 and all other bits set to zero. This way all other bits in the byte that
	// is being used for the comparison are ignored in the result of this get_flag function.
	return (buffer_peek(EVENT_HANDLER, _offset, buffer_u8) & (1 << (_flagID & 7)) != 0);
}

/// @description Gets the total percentage of items that have been collected by the player throught their
/// current playthrough. It does this by checking each item's bit and taking the total number of 1s found
/// and dividing that by the total sum of bits; returning it as a rounded value between 0 and 100.
function event_get_item_percentage(){
	var _totalItems = AEION_TANK0 + 3; // 145th bit is the final item ("AEION_TANK0" represents bit 142)
	var _collectedItems = 0;
	for (var i = 0; i < _totalItems; i++){
		if (i > FLAG_LOCK_ON_MISSILES && i < SMALL_MISSILE_TANK0) // Skip over unused bits
			continue;
		_collectedItems += event_get_flag(i);
	}
	// Remove the unnecessary bits after the loop to avoid missing the last few bits if done before.
	// Then, return the ratio between this value and the calculated amount of collected items.
	_totalItems -= (SMALL_MISSILE_TANK0 - FLAG_LOCK_ON_MISSILES);
	return round(_collectedItems / _totalItems) * 100;
}

#endregion