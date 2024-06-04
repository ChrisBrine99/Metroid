#region Singleton Management Data Structure

// A map that stores pointers/references to all singletons that exist within the game currently. An object being
// in this list will prevent copies of them from being instantiated (When used in tandem with the new functions
// "instance_create_object" and "instance_create_struct").
global.sInstances = ds_map_create();

#endregion

#region Struct Management Globals

// A variable that uses an ID'ing system that works very similarly to how GameMaker's own instance ID system
// functions; giving each new instance of a struct (So long as they inherit from "base_struct" found below) a
// unique number that it can be identified with.
global.structID = 1000000;

// A list that manages the pointers for all struct instances created during the game's runtime. It will allow
// reference to these structs through their unique ID values; much like what Game Maker does with its objects.
global.structs = ds_list_create();

#endregion

#region Item data (Names and descriptions)

// A global data structure that stores information about an item's name and its description text.
global.items = ds_map_create();
// Creating the structs that will hold the name and information about the various items that player can pick
// up throughout the game world. These are all held in memory for the entirety of the game's runtime so all
// the string data never has to be re-initialized after this one time.
ds_map_add(global.items, ID_MORPH_BALL,	{
	itemName	: "MORPH BALL",
	itemInfo	: 
	@"Samus can now transform into a ball; allowing her to move through
	narrow passageways with ease."
});
ds_map_add(global.items, ID_SPRING_BALL, {
	itemName	: "SPRING BALL",
	itemInfo	: 
	@"Grants the Morph Ball the ability to perform a small jump."
});
ds_map_add(global.items, ID_SPIDER_BALL, {
	itemName	: "SPIDER BALL",
	itemInfo	: 
	@"Adds specialized tracks along the surface of the Morph Ball that
	allow it to cling onto walls and ceilings. The ability can be toggled
	on and off as needed."
});
ds_map_add(global.items, ID_VARIA_SUIT, {
	itemName	: "VARIA SUIT",
	itemInfo	: 
	@"Samus's Power Suit has been permanently augmented to withstand
	extreme temperatures; both hot and cold. On top of that, specialized
	fibers interwoven into the metal cut damage taken by 50 percent."
});
ds_map_add(global.items, ID_GRAVITY_SUIT, {
	itemName	: "GRAVITY SUIT",
	itemInfo	: 
	@"Samus's Power Suit has been permanently augmented to allow for
	movement in liquids with no hinderance. On top of that, improved
	defensive capabilities for the suit decrease all incoming damage
	by 25 percent."
});
ds_map_add(global.items, ID_HIGH_JUMP_BOOTS, {
	itemName	: "HIGH-JUMP BOOTS",
	itemInfo	: 
	@"Specialized micro-thrusters have been added to the boots of 
	Samus's Power Suit that briefly fire off when she executes a jump;
	vastly increasing her maximum jumping height."
});
ds_map_add(global.items, ID_SPACE_JUMP, {
	itemName	: "SPACE JUMP",
	itemInfo	: 
	@"A small device that enables the Power Suit to create a negative
	gravitational field for a very brief period while somersaulting;
	allowing Samus to jump even when in the air."
});
ds_map_add(global.items, ID_SCREW_ATTACK, {
	itemName	: "SCREW ATTACK",
	itemInfo	: 
	@"A weapon that augments Samus's somersault to create an extremely
	high electrical current all along the outside of the Power Suit."
});
ds_map_add(global.items, ID_ICE_BEAM, {
	itemName	: "ICE BEAM",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_WAVE_BEAM, {
	itemName	: "WAVE BEAM",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_PLASMA_BEAM, {
	itemName	: "PLASMA BEAM",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_CHARGE_BEAM, {
	itemName	: "CHARGE BEAM",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_MISSILE_LAUNCHER, {
	itemName	: "MISSILE LAUNCHER",
	itemInfo	: 
	@"Grants Samus's arm cannon the ability to fire powerful missiles.
	However, these missiles require ammunition when used and the Power
	Suit can only hold a limited capacity at any given time. They can
	also break the red shielding that cover certain doors."
});
ds_map_add(global.items, ID_SUPER_MISSILES, {
	itemName	: "SUPER MISSILES",
	itemInfo	: 
	@"Vastly improves the capabilities of Samus's standard missiles. 
	They move faster, hit harder, and can new destroy green shields 
	that cover certain doors."
});
ds_map_add(global.items, ID_ICE_MISSILES, {
	itemName	: "ICE MISSILES",
	itemInfo	: 
	@"A specialized type of missile that mimicks the elemental abilities
	of the standard Ice Beam. The main difference is these have a much
	higher damage output at the cost of using 5 missiles worth of ammo."
});
ds_map_add(global.items, ID_SHOCK_MISSILES, {
	itemName	: "SHOCK MISSILES",
	itemInfo	: 
	@"A specialized type of missile that mimicks the elemental abilities
	of the standard Wave Beam. The main difference is these have a much
	higher damage output at the cost of using 5 missiles worth of ammo."
});
ds_map_add(global.items, ID_MISSILE_TANK_SMALL, {
	itemName	: "SMALL MISSILE TANK",
	itemInfo	: 
	@"Samus's maximum missile ammunition capacity has been permanently 
	increased by two units."
});
ds_map_add(global.items, ID_MISSILE_TANK_LARGE, {
	itemName	: "LARGE MISSILE TANK",
	itemInfo	: 
	@"Samus's maximum missile ammunition capacity has been permanently 
	increased by ten units."
});
ds_map_add(global.items, ID_ENERGY_TANK, {
	itemName	: "ENERGY TANK",
	itemInfo	: 
	@"The maximum energy capacity of the Power Suit has been permanently
	increased by 100 units."
});
ds_map_add(global.items, ID_ENERGY_TANK_PIECE, {
	itemName	: "ENERGY TANK PIECE",
	itemInfo	: 
	@"A portion of the material--around 25 percent of it--required to 
	create a full Energy Tank. Unusable until four have been collected."
});
ds_map_add(global.items, ID_RESERVE_TANK, {
	itemName	: "RESERVE TANK",
	itemInfo	: 
	@"A specialized Energy Tank that is only activated when all primary
	Energy Tanks of the Power Suit have been completely depleted. Each
	of these tanks stores 100 units of back-up energy."
});
ds_map_add(global.items, ID_POWER_BOMB_TANK, {
	itemName	: "POWER BOMB TANK",
	itemInfo	: 
	@"Samus's maximum Power Bomb ammunition capacity has been permanently
	increased by one unit."
});
ds_map_add(global.items, ID_BOMBS, {
	itemName	: "BOMBS",
	itemInfo	: 
	@"The Morph Ball now has a means to allow Samus to defend herself 
	whilst in the form. On top of that, obstructions in narrrow areas 
	can potentially be destroyed by the bomb's explosion."
});
ds_map_add(global.items, ID_POWER_BOMBS, {
	itemName	: "POWER BOMBS",
	itemInfo	: 
	@"A specialized bomb that creates an extremely large blast upon
	detonation. Almost anything that is unlcuky enough to find itself 
	caught in the middle of the explosion will be obliterated."
});
ds_map_add(global.items, ID_PHASE_SHIFT, {
	itemName	: "PHASE SHIFT",
	itemInfo	: 
	@"An aeion ability that allows Samus to teleport a brief distance
	at the cost of her Power Suit's current aeion energy reserves. Living
	matter can be passed through entirely by this ability."
});
ds_map_add(global.items, ID_ENERGY_SHIELD, {
	itemName	: "ENERGY SHIELD",
	itemInfo	: 
	@"Creates a field around Samus's Power Suit that converts aeion energy
	into standard energy whenever Samus would be damaged; negating nearly 
	all forms of damage so long as the ability remains active."
});
ds_map_add(global.items, ID_SCAN_PULSE, {
	itemName	: "SCAN PULSE",
	itemInfo	: 
	@"An ability that allows Samus to utilize her Power Suit's aeion energy
	to send out a pulse that gathers data about the surrounding environment."
});
ds_map_add(global.items, ID_LOCKON_MISSILES, {
	itemName	: "LOCK-ON MISSILES",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_BEAM_SPLITTER, {
	itemName	: "BEAM SPLITTER",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_PULSE_BOMBS, {
	itemName	: "PULSE BOMBS",
	itemInfo	: 
	@""
});
ds_map_add(global.items, ID_UNKNOWN_ITEM, {
	itemName	: "UNKNOWN ITEM",
	itemInfo	:
	@"The item that has been collected is incompatible with the Power Suit.
	Another upgrade may be required in order to properly use it."
});

#endregion