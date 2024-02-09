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

#macro	SMALL_MISSILE_TANK01	0x20	// Used in "rm_areaone_04" by inst_2ABF6D5F
#macro	SMALL_MISSILE_TANK02	0x21
#macro	SMALL_MISSILE_TANK03	0x22
#macro	SMALL_MISSILE_TANK04	0x23
#macro	SMALL_MISSILE_TANK05	0x24
#macro	SMALL_MISSILE_TANK06	0x25
#macro	SMALL_MISSILE_TANK07	0x26
#macro	SMALL_MISSILE_TANK08	0x27
#macro	SMALL_MISSILE_TANK09	0x28
#macro	SMALL_MISSILE_TANK10	0x29
#macro	SMALL_MISSILE_TANK11	0x2A
#macro	SMALL_MISSILE_TANK12	0x2B
#macro	SMALL_MISSILE_TANK13	0x2C
#macro	SMALL_MISSILE_TANK14	0x2D
#macro	SMALL_MISSILE_TANK15	0x2E
#macro	SMALL_MISSILE_TANK16	0x2F
#macro	SMALL_MISSILE_TANK17	0x30
#macro	SMALL_MISSILE_TANK18	0x31
#macro	SMALL_MISSILE_TANK19	0x32
#macro	SMALL_MISSILE_TANK20	0x33
#macro	SMALL_MISSILE_TANK21	0x34
#macro	SMALL_MISSILE_TANK22	0x35
#macro	SMALL_MISSILE_TANK23	0x36
#macro	SMALL_MISSILE_TANK24	0x37
#macro	SMALL_MISSILE_TANK25	0x38
#macro	SMALL_MISSILE_TANK26	0x39
#macro	SMALL_MISSILE_TANK27	0x3A
#macro	SMALL_MISSILE_TANK28	0x3B
#macro	SMALL_MISSILE_TANK29	0x3C
#macro	SMALL_MISSILE_TANK30	0x3D
#macro	SMALL_MISSILE_TANK31	0x3E
#macro	SMALL_MISSILE_TANK32	0x3F
#macro	SMALL_MISSILE_TANK33	0x40
#macro	SMALL_MISSILE_TANK34	0x41
#macro	SMALL_MISSILE_TANK35	0x42
#macro	SMALL_MISSILE_TANK36	0x43
#macro	SMALL_MISSILE_TANK37	0x44
#macro	SMALL_MISSILE_TANK38	0x45
#macro	SMALL_MISSILE_TANK39	0x46
#macro	SMALL_MISSILE_TANK40	0x47
#macro	SMALL_MISSILE_TANK41	0x48
#macro	SMALL_MISSILE_TANK42	0x49
#macro	SMALL_MISSILE_TANK43	0x4A
#macro	SMALL_MISSILE_TANK44	0x4B
#macro	SMALL_MISSILE_TANK45	0x4C
#macro	SMALL_MISSILE_TANK46	0x4D
#macro	SMALL_MISSILE_TANK47	0x4E
#macro	SMALL_MISSILE_TANK48	0x4F
#macro	SMALL_MISSILE_TANK49	0x50
#macro	SMALL_MISSILE_TANK50	0x51
#macro	SMALL_MISSILE_TANK51	0x52
#macro	SMALL_MISSILE_TANK52	0x53
#macro	SMALL_MISSILE_TANK53	0x54
#macro	SMALL_MISSILE_TANK54	0x55
#macro	SMALL_MISSILE_TANK55	0x56
#macro	SMALL_MISSILE_TANK56	0x57
#macro	SMALL_MISSILE_TANK57	0x58
#macro	SMALL_MISSILE_TANK58	0x59
#macro	SMALL_MISSILE_TANK59	0x5A
#macro	SMALL_MISSILE_TANK60	0x5B

// ------------------------------------------------------------------------------------------------------- //
//	The bit flags used for the large missile tanks that can be found in the game, of which there are 12	   //
//	total. As a result, they will occupy bits 92-103 in the event flag buffer.							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	LARGE_MISSILE_TANK01	0x5C	// Used in "rm_areaone_02" by inst_3404912F
#macro	LARGE_MISSILE_TANK02	0x5D
#macro	LARGE_MISSILE_TANK03	0x5E
#macro	LARGE_MISSILE_TANK04	0x5F
#macro	LARGE_MISSILE_TANK05	0x60
#macro	LARGE_MISSILE_TANK06	0x61
#macro	LARGE_MISSILE_TANK07	0x62
#macro	LARGE_MISSILE_TANK08	0x63
#macro	LARGE_MISSILE_TANK09	0x64
#macro	LARGE_MISSILE_TANK10	0x65
#macro	LARGE_MISSILE_TANK11	0x66
#macro	LARGE_MISSILE_TANK12	0x67

