#region Initializing any macros that are useful/related to the game settings struct

// A macro to simplify the look of the code whenever the game settings struct needs to be referenced.
#macro	GAME_SETTINGS			global.gameSettings

// Stores the strings that represent each of the sections found within the game's "settings.ini" file.
#macro	SECTION_VIDEO			"VIDEO"
#macro	SECTION_AUDIO			"AUDIO"
#macro	SECTION_ACCESSIBILITY	"ACCESSIBILITY"
#macro	SECTION_KEYBOARD		"KEYBOARD"
#macro	SECTION_GAMEPAD			"GAMEPAD"
#macro	SECTION_GAMEPAD_EXT		"GAMEPAD EXTRAS"

// The bits that enable/disable certain features of the game's video settings. If they are set, the effects
// will be active. If not set, none of the unset effects are applied (Bloom, aberration, etc.).
#macro	FULL_SCREEN				0
#macro	VERTICAL_SYNC			1
#macro	BLOOM_EFFECT			2
#macro	ABERRATION_EFFECT		3
#macro	FILM_GRAIN_FILTER		4
#macro	SCANLINE_FILTER			5

// The single bit for audio settings that will determine if music should be audible or not.
#macro	PLAY_MUSIC				10

// The bits that store the flags for a few of the game's accessibility settings. 
#macro	OBJECTIVE_HINTS			20
#macro	ITEM_HIGHLIGHTING		21
#macro	INTERACTION_PROMPTS		22
#macro	IS_RUN_TOGGLE			23
#macro	IS_AIM_TOGGLE			24
#macro	SWAP_MOVEMENT_STICK		25

// The bit that enables vibration for a connected gamepad (If that gamepad's vibrators can be interfaced by
// GameMaker's code).
#macro	GAMEPAD_VIBRATION		30

// Unique values for the aspect ratios that are supported in the game similar to how all assets in the engine
// are assigned a unique value starting from 0.
#macro	AR_SIXTEEN_BY_NINE		800
#macro	AR_SIXTEEN_BY_TEN		801
#macro	AR_THREE_BY_TWO			802
#macro	AR_SEVEN_BY_THREE		803

// The values that will tell the game settings which volume group needs to be dealt with when calling the
// "game_get_audio_group" function. The bottom three will all have their volume adjusted based on the global
// volume's current value.
#macro	GLOBAL_VOLUME			0
#macro	MUSIC_VOLUME			1
#macro	SOUND_VOLUME			2
#macro	FOOTSTEP_VOLUME			3
#macro	AMBIENCE_VOLUME			4
#macro	UI_VOLUME				5

// The positions within the buffer for the player's current input configuration that each of these actions' 
// respective keybindings are stored. Each is a 2-byte value storing each input's virtual key code.
#macro	KEY_GAME_RIGHT			0		// Player movement inputs
#macro	KEY_GAME_LEFT			2
#macro	KEY_GAME_UP				4		// Aiming/morphball mode inputs
#macro	KEY_GAME_DOWN			6
#macro	KEY_JUMP				8		// Jumping input
#macro	KEY_USE_WEAPON			10		// Equipped weapons inputs
#macro	KEY_SWAP_WEAPON			12		
#macro	KEY_HOTKEY_ONE			14		// Weapon hotkey inputs; order is:
#macro	KEY_HOTKEY_TWO			16		//		Power Beam, Ice Beam, Wave Beam, Plasma Beam
#macro	KEY_HOTKEY_THREE		18		//		Missiles, Ice Missiles, Shock Missiles
#macro	KEY_HOTKEY_FOUR			20		
#macro	KEY_HOTKEY_FIVE			22		
#macro	KEY_HOTKEY_SIX			24		
#macro	KEY_HOTKEY_SEVEN		26		
#macro	KEY_ALT_WEAPON			28		// Activates missiles or power bombs
#macro	KEY_ENERGY_SHIELD		30		// Toggles for all aeion abilities
#macro	KEY_PHASE_SHIFT			32		
#macro	KEY_SCAN_PULSE			34
#macro	KEY_MENU_RIGHT			40		// Menu cursor movement inputs
#macro	KEY_MENU_LEFT			42
#macro	KEY_MENU_UP				44
#macro	KEY_MENU_DOWN			46
#macro	KEY_SELECT				48		// Selection and deselection/menu-closing inputs
#macro	KEY_RETURN				50
#macro	KEY_DELETE_FILE			52		// (Save/Load Game Menu ONLY) deletes highlighted save slot
#macro	KEY_AUX_MENU_RIGHT		54		// Auxiliary inputs for moving left and right in a menu
#macro	KEY_AUX_MENU_LEFT		56
#macro	KEY_PAUSE				58		// Accesses the pause menu while in-game

