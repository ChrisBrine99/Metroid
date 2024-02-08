#region Initializing any macros that are useful/related to the audio listener

// ------------------------------------------------------------------------------------------------------- //
//	Macros for referencing the audio manager itself without having to type "global.audioManager" and	   //
//	another for quickly referencing the variable that stores the instance id for the object the audio	   //
//	listener is linked to.																				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	AUDIO_MANAGER				global.audioManager
#macro	AUDIO_LINKED_OBJECT			global.audioManager.linkedObject

// ------------------------------------------------------------------------------------------------------- //
//	Condenses the code required to reference the audio manager's loaded sounds and custom audio buses.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	SOUND_DATA					global.audioManager.soundData
#macro	AUDIO_BUSES					global.audioManager.audioBuses

#endregion

#region Initializing enumerators that are useful/related to the audio listener
#endregion

#region Initializing any globals that are useful/related to the audio listener

#endregion

#region The main struct code for the audio listener

global.audioManager = {
	// Data structures that store important data used by GameMaker's audio system. The first map stores any
	// sounds that are loaded in by file instead of being a resource added into GameMaker by default, and the
	// second map stores any custom audio buses created during runtime that can be used to apply audio effects
	// to a specific subset of sounds instead of every sound in the game.
	soundData : ds_map_create(),
	audioBuses : ds_map_create(),
	
	// Stores the unique id for the object that is linked to the audio listener, which will determine how
	// sounds are heard in the game. There are offset values to allow the listener's position to be moved
	// relative to the linked object's actual position.
	linkedObject : noone,
	offsetX	: 0,
	offsetY : 0,
	
	/// @description Updates the position of the audio listener to match the linked object's actual position
	/// within the currently loaded room. Function does nothing is no linked object is specified.
	end_step : function(){
		var _offsetX = offsetX;
		var _offsetY = offsetY;
		with(linkedObject) {audio_listener_position(x + _offsetX, y + _offsetY, 0);}
	},
	
	/// @description Removes all volitile data from memory before the audio manager itself is completely cleared
	/// from memory. Failure to call this function before removing the manager will result in memory leaks, but
	/// it should only be called in the cleanup event of "obj_contoller".
	cleanup : function(){
		var _key = ds_map_find_first(soundData);
		while(!is_undefined(_key)){
			buffer_delete(soundData[? _key].bufferID);
			delete soundData[? _key];
			_key = ds_map_find_next(soundData, _key);
		}
		ds_map_destroy(soundData);
		
		_key = ds_map_find_first(audioBuses);
		while(!is_undefined(_key)){
			audio_emitter_free(audioBuses[? _key].emitter);
			delete audioBuses[? _key];
			_key = ds_map_find_next(audioBuses, _key);
		}
		ds_map_destroy(audioBuses);
	}
}

// Properly sets up GameMaker's audio engine by having its listener's orientation to match the player's head's
// orientation (The default orientation is upside down because of GameMaker's y coordinates going from the top
// down) and applies the audio falloff model for all sounds in the game.
audio_listener_orientation(0, 0, 1, 0, -1, 0);
audio_falloff_set_model(audio_falloff_linear_distance_clamped);

#endregion

#region Global functions related to the audio listener

/// @description Assigns an object as the game's "listener" which will determine how audio is heard by the
/// player within the game world relative to the linked object's position and the sound's position.
/// @param {Id.Instance}	objectID	The object in the game to assign the listener to.
/// @param {Real}			offsetX		Number of pixels to offset the listener relative to the linked object's x position.
///	@param {Real}			offsetY		Number of pixels to offset the listener relative to the linked object's y position.
function audio_set_linked_object(_objectID, _offsetX = 0, _offsetY = 0){
	with(AUDIO_MANAGER){
		with(_objectID) {audio_listener_position(x + _offsetX, y + _offsetY, 0);}
		linkedObject = _objectID;
		offsetX = _offsetX;
		offsetY = _offsetY;
	}
}

/// @description Creates a new audio bus struct and stores itself along with the required emitter in the data
/// structure that manages these custom audio buses.
/// @param {Any} key	The key to associate this new bus and its data with.
function audio_create_new_audio_bus(_key){
	var _audioBuses = AUDIO_BUSES;
	if (!is_undefined(_audioBuses[? _key])) {return _audioBuses[? _key].emitter;}
	
	var _emitter = audio_emitter_create();
	var _bus = audio_bus_create();
	audio_emitter_bus(_emitter, _bus);
	ds_map_add(_audioBuses, _key, {emitter : _emitter, bus : _bus});
	
	return _emitter;
}

/// @description Removes a runtime-created audio bus and its associated emitter.
/// @param {Any} key	The key to search for in the map to retrieve the data that will be deleted.
function audio_remove_audio_bus(_key){
	var _audioBuses = AUDIO_BUSES;
	var _data = ds_map_find_value(_audioBuses, _key);
	if (is_undefined(_data)) {return;}
	with(_data) {audio_emitter_free(emitter);}
	ds_map_delete(_audioBuses, _key);
}