// ------------------------------------------------------------------------------------------------------- //
//	Power bomb tanks flags. They function just like the small and large missile tank flags, but they	   //
//	occupy the 104-115th bits in the buffer, so the 12 bit flags ahead of the 12 large missile tank flags. //
// ------------------------------------------------------------------------------------------------------- //

#macro	POWER_BOMB_TANK01		0x68	
#macro	POWER_BOMB_TANK02		0x69
#macro	POWER_BOMB_TANK03		0x6A
#macro	POWER_BOMB_TANK04		0x6B
#macro	POWER_BOMB_TANK05		0x6C
#macro	POWER_BOMB_TANK06		0x6D
#macro	POWER_BOMB_TANK07		0x6E
#macro	POWER_BOMB_TANK08		0x6F
#macro	POWER_BOMB_TANK09		0x70
#macro	POWER_BOMB_TANK10		0x71
#macro	POWER_BOMB_TANK11		0x72
#macro	POWER_BOMB_TANK12		0x73

// ------------------------------------------------------------------------------------------------------- //
//	Bit flags from the 116th bit to the 123rd that are occupied by the complete energy tanks that Samus	   //
//	can pick up in the game world. They function just like every other "expansion item" that can be		   //
//	collected.																							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENERGY_TANK01			0x74
#macro	ENERGY_TANK02			0x75
#macro	ENERGY_TANK03			0x76
#macro	ENERGY_TANK04			0x77
#macro	ENERGY_TANK05			0x78
#macro	ENERGY_TANK06			0x79
#macro	ENERGY_TANK07			0x7A
#macro	ENERGY_TANK08			0x7B

// ------------------------------------------------------------------------------------------------------- //
//	The bit flags that are occupied by each of the 16 energy tank pieces that the player can find		   //
//	throughout the game's world. They represent 1/4th of a full energy tank, so collecting 4 will expand   //
//	Samus's energy by 100 units. There are sixteen, so bits 124-137 will be used for these collectibles.   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENERGY_TANK_PIECE01		0x7C
#macro	ENERGY_TANK_PIECE02		0x7D
#macro	ENERGY_TANK_PIECE03		0x7E
#macro	ENERGY_TANK_PIECE04		0x7F
#macro	ENERGY_TANK_PIECE05		0x80
#macro	ENERGY_TANK_PIECE06		0x81
#macro	ENERGY_TANK_PIECE07		0x82
#macro	ENERGY_TANK_PIECE08		0x83
#macro	ENERGY_TANK_PIECE09		0x84
#macro	ENERGY_TANK_PIECE10		0x85
#macro	ENERGY_TANK_PIECE11		0x86
#macro	ENERGY_TANK_PIECE12		0x87
#macro	ENERGY_TANK_PIECE13		0x88
#macro	ENERGY_TANK_PIECE14		0x89
#macro	ENERGY_TANK_PIECE15		0x8A
#macro	ENERGY_TANK_PIECE16		0x8B

// ------------------------------------------------------------------------------------------------------- //
//	Reserve tank bit flags, which will occupy the 140th to the 143rd bits in the buffer. They allow Samus  //
//	to store energy that is consumed when she would've died by her main energy reaching 0.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	RESERVE_TANK01			0x8C
#macro	RESERVE_TANK02			0x8D
#macro	RESERVE_TANK03			0x8E
#macro	RESERVE_TANK04			0x8F

// ------------------------------------------------------------------------------------------------------- //
//	Bit flags for the aeion tanks that Samus can collect throughout the game world. There are a total of   //
//	five to find, which expand her aeion storage by 10 units each. Their collection flags occupy the 144th //
//	to the 147th bits in the event flag buffer.															   //
// ------------------------------------------------------------------------------------------------------- //

#macro	AEION_TANK01			0x90
#macro	AEION_TANK02			0x91
#macro	AEION_TANK03			0x92
#macro	AEION_TANK04			0x93
#macro	AEION_TANK05			0x94

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	FLAG_SPECIAL_DOOR01		0x95	// Used in "rm_areaone_02" by inst_7990F49A
#macro	FLAG_SPECIAL_DOOR02		0x96	// Used in "rm_areaone_03" by inst_290123A9
#macro	FLAG_SPECIAL_DOOR03		0x97	// Used in "rm_areaone_02" by inst_FF14D5B

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