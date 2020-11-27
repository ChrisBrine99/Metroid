/// @description Enumerators used by the game's various systems.

// Stores the state of the game on a global scale at the given moment
enum GameState{
	InGame,
	InMenu,
	Paused,
}

// An enumerator for storing the array indexes for each respective game setting
enum Settings{
	// Video Settings //
	WindowScale,
	FullScreen,
	Bloom,
	Scanlines,
	// Audio Settings //
	Master,
	Sounds,
	Music,
	EnableMusic,
	// Keyboard Settings //
	GameRight,		// In-Game Keybindings
	GameLeft,
	GameUp,
	GameDown,
	Jump,
	UseWeapon,
	ChangeWeapon,
	MenuDown,		// Menu Keybindings
	MenuUp,
	MenuLeft,
	MenuRight,
	Select,
	Return,
	FileDelete,
	// Accessibility Settings //
	ObjectiveHints,
	TextSpeed,
	// Holds Total Number of Settings //
	Length,
}

enum Items{
	// Morphball Items //
	Morphball,
	SpringBall,
	SpiderBall,
	Bombs,
	// Arm Cannon Items //
	IceBeam,
	WaveBeam,
	SpazerBeam,
	PlasmaBeam,
	ChargeBeam,
	// Jump Upgrades //
	HighJumpBoots,
	SpaceJumpBoots,
	ScrewAttack,
	// Suit Upgrades //
	VariaSuit,
	GravitySuit,
	// Other Upgrades //
	Missiles,
	MaxMissiles,
	SuperMissiles,
	MaxSuperMissiles,
	PowerBombs,
	MaxPowerBombs,
	// Holds Total Number of Items //
	Length
}

enum Weapon{
	// Weapons that can damage the enemy if found in their weakness list //
	PowerBeam,
	IceBeam,
	WaveBeam,
	SpazerBeam,
	PlasmaBeam,
	Missile,
	SuperMissile,
	Bomb,
	PowerBomb,
	// All enemy projectiles can damage Samus, so only type is needed //
	Enemy,
}