// Macros to simply the typing required to check each respective input binding for the keyboard whenever
// player input needs to be processed in the code.
#macro	KEYCODE_GAME_RIGHT		game_get_input_binding(KEY_GAME_RIGHT)		// Player movement inputs 
#macro	KEYCODE_GAME_LEFT		game_get_input_binding(KEY_GAME_LEFT)
#macro	KEYCODE_GAME_UP			game_get_input_binding(KEY_GAME_UP)			// Aiming/morphball mode inputs
#macro	KEYCODE_GAME_DOWN		game_get_input_binding(KEY_GAME_DOWN)
#macro	KEYCODE_JUMP			game_get_input_binding(KEY_JUMP)			// Jumping input
#macro	KEYCODE_USE_WEAPON		game_get_input_binding(KEY_USE_WEAPON)		// Equipped weapon inputs
#macro	KEYCODE_SWAP_WEAPON		game_get_input_binding(KEY_SWAP_WEAPON)
#macro	KEYCODE_HOTKEY_ONE		game_get_input_binding(KEY_HOTKEY_ONE)		// Weapon hotkey inputs
#macro	KEYCODE_HOTKEY_TWO		game_get_input_binding(KEY_HOTKEY_TWO)
#macro	KEYCODE_HOTKEY_THREE	game_get_input_binding(KEY_HOTKEY_THREE)
#macro	KEYCODE_HOTKEY_FOUR		game_get_input_binding(KEY_HOTKEY_FOUR)
#macro	KEYCODE_HOTKEY_FIVE		game_get_input_binding(KEY_HOTKEY_FIVE)
#macro	KEYCODE_HOTKEY_SIX		game_get_input_binding(KEY_HOTKEY_SIX)
#macro	KEYCODE_HOTKEY_SEVEN	game_get_input_binding(KEY_HOTKEY_SEVEN)
#macro	KEYCODE_ALT_WEAPON		game_get_input_binding(KEY_ALT_WEAPON)		// Switching over to using missiles/power bombs
#macro	KEYCODE_ENERGY_SHIELD	game_get_input_binding(KEY_ENERGY_SHIELD)	// Aeion ability toggles
#macro	KEYCODE_PHASE_SHIFT		game_get_input_binding(KEY_PHASE_SHIFT)
#macro	KEYCODE_SCAN_PULSE		game_get_input_binding(KEY_SCAN_PULSE)
#macro	KEYCODE_MENU_RIGHT		game_get_input_binding(KEY_MENU_RIGHT)		// Menu cursor movement inputs
#macro	KEYCODE_MENU_LEFT		game_get_input_binding(KEY_MENU_LEFT)
#macro	KEYCODE_MENU_UP			game_get_input_binding(KEY_MENU_UP)
#macro	KEYCODE_MENU_DOWN		game_get_input_binding(KEY_MENU_DOWN)
#macro	KEYCODE_SELECT			game_get_input_binding(KEY_SELECT)			// Selection and deselection/menu-closing inputs
#macro	KEYCODE_RETURN			game_get_input_binding(KEY_RETURN)			
#macro	KEYCODE_DELETE_FILE		game_get_input_binding(KEY_DELETE_FILE)		// (Save/Load Game Menu ONLY) deletes highlighted save slot
#macro	KEYCODE_AUX_MENU_RIGHT	game_get_input_binding(KEY_AUX_MENU_RIGHT)	// Auxiliary inputs for moving left and right in a menu
#macro	KEYCODE_AUX_MENU_LEFT	game_get_input_binding(KEY_AUX_MENU_LEFT)	
#macro	KEYCODE_PAUSE			game_get_input_binding(KEY_PAUSE)
																			