/// @description Applies a reverberation effect to one of the game's audio buses (Can be the main bus or any of
/// the custom buses created throughout the game's runtime). All sounds played from this bus afterward will have
/// this effect applied unless the bypass flag for the effect (Or the bus in its entirety) is toggled.
/// @param {Struct.AudioBus}	bus			The audio bus to apply the reverb effect onto.
/// @param {Real}				index		The index out of 8 (0 - 7) to place the effect's struct at in the bus's effect array.
/// @param {Real}				size		The size of the "space" for the reverb (From 0.0 - 1.0).
/// @param {Real}				damp		The amount of higher frequencies that should be attenuated (From 0.0 - 1.0).
/// @param {Real}				mix			The percentage of mixing between the original and reverberated sound output (From 0.0 - 1.0).
function audio_bus_apply_reverb(_bus, _index, _size, _damp, _mix){
	if (_index < 0 || _index >= 8 || !is_undefined(_bus.effects[_index])) {return;}
	var _effect = audio_effect_create(AudioEffectType.Reverb1, {
		size	: _size,
		damp	: _damp,
		mix		: _mix,
	});
	_bus.effects[_index] = _effect;
}

/// @description Applies a delay effect to one of the game's audio buses (Can be the main bus or any of the 
/// custom buses created throughout the game's runtime). All sounds played from this bus afterward will have
/// this effect applied unless the bypass flag for the effect (Or the bus in its entirety) is toggled.
/// @param {Struct.AudioBus}	bus			The audio bus to apply the delay effect onto.
/// @param {Real}				index		The index out of 8 (0 - 7) to place the effect's struct at in the bus's effect array.
/// @param {Real}				time		The length in seconds of the delay.
/// @param {Real}				feedback	The proportion of the delayed signal that's fed back into the delay line (From 0.0 - 1.0).
/// @param {Real}				mix			The percentage of mixing between the original and delayed sound output (From 0.0 - 1.0).
function audio_bus_apply_delay(_bus, _index, _time, _feedback, _mix){
	if (_index < 0 || _index >= 8 || !is_undefined(_bus.effects[_index])) {return;}
	var _effect = audio_effect_create(AudioEffectType.Delay, {
		time		: _time,
		feedback	: _feedback,
		mix			: _mix,
	});
	_bus.effects[_index] = _effect;
}

/// @description Determines the overall output volume of sounds played from the supplied audio bus unless the
/// effect's bypass flag is toggled, which will cause the effect to be ignored.
/// @param {Struct.AudioBus}	bus			The audio bus to apply the gain effect onto.
/// @param {Real}				index		The index out of 8 (0 - 7) to place the effect's struct at in the bus's effect array.
/// @param {Real}				gain		The output volume of sounds played through the specified audio bus.
function audio_bus_apply_gain(_bus, _index, _gain){
	if (_index < 0 || _index >= 8 || !is_undefined(_bus.effects[_index])) {return;}
	var _effect = audio_effect_create(AudioEffectType.Gain, { gain : _gain });
	_bus.effects[_index] = _effect;
}

/// @description Removes an effect from the specified audio bus by deleting the struct that contained all of
/// the effect's information. Allows a new effect to be placed in that slot of the bus's effect array.
/// @param {Struct.AudioBus}	bus			The audio bus to remove the desired effect from.
/// @param {Real}				index		The index into the effect array to clear of any data.
function audio_bus_remove_effect(_bus, _index){
	if (_index < 0 || _index >= 8) {return;}
	delete _bus.effects[_index];
}

/// @description Loads in an external .WAV audio file that has been properly setup (AKA the header information
/// has been deleted from the file) to be used by GameMaker's audio buffer system. This will then allow the loaded
/// data to be referenced and played like it was a normal sound resource found in the project's assets.
/// @param {String}				filepath		Path of the file within the "Included Files" section.
/// @param {Any}				key				The value to store this sound data at in the map.
/// @param {Real}				sampleRate		Sample rate of the sound that is being loaded.
/// @param {Constant.AudioType}	audioChannel	Determines how the playback of the sound will be handled (Ex. Mono, Stereo, etc).
function audio_load_sound_wav(_filepath, _key, _sampleRate = 32000, _audioChannel = audio_mono){
	var _soundData = SOUND_DATA;
	if (!is_undefined(_soundData[? _key])) {return;}
	
	// Attempt to load in the file to a temporary buffer; exiting the function is the file cannot load for
	// any particular reason (Ex. Doesn't exist, it's corrupted, etc.).
	var _file = buffer_load(_filepath + ".wav");
	if (_file == -1){
		show_debug_message("Invalid Filepath -- Buffer could not be created!");
		return;
	}
	
	// Take the loaded file and copy its data into a buffer that is setup in such a way that it can recreate
	// the audio in-game with GameMaker's built-in audio functionality.
	var _filesize, _buffer;
	_filesize = buffer_get_size(_file);
	_buffer = buffer_create(_filesize, buffer_fixed, 2);
	buffer_copy(_file, 0, _filesize, _buffer, 0);
	buffer_delete(_file);

	// Create a new sound asset from the sontents of the buffer, creating a struct that will store that sound,
	// the buffer ID that the sound is contained within, the sample rate of the audio, and the sound's size.
	ds_map_add(_soundData, _key, {
		audioBuffer :	audio_create_buffer_sound(_buffer, buffer_s16, _sampleRate, 0, _filesize, _audioChannel),
		bufferID :		_buffer,
		sampleRate :	_sampleRate,
		size :			_filesize,
	});
}

#endregion