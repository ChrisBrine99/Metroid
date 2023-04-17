#region Initializing any macros that are useful/related to obj_interact_component
#endregion

#region Initializing enumerators that are useful/related to obj_interact_component
#endregion

#region Initializing any globals that are useful/related to obj_interact_component
#endregion

#region The main object code for obj_interact_component

/// @param {Real}			x					Position on the x-axis to place the component at within the room.
/// @param {Real}			y					Position on the y-axis to place the component at within the room.
/// @param {Real}			radius				Maximum distance the player can be at while still being able to interact with the given object.
/// @param {Function}		interactFunction	The function that will be called when this component is interacted with.
/// @param {String}			interactPrompt		Determines the text that shows up alongside the interactable's UI prompt.
/// @param {Id.Instance}	id
function obj_interact_component(_x, _y, _radius, _interactFunction, _interactPrompt, _id) constructor{
	// Much like Game Maker's own object_index variable, this will store the unique ID value provided to this
	// object by Game Maker during runtime; in order to easily use it within a singleton system.
	object_index = obj_interact_component;
	
	// Much like Game Maker's built-in x and y variables for their standard objects, this pair will store the
	// origin of the interact component's position, which is then used in tandem with the interact's radius
	// area is being hit by the player's interaction point.
	x = _x;
	y = _y;
	
	// Three important variables for this component; the first determining how large of an area from the position
	// of the component's origin the player's interact point can be considered "interacting" with the parent
	// object of this component. The second variable stores the index to the function that is called when
	// an interaction actually occurs. Finally, the third variable stores the string that is shown on the
	// HUD when the player is able to interact with this component.
	radius = _radius;
	interactFunction = _interactFunction;
	interactPrompt = _interactPrompt;
	
	// Stores the unique ID value for the instance that this interact component is attached to. This allows
	// the component to always know exactly which instance is linked to their respective interaction function
	// if that function requires the parent object to be referenced.
	parentID = _id;
	
	// The flag that determines if the player is allowed to interact with said interactable object. This
	// interactability is determined by the room's current lighting OR if the player's flashlight is active.
	canInteract = false;
	
	/// @description The function that is called in order to check if the player can see the item or not in
	/// the current room. This is determined by searching for the closest light source to the object and 
	/// then comparing if that distance is within range of the output from said light source; returning true
	/// or false depending on the result of this check.
	can_player_interact = function(){
		var _x, _y, _radius, _nearestLight, _nearestDistance, _length, _tempDistance;
		_x = x;
		_y = y;
		_radius = radius;
		_nearestLight = noone;
		_nearestDistance = 0;
		_length = ds_list_size(global.lightSources);
		for (var i = 0; i < _length; i++){
			with(global.lightSources[| i]){
				_tempDistance = compare_interactable_distance(_x, _y, _radius, _nearestDistance);
				if (_tempDistance != -1){ // Overwrite the previously closest light's data with the new light's data.
					_nearestDistance = _tempDistance;
					_nearestLight = id;
				}
			}
		}
		
		// Oonce all of the lights have been parsed through and compared with the position of the interact 
		// component's parent object for interactability, the flag that allows it to be interacted with is 
		// set based on if an instance ID value is stored in the _nearestLight variable is a valid instance 
		// ID. (No instance will be a value of "noone")
		canInteract = (_nearestLight != noone);
	}
}

#endregion

#region Global functions related to obj_interact_component

/// @description The function that allows an interact component to be created and have its pointer stored 
/// within a variable for later use within that entity instance object. It will also add this component to
/// a global list of interact component instances which is used to figure out which one the player has 
/// interacted with whenever they press their interact input.
/// @param {Real}		x
/// @param {Real}		y
/// @param {Real}		offsetX
/// @param {Real}		offsetY
/// @param {Real}		radius
/// @param {Function}	interactFunction
/// @param {String}		interactPrompt
function object_add_interact_component(_x, _y, _offsetX, _offsetY, _radius, _interactFunction, _interactPrompt){
	if (interactComponent == noone){
		interactComponent = new obj_interact_component(_x + _offsetX, _y + _offsetY, _radius, _interactFunction, _interactPrompt, id);
		interactComponent.can_player_interact(); // Performs the check for if this can be interacted with by the player.
		ds_list_add(global.interactables, interactComponent); // Add to the list of interactables.
	}
}

/// @description Another global interact component function that is responsible for clearing it out of memory.
/// It also clears the pointer's value from the interactable instance list if it also exists within that list;
/// ensuring it is removed by the garbage collector to free up memory. This should be placed in the "cleanup"
/// event of ANY objects that use an interaction component struct.
function object_remove_interact_component(){
	if (interactComponent != noone && ds_exists(global.interactables, ds_type_list)){
		var _index = ds_list_find_index(global.interactables, interactComponent);
		if (!is_undefined(_index)) {ds_list_delete(global.interactables, _index);}
		// Much like the light and audio component removal functions, the interact component's pointer must
		// be deleted from memory to signal its cleanup for the garbage collector. Otherwise, the object will
		// remain in memory without a reference to it; a big bad memory leak.
		delete interactComponent;
		interactComponent = noone;
	}
}

/// @description Loops through all currently loaded interactable component structs; checking their current
/// interactability based on how far they are from a given light source, or if the player has a flashlight
/// equipped and currently active, and so on.
function update_interactable_interact_state(){
	var _isFlashlightOn, _length;
	_isFlashlightOn = true; // PLAYER.isFlashlightOn;
	_length = ds_list_size(global.interactables);
	for (var i = 0; i < _length; i++){
		with(global.interactables[| i]){
			if (_isFlashlightOn){ // When the flashlight is on, the player will be able to interact no matter what.
				canInteract = true;
				continue;
			}
			can_player_interact();
		}
	}
}

#endregion
