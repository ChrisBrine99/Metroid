#region Initializing any macros that are useful/related to obj_audio_component
#endregion

#region Initializing enumerators that are useful/related to obj_audio_component
#endregion

#region Initializing any globals that are useful/related to obj_audio_component
#endregion

#region The main object code for obj_audio_component

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_audio_component(_index) : base_struct(_index) constructor{
	// Stores the unique ID value for the instance that this audio component is attached to. This allows
	// the component to always know exactly which instance is linked to them if the parent ever needs to
	// be referenced through the audio component.
	parentID = noone;
	
	// Create two variables for the coordinates of the light within the game world, which are identical to
	// the variable pair that is built into every Game Maker object by default.
	x = 0;
	y = 0;
	
	// Variables that determine how the sound acts relative to the listener's current position within the room.
	// The first is the distance to begin the falloff, the second is the maximum audible distance, and the last
	// determines how fast the sound's volume falls off with distance.
	falloffRefDist	= 0.0;
	falloffMaxDist	= 0.0;
	falloffFactor	= 0.0;
	
	// Variables that store the audio emitter that is required to create the sound within the room's space
	// relative to the audio listener's current position and the ID for thesound that the emitter is playing.
	emitterID	= audio_emitter_create();
	sound		= NO_SOUND;
	
	/// @description A function that is called when this struct is deleted from memory. All it does if free 
	/// the audio emitter that is tied to this component as a requirement for its functionality.
	cleanup = function(){
		audio_emitter_free(emitterID);
		emitterID = noone;
	}
	
	/// @description A simple function that plays the sound using the emitter that is tied to this audio
	/// component struct. The falloff properties are all stored within the component whereas the sound, 
	/// volume starting offset, and overall pitch of the sound are determined on a per-function-call basis.
	/// @param {Asset.GMSound}	sound			The sound resource that will be played through the audio component.
	/// @param {Real}			soundType		What "type" the sound falls under (Determines output volume).
	/// @param {Real}			loop			If true, the sound will loop indefinitely (Deleting the audio component will stop the sound).
	/// @param {Real}			stopPrevious	If true, any previous sound that matches this one will be stopped.
	/// @param {Real}			gain			Volume of the sound relative to its type.
	/// @param {Real}			offset			Position into the sound to begin playing the audio at.
	/// @param {Real}			pitch			Amount to alter the pitch of the sound up or down by 
	play_sound = function(_sound, _soundType, _loop, _stopPrevious, _gain = 1.0, _offset = 0.0, _pitch = 1.0){
		sound = play_sound_effect_on(emitterID, _sound, falloffRefDist, falloffMaxDist, falloffFactor, 0, 
					false, true, _soundType, _gain, _offset, _pitch);
	}
	
	/// @description A simple function that allows the audio component's falloff parameters to be adjusted
	/// after its initial creation should that be required during the game's runtime.
	/// @param {Real}	refDistance		How far the listener needs to be for the sound to begin its falloff.
	/// @param {Real}	maxDistance		The maximum possible distance that the sound can be heard.
	/// @param {Real}	factor			Determines how fast the volume falls off after the listener exceeds the "ref" distance.
	set_falloff_envelope = function(_refDistance, _maxDistance, _factor){
		falloffRefDist = _refDistance;
		falloffMaxDist = _maxDistance;
		falloffFactor = _factor;
	}
}

#endregion

#region Global functions related to obj_audio_component

/// @description Creates an instance of the "obj_audio_component" struct; returning its pointer value to
/// wherever called the function so that it can be referenced, managed, or manipulated further. That pointer
/// is also stored in a global list that manages all existing light instances which aids with rendering.
/// @param {Real}	x					X position of the emitter within the room.
/// @param {Real}	y					Y position of the emitter within the room.
/// @param {Real}	falloffRefDist		How far the listener needs to be for the sound to begin its falloff.
/// @param {Real}	falloffMaxDist		The maximum possible distance that the sound can be heard.
/// @param {Real}	falloffFactor		Determines how fast the volume falls off after the listener exceeds the "ref" distance.
function create_audio_component(_x, _y, _falloffRefDist, _falloffMaxDist, _falloffFactor = 2.0){
	var _audio = instance_create_struct(obj_audio_component);
	with(_audio){
		x				= _x;
		y				= _y;
		falloffRefDist	= _falloffRefDist;
		falloffMaxDist	= _falloffMaxDist;
		falloffFactor	= _falloffFactor;
		audio_emitter_position(emitterID, _x, _y, 0);
		audio_emitter_falloff(emitterID, _falloffRefDist, _falloffMaxDist, _falloffFactor);
	}
	return _audio;
}

/// @description Adds an audio component to a given Entity. It calls the "create_audio_component" function 
/// and stores the struct instance value that is returned by that function into the Entity's "audioComponent"
/// variable--the offsets being stored in their own respective variables as well.
/// @param {Real}	x					X position of the emitter within the room.
/// @param {Real}	y					Y position of the emitter within the room.
/// @param {Real}	offsetX				The audio component's offset on the x axis relative to the Entity's x position.
/// @param {Real}	offsetY				The audio component's offset on the y axis relative to the Entity's y position.
/// @param {Real}	falloffRefDist		How far the listener needs to be for the sound to begin its falloff.
/// @param {Real}	falloffMaxDist		The maximum possible distance that the sound can be heard.
/// @param {Real}	falloffFactor		Determines how fast the volume falls off after the listener exceeds the "ref" distance.
function object_add_audio_component(_x, _y, _offsetX, _offsetY, _falloffRefDist, _falloffMaxDist, _falloffFactor = 1.0){
	if (audioComponent != noone) // Prevent multiple audio components from being created for a single Entity.
		return;
	
	audioOffsetX = _offsetX;
	audioOffsetY = _offsetY;
	audioComponent = create_audio_component(_x + _offsetX, _y + _offsetY, 
							_falloffRefDist, _falloffMaxDist, _falloffFactor);
}

#endregion