// The positions within the buffer for the player's current input configuration that each of these actions'
// respective gamepad input bindings are stored. Each is a 2-byte value storing the values for Game Maker's
// constants for gamepad input bindings that match up to what the player has configured for their gamepad
// control scheme.

// TODO -- Add macros for gamepad input binding position within buffer

// Macros to simply the typing required to check each respective input binding for the connected and active
// gamepad whenever player input needs to be processed in the code.

// TODO -- Add gamepad macros for inputs here

// A shorten-downed version that returns the volume for each of the four groups; the bottom three being 
// influenced by what the current global volume is (Values all range from 0 to 1).
#macro	GET_GLOBAL_VOLUME		game_get_group_volume(GLOBAL_VOLUME)
#macro	GET_MUSIC_VOLUME		game_get_group_volume(MUSIC_VOLUME)
#macro	GET_SOUND_VOLUME		game_get_group_volume(SOUND_VOLUME)
#macro	GET_FOOTSTEP_VOLUME		game_get_group_volume(FOOTSTEP_VOLUME)
#macro	GET_AMBIENCE_VOLUME		game_get_group_volume(AMBIENCE_VOLUME)
#macro	GET_UI_VOLUME			game_get_group_volume(UI_VOLUME)

// Macros that provide an easy method of referencing various setting values without having to constantly
// typing out "global.gameSettings.*" for each of these values whenever they are needed.
#macro	RESOLUTION_SCALE		global.gameSettings.resolutionScale
#macro	ASPECT_RATIO			global.gameSettings.aspectRatio
#macro	BRIGHTNESS				global.gameSettings.brightness
#macro	GAMMA					global.gameSettings.gamma
#macro	TEXT_SPEED				global.gameSettings.textSpeed

// Macros that allow easy interfacing with the difficulty-reliant variables that aren't stored as
// individual bits in the "difficultyFlags" variable.
#macro	PLAYER_DAMAGE_MOD		global.gameSettings.pDamageModifier
#macro	ENEMY_DAMAGE_MOD		global.gameSettings.eDamageModifier

#endregion

#region Initializing enumerators that are useful/related to the game settings struct
#endregion

#region Initializing any globals that are useful/related to the game settings struct
#endregion

#region The main object code for the game settings struct

global.gameSettings = {
	// Each variable holds 32 unique bits that can be set to 0 or 1 to determine how the games settings are
	// constructed, as well as the game's difficulty settings. Note that not all of the bits available are
	// used by either variable.
	settingFlags :			0,
	difficultyFlags :		0,
	
	// For video settings that can't be stored as single bits, they will all have their own variables to
	// represent their current configurations. These include the current aspect ratio, resolution scale (Not
	// used when the game is in full-screen mode), the image's overall brightness, and the image's gamma level.
	resolutionScale :		0,
	aspectRatio :			0,
	brightness :			0,
	gamma :					0,
	
	// Much like the group of variables above, these will store setting values that can be represented by a
	// single bit, but for audio levels instead of various video setttings. Each is represented by a percentage
	// that is stored as a value between 0 and 1, determining the overall volume of the group they represent.
	globalVolume :			0,
	musicVolume :			0,
	soundVolume :			0,
	footstepVolume :		0,
	ambienceVolume :		0,
	uiVolume :				0,
	
	// The input binding buffer will store the currently set inputs for each action that were set up by the
	// player (Or the defaults if they haven't altered the base controls). Each of these buffer values is a
	// 2-byte value in order to store the values for the gamepad input constants that GML uses (These are
	// values of somwhere around 32700, I believe). The last three variables will store values that can be
	// adjusted by the user so that they fit their gamepad well.
	inputBindings :			buffer_create(128, buffer_fixed, 2),
	vibrationIntensity :	0,
	stickDeadzone :			0,
	triggerThreshold :		0,
	
	// An accessibility setting that can't be stored as a single bit. It will determine how fast characters
	// appear on the screen when they use a typewriter-like effect during rendering. The higher the value,
	// the faster that effect occurs.
	textSpeed :				0,
	
	// Damage modification values for the game's difficulty that can't be represented by individual bits.
	// Instead, they are decimal values that will increased or decrease the damage output for the player or
	// an enemy based on if their modifier value is greater than or less than 1.0, respectively.
	pDamageModifier :		1.0,
	eDamageModifier :		1.0,
	
	/// @description Function that borrows the name of the event it should be called from within the
	/// "obj_controller" object. It will clear out and deallocate any memory that was allocated by the
	/// player input binding buffer to prevent any leaks.
	cleanup : function(){
		buffer_delete(inputBindings);
	},
}

