/// @description Initializes all enumerators that aren't bound to any specific object, but are instead used all 
/// throughout the code for various different tasks and reasons.

/// @description Each value in this enum represents a different state that the game can be in at any given
/// moment. The first state (NoState) is simply a default and doesn't actually affect the game's ability to
/// function, but the other four will alter how the game acts in a wholly unique way.
enum GameState{
	NoState,
	InGame,
	InMenu,
	Cutscene,
	Paused,
}

/// @description 
enum Difficulty{
	NotSet,
	Forgiving,
	Standard,
	Punishing,
	Nightmare,
}