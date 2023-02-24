#region Initializing any macros that are useful/related to the event handler

// A macro to simplify the look of the code whenever the event flag buffer needs to be referenced.
#macro	EVENT_HANDLER			global.eventFlags

// Macro that determines the total number of event flags that exist for the game to use. The value is 1/8th
// of the total number of flags because buffers can only be created in bytes at the smallest. The true value
// will be the macro times 8, as a result.
#macro	TOTAL_EVENT_FLAG_BYTES	64	// 64 bytes * 8 = 512 flags

// Macro to represent a value that will cause the functions "event_set_flag" and "event_get_flag" to perform
// no event flag manipulation. Useful for systems that have to automatically call either function in order
// to account for scenarios where a flag is used and also not used.
#macro	INVALID_FLAG		   -100

// Item event flags. When these are true, Samus will have access to the abilities they provide and the item
// objects that exist in the world representing these items for her to collect will also no longer spawn.
#macro	FLAG_VARIA_SUIT			0		// Suit upgrades
#macro	FLAG_GRAVITY_SUIT		1
#macro	FLAG_HIJUMP_BOOTS		2		// Jump upgrades
#macro	FLAG_SPACE_JUMP			3
#macro	FLAG_SCREW_ATTACK		4
#macro	FLAG_ICE_BEAM			5		// Arm cannon upgrades
#macro	FLAG_WAVE_BEAM			6
#macro	FLAG_PLASMA_BEAM		7
#macro	FLAG_BEAM_SPLITTER		8
#macro	FLAG_CHARGE_BEAM		9
#macro	FLAG_SCAN_PULSE			10		// Aeion abilities
#macro	FLAG_PHASE_SHIFT		11
#macro	FLAG_ENERGY_SHIELD		12
#macro	FLAG_MORPHBALL			13		// Morphball and its abilities
#macro	FLAG_SPRING_BALL		14
#macro	FLAG_SPIDER_BALL		15
#macro	FLAG_BOMBS				16
#macro	FLAG_PULSE_BOMBS		17
#macro	FLAG_POWER_BOMBS		18
#macro	FLAG_MISSILES			19		// Missiles and their upgrades
#macro	FLAG_SUPER_MISSILES		20
#macro	FLAG_ICE_MISSILES		21
#macro	FLAG_SHOCK_MISSILES		22
#macro	FLAG_LOCK_ON_MISSILES	23
// Bits 24 to 31 are left unused in case new upgraded items are added throughout development.

// Missile tank flags; collecting one in the world will flip this flag and prevent it from spawning again.
// There are 60 total to find in the game, and will occupy the bits 32-91 as a reault. Each small missile tank
// object will have its own offset out of 60 relative to this initial bit's position, so this is the only
// macro that is required.
#macro	SMALL_MISSILE_TANK0		32
//								 .
//								 .
//								91

// The bit flags used for the large missile tanks that can be found in the game, of which there are 12 total.
// As a result, they will occupy bits 92-103 in the event flag buffer.
#macro	LARGE_MISSILE_TANK0		92
//								 .
//								 .
//								103

// Power bomb tanks flags. They function just like the small and large missile tank flags, but they occupy the
// 104-115th bits in the buffer, so the 12 bit flag right after the 12 large missile tank flags.
#macro	POWER_BOMB_TANK0		104
//								 .
//								 .
//								115

// Bit flags from the 116th bit to the 123rd that are occupied by the complete energy tanks that Samus can pick
// up in the game world. They function just like every other "expansion item" that can be collected.
#macro	ENERGY_TANK0			116
//								 .
//								 .
//								123

// The bit flags that are occupied by each of the 16 energy tank pieces that the player can find throughout the
// game's world. They represent 1/4th of a full energy tank, so collecting 4 will expand Samus's energy by 100
// units. There are sixteen, so bits 124-137 will be used for these collectibles.
#macro	ENERGY_TANK_PIECE0		124
//								 .
//								 .
//								137

// Reserve tank bit flags, which will occupy the 138th to the 141st bits in the buffer. They allow Samus to
// store energy that is consumed when she would've died by her main energy reaching 0.
#macro	RESERVE_TANK0			138
//								 .
//								 .
//								141

// Bit flags for the aeion tanks that Samus can collect throughout the game world. There are a total of four
// to find, which expand her aeion storage by 10 units each. Their collection flags occupy the 142nd to the
// 145th bits in the event flag buffer.
#macro	AEION_TANK0				142
//								 .
//								 .
//								145

// 
#macro	FLAG_SPECIAL_DOOR0		150

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

#endregion