#endregion

#region Global functions related to the game settings struct

/// @description Loading in the games settings from the "settings.ini". This function can still be used if
/// that ini file doesn't exist since the "ini_read_*" functions allow foe default values to be set if they
/// can't read in the required values for whatever reason (Ex. the file doesn't exist or the section/key 
/// pair doesn't exist within the file).
function game_load_settings(){
	with(GAME_SETTINGS){
		ini_open("settings.ini");
		
		// First, all the bit flags are grabbed from the settings are applied to the value of 0. That way, 
		// the settings that were previously applied will be completely overwritten by this function loading 
		// the values in from the file, since they could possibly differ.
		settingFlags = 0 | 
			(ini_read_real(SECTION_VIDEO, "fullscreen", 0) <<				FULL_SCREEN) |
			(ini_read_real(SECTION_VIDEO, "vsync", 0) <<					VERTICAL_SYNC) |
			(ini_read_real(SECTION_VIDEO, "bloom", 1) <<					BLOOM_EFFECT) |
			(ini_read_real(SECTION_VIDEO, "chromatic_aberration", 1) <<		ABERRATION_EFFECT) |
			(ini_read_real(SECTION_VIDEO, "film_grain", 1) <<				FILM_GRAIN_FILTER) |
			(ini_read_real(SECTION_VIDEO, "scanlines", 1) <<				SCANLINE_FILTER) |
			(ini_read_real(SECTION_AUDIO, "play_music", 1) <<				PLAY_MUSIC) |
			(ini_read_real(SECTION_ACCESSIBILITY, "objective_hints", 0) <<	OBJECTIVE_HINTS) |
			(ini_read_real(SECTION_ACCESSIBILITY, "item_highlights", 0) <<	ITEM_HIGHLIGHTING) |
			(ini_read_real(SECTION_ACCESSIBILITY, "interact_prompts", 1) <<	INTERACTION_PROMPTS) |
			(ini_read_real(SECTION_ACCESSIBILITY, "is_run_toggle", 0) <<	IS_RUN_TOGGLE) |
			(ini_read_real(SECTION_ACCESSIBILITY, "is_aim_toggle", 0) <<	IS_AIM_TOGGLE) |
			(ini_read_real(SECTION_ACCESSIBILITY, "swap_movement", 0) <<	SWAP_MOVEMENT_STICK);
		
		// Loading in the video settings that aren't represented by single bits in the "settingFlags" integer.
		resolutionScale =	ini_read_real(SECTION_VIDEO, "resolution_scale", 4);
		aspectRatio =		ini_read_real(SECTION_VIDEO, "aspect_ratio", AR_SIXTEEN_BY_NINE);
		brightness =		ini_read_real(SECTION_VIDEO, "brightness", 0.4);
		gamma =				ini_read_real(SECTION_VIDEO, "gamma", 1.0);
		
		// Loading in the volume for each of the four main groups.
		globalVolume =		ini_read_real(SECTION_AUDIO, "global_volume", 1.0);
		musicVolume =		ini_read_real(SECTION_AUDIO, "music_volume", 0.75);
		soundVolume =		ini_read_real(SECTION_AUDIO, "sound_volume", 0.85);
		footstepVolume =	ini_read_real(SECTION_AUDIO, "footstep_volume", 0.8);
		ambienceVolume =	ini_read_real(SECTION_AUDIO, "ambience_volume",	0.9);
		uiVolume =			ini_read_real(SECTION_AUDIO, "ui_volume", 0.65);
		
		// Reading in and applying all player input bindings for the keyboard. If no values exists, the 
		// defaults at the end of each line will be what is set to the input's space in the "inputBindings" 
		// buffer.
		buffer_poke(inputBindings, KEY_GAME_RIGHT, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "game_right",		vk_right));
		buffer_poke(inputBindings, KEY_GAME_LEFT, buffer_u16,		ini_read_real(SECTION_KEYBOARD,	"game_left",		vk_left));
		buffer_poke(inputBindings, KEY_GAME_UP, buffer_u16,			ini_read_real(SECTION_KEYBOARD, "game_up",			vk_up));
		buffer_poke(inputBindings, KEY_GAME_DOWN, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "game_down",		vk_down));
		buffer_poke(inputBindings, KEY_JUMP, buffer_u16,			ini_read_real(SECTION_KEYBOARD, "jump",				vk_x));
		buffer_poke(inputBindings, KEY_USE_WEAPON, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "use_weapon",		vk_z));
		buffer_poke(inputBindings, KEY_SWAP_WEAPON, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "swap_weapon",		vk_alt));
		buffer_poke(inputBindings, KEY_HOTKEY_ONE, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "power_beam",		vk_1));
		buffer_poke(inputBindings, KEY_HOTKEY_TWO, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "ice_beam",			vk_2));
		buffer_poke(inputBindings, KEY_HOTKEY_THREE, buffer_u16,	ini_read_real(SECTION_KEYBOARD, "wave_beam",		vk_3));
		buffer_poke(inputBindings, KEY_HOTKEY_FOUR, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "plasma_beam",		vk_4));
		buffer_poke(inputBindings, KEY_HOTKEY_FIVE, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "missiles",			vk_1));
		buffer_poke(inputBindings, KEY_HOTKEY_SIX, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "ice_missiles",		vk_2));
		buffer_poke(inputBindings, KEY_HOTKEY_SEVEN, buffer_u16,	ini_read_real(SECTION_KEYBOARD, "shock_missiles",	vk_3));
		buffer_poke(inputBindings, KEY_ALT_WEAPON, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "alt_weapon",		vk_control));
		buffer_poke(inputBindings, KEY_ENERGY_SHIELD, buffer_u16,	ini_read_real(SECTION_KEYBOARD, "energy_shield",	vk_a));
		buffer_poke(inputBindings, KEY_PHASE_SHIFT, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "phase_shift",		vk_space));
		buffer_poke(inputBindings, KEY_SCAN_PULSE, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "scan_pulse",		vk_tab));
		
		// Next, the menu input beindings for the keyboard are read into the buffer. If no valid entry 
		// exists for a given input, the default found as the last argument in "ini_read_real" is used.
		buffer_poke(inputBindings, KEY_MENU_RIGHT, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "menu_right",		vk_right));
		buffer_poke(inputBindings, KEY_MENU_LEFT, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "menu_left",		vk_left));
		buffer_poke(inputBindings, KEY_MENU_UP, buffer_u16,			ini_read_real(SECTION_KEYBOARD, "menu_up",			vk_up));
		buffer_poke(inputBindings, KEY_MENU_DOWN, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "menu_down",		vk_down));
		buffer_poke(inputBindings, KEY_SELECT, buffer_u16,			ini_read_real(SECTION_KEYBOARD, "select",			vk_z));
		buffer_poke(inputBindings, KEY_RETURN, buffer_u16,			ini_read_real(SECTION_KEYBOARD, "return",			vk_x));
		buffer_poke(inputBindings, KEY_DELETE_FILE, buffer_u16,		ini_read_real(SECTION_KEYBOARD, "delete_file",		vk_d));
		
		// Loading in all the gamepad settings that aren't input constants stored in the input buffer
		// or flags that are all loaded in at the top of this function.
		vibrationIntensity =	ini_read_real(SECTION_GAMEPAD_EXT, "vibrate_intensity", 0.5);
		stickDeadzone =			ini_read_real(SECTION_GAMEPAD_EXT, "stick_deadzone",	0.25);
		triggerThreshold =		ini_read_real(SECTION_GAMEPAD_EXT, "trigger_threshold", 0.15);
		
		// Loading in the accessibility settings that aren't bit flags; storing them into the variables
		// that are responsible for said values during the game's runtime.
		textSpeed =				ini_read_real(SECTION_ACCESSIBILITY, "text_speed",	0.75);
		
		ini_close();
	}
	
	// 
	var _aspectRatio = ASPECT_RATIO;
	var _width = game_get_aspect_ratio_width(_aspectRatio);
	var _height = game_get_aspect_ratio_height(_aspectRatio);
	camera_initialize(0, 0, _width, _height, RESOLUTION_SCALE, (1 << VIEW_BOUNDARY));
}

/// @description Saves the current configuration for the game's settings to the "settings.ini" file
/// stored in the game's appdata folder (This is the default destination for GameMaker when files are
/// created through code).
function game_save_settings(){
	with(GAME_SETTINGS){
		// First, the file has to be opened so the settings can be written to it. If this file doesn't
		// current exist, it will automatically be created by this function being called and then an
		// "ini_write_*" function being used before the ini reader is closed.
		ini_open("settings.ini");
		
		// The video settings are stored first in the section fittingly titled "[VIDEO]". Each non-flag
		// value is stored as the number that they are currently set to, and flags will be stored as 0s
		// or 1s depending on what the bitwise ANDing of the desire bits returns.
		ini_write_real(SECTION_VIDEO, "resolution_scale",			resolutionScale);
		ini_write_real(SECTION_VIDEO, "aspect_ratio",				aspectRatio);
		ini_write_real(SECTION_VIDEO, "fullscreen",					(settingFlags & (1 << FULL_SCREEN)));
		ini_write_real(SECTION_VIDEO, "vsync",						(settingFlags & (1 << VERTICAL_SYNC)));
		ini_write_real(SECTION_VIDEO, "brightness",					brightness);
		ini_write_real(SECTION_VIDEO, "gamma",						gamma);
		ini_write_real(SECTION_VIDEO, "bloom",						(settingFlags & (1 << BLOOM_EFFECT)));
		ini_write_real(SECTION_VIDEO, "chromatic_aberration",		(settingFlags & (1 << ABERRATION_EFFECT)));
		ini_write_real(SECTION_VIDEO, "film_grain",					(settingFlags & (1 << FILM_GRAIN_FILTER)));
		ini_write_real(SECTION_VIDEO, "scanlines",					(settingFlags & (1 << SCANLINE_FILTER)));
		
		// The audio settings come next; each non-flag value will be stored as a decimal between 0 and 1 
		// determining the percentage value for the given volume group before the global volume is taken 
		// into account.
		ini_write_real(SECTION_AUDIO, "global_volume",				globalVolume);
		ini_write_real(SECTION_AUDIO, "music_volume",				musicVolume);
		ini_write_real(SECTION_AUDIO, "play_music",					settingFlags & (1 << PLAY_MUSIC));
		ini_write_real(SECTION_AUDIO, "sound_volume",				soundVolume);
		ini_write_real(SECTION_AUDIO, "footstep_volume",			footstepVolume);
		ini_write_real(SECTION_AUDIO, "ambience_volume",			ambienceVolume);
		ini_write_real(SECTION_AUDIO, "ui_volume",					uiVolume);
		
		// Writes all of the keyboard constants used by the player in their input configuation for
		// the game's various actions that can be triggered when the game allows it and the player
		// presses/holds the necessary input(s) to the settings file.
		ini_write_real(SECTION_KEYBOARD, "game_right",				buffer_peek(inputBindings, KEY_GAME_RIGHT, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "game_left",				buffer_peek(inputBindings, KEY_GAME_LEFT, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "game_up",					buffer_peek(inputBindings, KEY_GAME_UP, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "game_down",				buffer_peek(inputBindings, KEY_GAME_DOWN, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "jump",					buffer_peek(inputBindings, KEY_JUMP, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "use_weapon",				buffer_peek(inputBindings, KEY_USE_WEAPON, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "swap_weapon",				buffer_peek(inputBindings, KEY_SWAP_WEAPON, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "power_beam",				buffer_peek(inputBindings, KEY_HOTKEY_ONE, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "ice_beam",				buffer_peek(inputBindings, KEY_HOTKEY_TWO, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "wave_beam",				buffer_peek(inputBindings, KEY_HOTKEY_THREE, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "plasma_beam",				buffer_peek(inputBindings, KEY_HOTKEY_FOUR, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "missiles",				buffer_peek(inputBindings, KEY_HOTKEY_FIVE, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "ice_missiles",			buffer_peek(inputBindings, KEY_HOTKEY_SIX, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "shock_missiles",			buffer_peek(inputBindings, KEY_HOTKEY_SEVEN, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "energy_shield",			buffer_peek(inputBindings, KEY_ENERGY_SHIELD, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "phase_shift",				buffer_peek(inputBindings, KEY_PHASE_SHIFT, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "scan_pulse",				buffer_peek(inputBindings, KEY_SCAN_PULSE, buffer_u16));
		
		// Writes the keyboard inputs utilized by the player for the game's various menus to the
		// settings file so those same inputs can be reloaded again; preventing loss of custom inputs.
		ini_write_real(SECTION_KEYBOARD, "menu_right",				buffer_peek(inputBindings, KEY_MENU_RIGHT, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "menu_left",				buffer_peek(inputBindings, KEY_MENU_LEFT, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "menu_up",					buffer_peek(inputBindings, KEY_MENU_UP, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "menu_down",				buffer_peek(inputBindings, KEY_MENU_DOWN, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "select",					buffer_peek(inputBindings, KEY_SELECT, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "return",					buffer_peek(inputBindings, KEY_RETURN, buffer_u16));
		ini_write_real(SECTION_KEYBOARD, "delete_file",				buffer_peek(inputBindings, KEY_DELETE_FILE, buffer_u16));
		
		// Saving the gamepad settings that aren't input constants; the vibration strength, stick 
		// deadzone region, and trigger threshold for input activation, respectively.
		ini_write_real(SECTION_GAMEPAD_EXT, "vibrate_intensity",	vibrationIntensity);
		ini_write_real(SECTION_GAMEPAD_EXT, "stick_deadzone",		stickDeadzone);
		ini_write_real(SECTION_GAMEPAD_EXT, "trigger_threshold",	triggerThreshold);
		
		// Finally, write all of the values for the accessibility settings in the game to the file.
		ini_write_real(SECTION_ACCESSIBILITY, "text_speed",			textSpeed);
		ini_write_real(SECTION_ACCESSIBILITY, "objective_hints",	(settingFlags & (1 << OBJECTIVE_HINTS)));
		ini_write_real(SECTION_ACCESSIBILITY, "item_highlights",	(settingFlags & (1 << ITEM_HIGHLIGHTING)));
		ini_write_real(SECTION_ACCESSIBILITY, "interact_prompt",	(settingFlags & (1 << INTERACTION_PROMPTS)));
		ini_write_real(SECTION_ACCESSIBILITY, "is_run_toggle",		(settingFlags & (1 << IS_RUN_TOGGLE)));
		ini_write_real(SECTION_ACCESSIBILITY, "is_aim_toggle",		(settingFlags & (1 << IS_AIM_TOGGLE)));
		ini_write_real(SECTION_ACCESSIBILITY, "swap_movement",		(settingFlags & (1 << SWAP_MOVEMENT_STICK)));
		
		ini_close();
	}
}

/// @description Sets the desired bit in the "settingFlags" variable to the value (Either 0 or 1) determined 
/// by the state of the "flagState" boolean (False = 0, True = any number >= 1). 
/// @param {Real}	flagID
/// @param {Real}	flagState
function game_set_setting_flag(_flagID, _flagState){
	with(GAME_SETTINGS){
		if (_flagState)	{settingFlags = settingFlags | (_flagState << _flagID);}
		else			{settingFlags = settingFlags & ~(1 << _flagID);}
	}
}

/// @description Gets the value for the bit stored in the location specified by the value passed into 
/// the "_flagID" argument space; returning a value of 1 for the setting being enabled, or a 0 for a
/// setting that has been disabled by the player.
/// @param {Real}	flagID
function game_get_setting_flag(_flagID){
	with(GAME_SETTINGS) {return (settingFlags & (1 << _flagID));}
}

/// @description Gets the value for the bit in the "difficultyFlags" variable at the posiiton specified 
/// by the value given as an argument. If it's a 1, the flag for that difficulty setting is toggled to 
/// be active. Otherwise, it should be a value of zero.
/// @param {Real}	flagID
function game_get_difficulty_flag(_flagID){
	with(GAME_SETTINGS) {return (difficultyFlags & (1 << _flagID));}
}

/// @description Assigns a new keyboard/gamepad constant to the buffer that stores all the player's
/// input bindings at an offset inside (Offset meaning the "_inputID" variable's value) the buffer.
/// @param {Real}	inputID
/// @param {Real}	inputConstant
function game_set_input_binding(_inputID, _inputConstant){
	with(GAME_SETTINGS) {buffer_poke(inputBindings, _inputID, buffer_u16, _inputConstant);}
}

/// @description Grabs the input constant that is stored within the buffer at the specified offset;
/// that offset being the value provided for the "_inputID"'s value.
/// @param {Real}	inputID
function game_get_input_binding(_inputID){
	with(GAME_SETTINGS) {return buffer_peek(inputBindings, _inputID, buffer_u16);}
}

/// @description Returns the width for the game's viewport for the currently active aspect ratio.
/// This value is independent to the window's actual width, which is a combination of this and the
/// current scale value when the game isn't in fullscreen mode.
/// @param {Real}	arConstant
function game_get_aspect_ratio_width(_arConstant){
	switch(_arConstant){
		default: // Undefined aspect ratios are considered 16:9 as a failsafe.
		case AR_SIXTEEN_BY_NINE:	return 320;
		case AR_SIXTEEN_BY_TEN:		return 320;
		case AR_THREE_BY_TWO:		return 324;
		case AR_SEVEN_BY_THREE:		return 420;
	}
}

/// @description Returns the height for the game's viewport for the currently active aspect ratio.
/// This value is independent to the window's actual height, which is a combination of this and the
/// current scale value when the game isn't in fullscreen mode.
/// @param {Real}	arConstant
function game_get_aspect_ratio_height(_arConstant){
	switch(_arConstant){
		default: // Undefined aspect ratios are considered 16:9 as a failsafe.
		case AR_SEVEN_BY_THREE:
		case AR_SIXTEEN_BY_NINE:	return 180;
		case AR_SIXTEEN_BY_TEN:		return 200;
		case AR_THREE_BY_TWO:		return 216;
	}
}

/// @description Gets the percentage value for the desired audio group. All audio groups besides the
/// global volume level will be affected by the value of said global volume, and the music volume can
/// be set to 0 if the player has disabled background music playback.
/// @param {Real}	volumeGroup
function game_get_group_volume(_volumeGroup){
	with(GAME_SETTINGS){
		switch(_volumeGroup){
			case GLOBAL_VOLUME:		return globalVolume;
			case MUSIC_VOLUME:		return musicVolume;
			case SOUND_VOLUME:		return soundVolume;
			case FOOTSTEP_VOLUME:	return footstepVolume;
			case AMBIENCE_VOLUME:	return ambienceVolume;
			case UI_VOLUME:			return uiVolume;
			default:				return 0;
		}
	}
}

#endregion