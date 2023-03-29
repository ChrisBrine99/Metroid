#region Additional string functions

/// @description A simple function that returns a single line from a given string. An offset can be provided
/// to the function in order to see out the next available line starting from that character index. 
/// @param {String}	string
/// @param {Real}	startIndex
function string_get_line(_string, _startIndex = 1){
	var _line, _curChar, _length;
	_line = "";
	_length = string_length(_string);
	for (var i = _startIndex; i <= _length; i++){ // Loop from the start index until the final character of the string.
		_curChar = string_char_at(_string, i);
		// The new line character (\n) was hit; return the current line variable's data.
		if (_curChar == "\n") {return _line;}
		_line += _curChar; // Continue adding characters until the next line character (\n) is hit.
	}
	
	// If the last line was being retrieved by the function, it won't trigger the check for the "\n" character
	// within the loop. So, return whatever the line value is here to prevent that.
	return _line;
}

/// @description A simple function that takes in a string of any length and converts it to fit within a certain
/// width by applying line breaks in between words to prevent any from exceeding the provided maximum width.
/// While there is a limit to how wide the string can be, there isn't a limit to how many lines it can contain.
/// @param {String}			string
/// @param {Real}			maxWidth
/// @param {Asset.GMFont}	usedFont
function string_format_width(_string, _maxWidth, _usedFont){
	// Overwrite whatever the previous font was in order to have accurate calculations relative to the font
	// that will be used for the supplied string. Otherwise, the calculations will use whatever the current
	// font is and the width/height values will not be accurate.
	var _previousFont = draw_get_font();
	draw_set_font(_usedFont);
	
	// After properly storing the currently in use font and replacing it with the font that is required for
	// the supplied string, begin looping through the characters and formatting it in such a way that it 
	// doesn't exceed the supplied maximum width value.
	var _newString, _curLine, _curWord, _length, _curChar;
	_newString = ""; // Initialize as empty in case the for loop doesn't execute; prevents crashing
	_curLine = "";
	_curWord = "";
	_length = string_length(_string);
	for (var i = 1; i <= _length; i++){
		_curChar = string_char_at(_string, i);
		if (i == _length || _curChar == " " || _curChar == "-"){ // Appends the new word to the string for every space/hyphen OR if it's the end of the string.
			if (string_width(_curLine + _curWord) > _maxWidth){ // Put the word onto the next line and start calculating the next line's characters.
				_newString += _curLine + "\n";
				_curLine = _curWord;
			} else{ // The word can fit onto the current line; simply add it and move onto the next word.
				if (_curLine == "") {_curLine += _curWord;}
				else {_curLine += " " + _curWord;}
			}
			_curWord = "";
			continue; // Skip over the " " character; moving onto the next available word in the string.
		}
		// If no space is detected; add the character to the variable for storing the current word.
		_curWord += _curChar;
	}
	// Add the last line and final character to the string before it's return from the function.
	_newString += _curLine + _curChar;
	
	// After exiting the loop, reset the font back to what it was before this function was called. This
	// prevents any errors specifically with the outline shader, since changing fonts without updating the
	// current texel size could cause rendering errors.
	draw_set_font(_previousFont);
	
	// Finally, return the new string; formatted in such a way that there are line breaks allowing it to fit
	// within the bounds of 0 and the "_maxWidth" argument provided by the code.
	return _newString;
}

/// @description Takes in a string and also a delimiter character, which is what determines how the string
/// will be broken apart into the split array. In short, the function goes through every character in the
/// array until the delim character is hit. From there it will add that chunk of the string onto the split
/// string array and repeat that process until the string is completely split up.
/// @param {String}	string
/// @param {String}	delim
function string_split_array(_string, _delim){
	// A delim value cannot be more than one character long. So, if that's the case OR there isn't a single
	// delim character found within the string; it will simply be returned in an unaltered form.
	if (string_length(_delim) > 1 || string_count(_delim, _string) == 0) {return array_create(1, _string);}
	
	// Loop through the entire string; parsing each character into a storage variable until a delim value
	// is hit. When that occurs, the string will be added to the split string array and that will keep
	// repeating until the string has been completely parsed.
	var _curString, _array, _length, _char;
	_curString = "";
	_array = array_create(0, "");
	_length = string_length(_string);
	for (var i = 0; i <= _length; i++){
		_char = string_char_at(_string, i);
		if (_char == _delim){ // The current character is a delim value; split the string and move onto the next chunk.
			_array[array_length(_array)] = _curString;
			// If the next chunk of the string doesn't contain a delim value, add it to the end of the array and exit the loop.
			if (string_last_pos(_delim, _string) == i){
				_array[array_length(_array)] = string_copy(_string, i + 1, _length - i);
				break;
			}
			_curString = "";
			continue;
		}
		// No delim value was found; add the character to the current string chunk.
		_curString += _char;
	}
	
	// Finally, return the array containing each chunk of the split string in its available indexes.
	return _array;
}

/// @description A simple function that takes in a number and adds a specific amount of 0s to the front of that
/// number until the amount of numbers found within the formatted string matches the total amount of zeroes
/// set within the "_totalZeroes" argument space. Optionally, the number's value can be limited to the max
/// possible place values alloted by the max amount of zeroes. (Ex. 1435 with a total of 3 possible zeroes 
/// would be formatted to "999" by the function)
/// @param {Real}	number
/// @param {Real}	totalZeroes
function string_number_add_zeroes(_number, _totalZeroes, _limitNumber = false){
	_number = floor(_number); // Removes any decimal values from the supplied number.
	
	// Determine how many zeroes must be added in order to complete the requirements of the function arguments.
	// This means there are three possible cases for the value: the number has more place values than available
	// zeroes and it should be limited, the number is equal to or greater than the number of zeroes and it should
	// simply be returned as a string version of the value, or there are a certain number of zeroes that will
	// be added to the front of the number to format it properly.
	var _numberAsString, _availableZeroSpaces;
	_numberAsString = string(_number);
	_availableZeroSpaces = _totalZeroes - string_length(_numberAsString);
	if (_availableZeroSpaces < 0 && _limitNumber){ // Return a repeated sequence of 9's to match the max possible value if the number is limited to a certain number of place values.
		return string_repeat("9", _totalZeroes);
	} else if (_availableZeroSpaces <= 0){ // Simply return the number as a string.
		return _numberAsString;
	} else{ // Adds zeros in front of the number to match the calculated _availableZeroSpaces value.
		return string_repeat("0", _availableZeroSpaces) + _numberAsString;
	}
}

/// @description Takes in a number (Can even be non-integer) and converts it to the standard hours/minutes/seconds
/// format for calculating time. An optional flag to allow the function to calculate milliseconds can also be
/// used, which will use whatever the current decimial's top 2 place values for it's final calculated amount.
/// @param {Real}	number
/// @param {Bool}	displayMilliseconds
function string_number_to_time_format(_number, _displayMilliseconds = false){
	// All of these calculations are stored inside of local variables for easier readability on both return
	// values found in the function. Otherwise, these would clutter what is already two cluttered lines of
	// code even further.
	var _hours, _minutes, _seconds;
	_hours = floor(_number / 3600);
	_minutes = floor((_number / 60)) % 60;
	_seconds = _number % 60;
	
	// If the number should be formatted to display the current milliseconds; calculate them by grabbing the
	// fraction value from the provided number and multiplying that by 100 since 100 milliseconds = 1 second.
	if (_displayMilliseconds){
		var _milliseconds = frac(_number) * 100;
		return string_number_add_zeroes(_hours, 2) + ":" + string_number_add_zeroes(_minutes, 2) + ":" + string_number_add_zeroes(_seconds, 2) + "." + string_number_add_zeroes(_milliseconds, 2);
	}
	
	// If there isn't a need to display milliseconds, simply copy what the first return does minus the step
	// that calculates milliseconds and the addition of that in the return line.
	return string_number_add_zeroes(_hours, 2) + ":" + string_number_add_zeroes(_minutes, 2) + ":" + string_number_add_zeroes(_seconds, 2);
}

/// @description Allows a monospaced piece of text to get the proper width for itself, which wouldn't be
/// possible with Game Maker's conventional "string_width" function unless the font is question actually was
/// monospaced to begin with. Optionally, special characters can be ignored in the monospacing just like the 
/// monospace text rendering function allows.
/// @param {String}			string
/// @param {Real}			separation
/// @param {Asset.GMFont}	usedFont
/// @param {Bool}			ignoreSpecialCharacters
function string_width_monospace(_string, _separation, _usedFont, _ignoreSpecialCharacters = false){
	// Overwrite whatever the previous font was in order to have accurate calculations relative to the font
	// that will be used for the supplied string. Otherwise, the calculations will use whatever the current
	// font is and the width/height values will not be accurate.
	var _previousFont = draw_get_font();
	draw_set_font(_usedFont);
	
	// After storing the previous font and setting up the string width/height calculations to use the accurate
	// dimensions for the string's desired font, initialize some local variables that will be useful within the
	// loop that calculates the string's width.
	var _lineWidth, _stringWidth, _length, _curChar;
	_lineWidth = 0;
	_stringWidth = 0;
	_length = string_length(_string);
	for (var i = 0; i < _length; i++){
		_curChar = string_char_at(_string, i);
		// Whenever a newline character is found within the current string, the line width variable is reset
		// in order to begin counting the width of said new line from the beginning. If the line width for
		// the one that was just counted exceeds the current string width, overwrite that value since it's
		// actually what is considered to be the width of the string. 
		if (_curChar == "\n"){
			if (_lineWidth > _stringWidth) {_stringWidth = _lineWidth;}
			_lineWidth = 0;
			continue; // Code values aren't actual displayable strings, so these characters aren't considered in the width calculations.
		}
		// If special characters are ignored for the text's monospacing, they will simply use the width they
		// were provided by the font itself. Otherwise, they and all character will use the separation value.
		if (_ignoreSpecialCharacters && is_special_character(_curChar))  {_lineWidth += string_width(_curChar);}
		else															 {_lineWidth += _separation;}
	}
	// After exiting the loop, reset the font back to what it was before this function was called. This
	// prevents any errors specifically with the outline shader, since changing fonts without updating the
	// current texel size could cause rendering errors.
	draw_set_font(_previousFont);
	
	// Once the entire string has been parsed, the largest line's width will be returned by the function.
	// However, the line width variable is what is returned instead if the string is only a single line. If
	// this didn't happen the value returned would actually be 0.
	if (string_count("\n", _string) == 0) {return _lineWidth;}
	return _stringWidth;
}

/// @description A simple function that checks to see if the supplied character is considered a "special
/// character." In short, a special character is any character that isn't an upper case letter, lower case
/// letter, number, or "code" value.
/// @param {String}	character
function is_special_character(_char){
	var _code = ord(_char); // Convert the character to it's ascii value counterpart
	return ((_code >= 20 /* " " */ && _code <= 47 /* "/" */) || (_code >= 58 /* ":" */ && _code <= 64 /* "@" */) || (_code >= 91 /* "[" */ && _code <= 96 /* "`" */) || (_code >= 123 /* "{" */ && _code <= 126 /* "~" */));
}

#endregion

#region Additional math functions

/// @description A simple function that linearly adds or subtracts a given value towards the supplied target
/// value. The speed that the value reaches said target is determined by the value in the _modifier argument
/// space--higher values leading to the value reaching its target at a faster speed.
/// @param {Real}	value
/// @param {Real}	target
/// @param {Real}	modifier
function value_set_linear(_value, _target, _modifier){
	if (_value == _target) {return _value;} // The value is already at the target number; simply return that number.
	
	// Since this is a linear calculation, there needs to be one calculation for an increasing value to a
	// target and one for a decreasing value to said target. Both will perform checks that prevent the
	// value from being greater than the target or less than the target depending on if the modifier was
	// added or subtracted from the current _value variable's value, respectively.
	if (_value < _target){ // Increasing the value towards the target at the speed set by _modifier.
		var _targetValue = _value + (_modifier * DELTA_TIME);
		if (_targetValue >= _target - _modifier)	{return _target;}
		else										{return _targetValue;}
	} else if (_value > _target){ // Decreasing the value towards the target at the speed set by _modifier.
		var _targetValue = _value - (_modifier * DELTA_TIME);
		if (_targetValue <= _target + _modifier)	{return _target;}
		else										{return _targetValue;}
	}
}

/// @description A simple function that adds or subtracts a number from a given value towards its target
/// relative to how far apart the target and original value are. The greater the distance, the faster the
/// value will be pulled toward the target, and vice versa for smaller distances.
/// @param {Real}	value
/// @param {Real}	target
/// @param {Real}	speed
function value_set_relative(_value, _target, _speed){
	if (_value == _target) {return _target;} // The value is already as the target number; simply return that number.
	
	// In order to prevent the weird effect that can occur when the value gets really close to the target and
	// begins moving in decimal increments every frame, the value will simply become the target if its rounded
	// value is equal to that target value.
	if (round(_value) == _target) {return _target;}
	
	// Calcuate the value that SHOULD be returned by the function in order to perform an important check on
	// said value. In short, if the value surpasses the target in the event of delta time being an absurdly
	// high value, it will clip that value at the target instead of letting it surpass that bound.
	var _targetValue = _value + ((_target - _value) * _speed * DELTA_TIME);
	if ((_targetValue >= _target && _value < _target) || (_targetValue <= _target && _value > _target)) {return _target;}
	return _targetValue; // If the target value doesn't go out of intended bounds, simply return the target.
}

#endregion

#region Inventory functions

/// @description Adds an item of a given amount to the inventory. (Weapons are treated like single items
/// despite the fact that they technically have "stack" amount--those are just each gun's magazine size)
/// It will look for either an empty slot or a slot containing the matching item; adding whatever quantity
/// it can from there before moving onto the next available slot. The optional flag "createItem" can be
/// toggled in order to create an item object within the game world for the excess quantity if it exists.
/// @param {String}	itemName
/// @param {Real}	quantity
/// @param {Real}	durability
/// @param {Bool}	createItem
function inventory_item_add(_itemName, _quantity, _durability, _createItem = false){
	// Grab the item's basic data from the master data structure. If the attempt at grabbing this ds_map of
	// data returns "undefined", it means the item that is being added to the inventory doens't actually
	// exist in the game's data, so it shouldn't be added.
	var _itemData = global.itemData[? KEY_ITEM_LIST][? _itemName];
	if (is_undefined(_itemData)) {return;}
	
	// Loop through the item array searching for an empty slot to place however much of the desired quantity
	// that can fit in said slot; looping through until either the full quantity could be added or the
	// inventory is completely filled before the quantity can be added.
	var _availableSpace = 0;
	for (var i = 0; i < global.curItemInvSize; i++){
		// If the pointer value is stored in current slot is equal to "noone" (-4) it means that there is
		// an available slot for a new item struct to occupy. So, it will simply be added to the slot and 
		// any remainder will be added to a later slot if possible.
		if (global.items[i] == noone){
			array_set(global.items, i, {
				// Store the name of the item, which is then displayed on the inventory screen when the item
				// is highlighted AND is also used to referenced the data stored within the global item data
				// ds_map that is loaded in from an external file on the game's start up.
				itemName :		_itemName,
				
				// Stores the item's type within the actual struct containing the general item info. This
				// type determines what options will be available to the player when the item it selected by
				// them in the inventory's item screen.
				itemType :		_itemData[? ITEM_TYPE],
				
				// The values relating to the item's current quantity within the single slot and the maximum
				// amount that can be stored within that slot at any given time. Most items have a unique
				// maximum value, so its stored here for easier reference.
				maxQuantity :	_itemData[? ITEM_QUANTITY],
				quantity :		0,
				
				// Much like above, this variable pair stores the current durability of the item (Applies to
				// weapons only) as well as the maximum possible durability amount. (Each use consumes only
				// one "durability" from the weapon--a zero resulting in a broken and unusable weapon) This
				// value is only ever used in the game on the two highest difficulty levels: Nightmare and
				// Hell's Wrath.
				maxDurability : _itemData[? ITEM_DURABILITY],
				durability :	0,
				
				// A variable that is exclusively used by weaponry; specifically weapons that consume 
				// ammunition whenever they are used. It will store the name of the ammo that is found within
				// the gun, so that it remains there even if the weapon is dropped or unequipped, and so on.
				currentAmmo :	_itemData[? ITEM_AMMO_IN_USE],
				
				// A simple flag that easily lets the inventory menu know whether or not the player has this 
				// item equipped; adding an "E" symbol above the item's icon to signify the equipped state.
				isEquipped :	false,
			});
			
			// After the item struct has been initialized, the durability and quantity will be set. This
			// can't be done inside of the struct's initialization code above because it will crash. So, it
			// is done out here; capping their values at the maximum durability and quantity, respectively.
			with(global.items[i]){
				durability = min(_durability, maxDurability);
				quantity = min(_quantity, maxQuantity);
				_quantity -= quantity; // Remove the quantity of this added item from the required total.
			}
			
			// Returning 0 to let the world item object know it has all been picked up by the player.
			if (_quantity == 0) {return 0;} 
			
			// If the quantity isn't zero it means that there is still more of the item to add to the 
			// inventory, so onto the next available slot to try and find a place for that remainder.
			continue;
		}
		
		// If there is an item in the slot, compare its name to the name of the item that is being added to
		// the item inventory. If they match, try to add whatever quantity possible to the slot before moving
		// onto the next available slot.
		with(global.items[i]){
			if (itemName == _itemName && itemType != TYPE_WEAPON && quantity < maxQuantity){
				_availableSpace = maxQuantity - quantity;
				
				// There are more items than can fit into the current slot; fill the slot and look for another
				// available slot to add the remaining quantity to.
				if (_quantity > _availableSpace){
					quantity = maxQuantity;
					_quantity -= _availableSpace;
					continue; // This slot is filled; move onto the next slot immediately.
				}
				
				// There is enough space in the current slot; add the entire quantity to it.
				quantity += _quantity;
				return 0; // Exit out of the function as all of the quantity has been added to the inventory.
			}
		}
	}
	
	// If there isn't enough space within the inventory to add the entire quantity to the it BUT the item
	// didn't previously exist within the world to begin with, (Ex. crafting items, combining items, etc.)
	// A new world item will be spawned containing the data for the remainder of the quantity that couldn't
	// fit into the item inventory.
	if (_quantity > 0 && _createItem) {object_create_world_item(PLAYER.x, PLAYER.y, _itemName, _quantity, _durability);}
	
	// If the loop completed its execution before the entire quantity of the desired item could be added into
	// the inventory; return that remaining quantity back to wherever this function was called, so it can be
	// stored for whenever the player does have the space for the remainder.
	return _quantity;
}

/// @description A function that works much like the opposite of the item adding function; removing a desired
/// quantity of an item from the inventory instead of attempting to add that amount. It will loop and look for
/// the item; removing each instance it finds until either the quantity has been met or the inventory has been
/// fully searched through. Unlike the slot removal function, this function will be unable to create an item
/// for any excess quantity since that doesn't really make much sense with the context of how this function
/// can remove multiple slots worth of items from the inventory; making it only useful for event-based
/// inventory item removal. (Ex. Player losing all their items for whatever reason, and can't get them back)
/// @param {String}	itemName
/// @param {Real}	quantity
function inventory_item_remove_amount(_itemName, _quantity){
	// Loop through the inventory and remove as much of the quantity required of the item from it as possible.
	// This is done by linearly going through each slot and comparing the name data of the item within the 
	// slot. (If there is a valid pointer stored within the item slot for an item data struct) For each item
	// found that matches, the max possible quantity will be removed and the code will either continue looping
	// to find another instance of the item if more still needs to be removed, or it will exit if the quantity
	// removed has been satisfied by the current slot.
	for (var i = 0; i < global.curItemInvSize; i++){
		with(global.items[i]){ // Jump into scope of the item's data struct; all empty slots will be ignored.
			if (itemName == _itemName){
				if (quantity > _quantity && itemType != TYPE_WEAPON){ // There are more than enough of the item in the current slot.
					quantity -= _quantity;
					return 0; // Exit with a 0 to signify the removal was successful.
				} else{ // There are enough of the item in the current slot; remove this item from the slot and continue looping.
					_quantity -= quantity;
					delete global.items[i];
					global.items[i] = noone;
				}
			}
		}
	}
	
	// The loop finished and the function wasn't able to removed the full amount of the desired item from the
	// inventory. So, return the quantity for use outside of this function. (Ex. changing the amount needed
	// of an item to reflect this new remainder)
	return _quantity;
}

/// @description Removes the entirety of whatever item was previously contained in the provided slot index.
/// This will clear that item's struct from memory and flag the slot as empty with the "noone" value. Much
/// like adding an item to the inventory, an option flag can be flipped to create a physical item in the 
/// world; only this time for the item that was previously in the slot that was now removed; not for any
/// excess quantity like the adding function since that isn't possible here.
/// @param {Real}	slotIndex
/// @param {Bool}	createItem
function inventory_item_remove_slot(_slotIndex, _createItem = false){
	// Don't bother attempting to remove an item from a slot where no item struct actually exists; it's
	// just a waste of processing time.
	if (global.items[_slotIndex] == noone) {return;}
	
	// If the flag to create a physical game object was toggled from the function's call, it will be created
	// BEFORE the item's data is cleared from the inventory slot. Otherwise, the item's data will be lost with
	// the struct deletion and it won't be able to be referenced for the item object's variables to use.
	if (_createItem){
		with(global.items[_slotIndex]){ // Jump into scope of the item struct to access its data.
			object_create_world_item(PLAYER.x, PLAYER.y, itemName, quantity, durability);
		}
	}
	
	// Finally, clear out the struct from memory and reset the value stored within that slot to the default
	// value for an empty slot: "noone". (Constant that is equal to -4)
	delete global.items[_slotIndex];
	global.items[_slotIndex] = noone;
}

/// @description Swaps the data between two of the avaiable slots in the inventory array, which is as simple
/// as moving the pointer values around between the two slot indexes. However, if an equipped item was moved,
/// the player's equipData struct's relavant slot needs to be updated as well, which is what the gross block
/// of if/else statements is below the pointer swap.
/// @param {Real}	firstSlot
/// @param {Real}	secondSlot
function inventory_item_swap_slots(_firstSlot, _secondSlot){
	var _tempSlot = global.items[_firstSlot];
	global.items[_firstSlot] = global.items[_secondSlot];
	global.items[_secondSlot] = _tempSlot;
	
	// Making sure the player's equip slot values still match up with the items they are paired to if the
	// inventory made a swap with one of those currently equipped items. So, all of the slots will be checked
	// in sequence to see if they match either the first or second slots value; switching to the other if
	// either is true.
	if ((global.items[_firstSlot] != noone && global.items[_firstSlot].isEquipped) || (global.items[_secondSlot] != noone && global.items[_secondSlot].isEquipped)){
		with(PLAYER.equipSlot){
			if (weapon == _firstSlot)			{weapon = _secondSlot;}
			else if (weapon == _secondSlot)		{weapon = _firstSlot;}
			
			if (throwable == _firstSlot)		{throwable = _secondSlot;}
			else if (throwable == _secondSlot)	{throwable = _firstSlot;}
			
			if (armor == _firstSlot)			{armor = _secondSlot;}
			else if (armor == _secondSlot)		{armor = _firstSlot;}
			
			if (flashlight == _firstSlot)		{flashlight = _secondSlot;}
			else if (flashlight == _secondSlot)	{flashlight = _firstSlot;}
			
			if (amuletOne == _firstSlot)		{amuletOne = _secondSlot;}
			else if (amuletOne == _secondSlot)	{amuletOne = _firstSlot;}
			
			if (amuletTwo == _firstSlot)		{amuletTwo = _secondSlot;}
			else if (amuletTwo == _secondSlot)	{amuletTwo = _firstSlot;}
		}
	}
}

/// @description A simple function that loops through the entirety of the player's currently available item
/// inventory space in order to calculate the sum of a given item found within space.
/// @param {String}	itemName
function inventory_item_count(_itemName){
	var _quantity = 0;
	for (var i = 0; i < global.curItemInvSize; i++){
		if (is_struct(global.items[i]) && global.items[i].itemName == _itemName){
			// UNIQUE CASE -- If the item in the slot is a weapon; it means that its entire "quantity" must be
			// counted as a single item because the quantity is actually just the ammunition that is currently
			// available within the weapon.
			if (global.items[i].itemType == TYPE_WEAPON){
				_quantity++;
				continue;
			}
			
			// Every other item type simply has its quantity added to the total.
			_quantity += global.items[i].quantity;
		}
	}
	
	// Once the entire inventory has been checked; return the sum of the item that was requested. 
	return _quantity;
}

/// @description The function that handles the basic combination logic for two pre-selected items in the
/// inventory. (Selected by the slots they are stored in relative to what the player selected to initiate this
/// crafting process) In short, the function will search through the crafting data in order to find the matching
/// crafting recipe; switch the order of the pair to match said recipe's stored order. Then, it will attempt
/// to call the provided crafting function, which is what will actually process the crafting logic for the
/// given recipe.
/// @param {Real}	firstSlot
/// @param {Real}	secondSlot
function inventory_item_combine(_firstSlot, _secondSlot){
	// First, store some values for easier readability and because Game Maker likes to work with local values
	// instead of constantly having to jump into struct's and data structures in order to retrieve these
	// values.
	var _firstItemName, _secondItemName, _craftingData;
	_firstItemName = global.items[_firstSlot].itemName;
	_secondItemName = global.items[_secondSlot].itemName;
	_craftingData = global.itemData[? KEY_CRAFTING_DATA];
	
	// Once the necessary variables have been stored, the code will enter into a loop that will linearly
	// search through the ds_list of crafting recipe data; comparing the names of each item with the names
	// of the items in the recipe data for each index. Once it finds a matching pair, it will store that
	// index value into the list and exit the loop.
	var _length, _recipeID;
	_length = ds_list_size(_craftingData);
	for (var i = 0; i < _length; i++){
		// There are two possible combinations for the recipe. So, the first order that is checked is the
		// order that the player selected the items in. (First slot and second slot) If that combination
		// doesn't match the current crafting recipe, they will be switched in order and checked if they
		// match yet again. (Second slot's name first, and first is second) If the latter is the correct
		// order, the names will be swapped between the "firstItemName" and "secondItemName" variables to
		// match the proper order of the recipe before moving forward with the code.
		if (_craftingData[| i][? CRAFTING_FIRST_ITEM] == _firstItemName &&  _craftingData[| i][? CRAFTING_SECOND_ITEM] == _secondItemName){
			_recipeID = i;
			break; // Simply exit the loop once the ID has been found.
		} else if (_craftingData[| i][? CRAFTING_FIRST_ITEM] == _secondItemName &&  _craftingData[| i][? CRAFTING_SECOND_ITEM] == _firstItemName){
			_recipeID = i;
			// Since the order for the item names are reversed in the recipe, they need to be flipped for it 
			// to process correctly. So, they will be flipped using a temporary storage variable.
			var _temp = _firstItemName;
			_firstItemName = _secondItemName;
			_secondItemName = _temp;
			break; // Exit the loop after swapping the names between the "first" and "second" slots.
		}
	}
	
	// Now that the recipe's ID value is known, it will be stored within the "_craftingData" variable, which
	// was originally just storing the pointer to the entire list of recipes. After this, it will point to the
	// specific ds_map that stores the recipe data that we want.
	_craftingData = _craftingData[| _recipeID];
	
	// Finally, attempt to run the recipe's required crafting function, which is the chunk of code that will
	// actually handle the logic for removing item(s) and spitting out the resulting item. (This process is
	// different for weapon repairs or using the chemical purifier, for example. But both of these still
	// count as a combination/crafting command; hence why this function parsing is required) The function
	// will be called and whatever value it returns (True for success; false otherwise), this function will 
	// also return.
	var _craftingFunction = asset_get_index(_craftingData[? CRAFTING_FUNCTION]);
	if (script_exists(_craftingFunction)) {return script_execute(_craftingFunction, _craftingData, _firstItemName, _secondItemName);}

	// If there was no existing script in the code to match the required crafting function stored within the
	// recipe's data map, this function will automatically return false to signify a failed crafting attempt.
	return false;
}

#endregion

#region Item crafting functions

/// @description The default method for combining two items together, which will check their respective
/// quantities within the inventory at the current moment; seeing if the match the required cost for the
/// crafting recipe. If they do, the required quantities of each will be removed from the inventory and the
/// resulting item from the recipe will be added to the inventory.
/// @param {Id.DsMap}	craftingData
/// @param {String}		firstItemName
/// @param {String}		secondItemName
function inventory_item_craft_default(_craftingData, _firstItemName, _secondItemName){
	// First, make sure both items actually meet the criteria for their required costs within the crafting
	// recipe. If they do, continue with the crafting logic. Otherwise, don't create any item and don't
	// process the crafting recipe.
	if (inventory_item_count(_firstItemName) >= _craftingData[? CRAFTING_FIRST_COST] && inventory_item_count(_secondItemName) >= _craftingData[? CRAFTING_SECOND_COST]){
		// Remove the required amount of each item from the inventory using the amount removal function.
		inventory_item_remove_amount(_firstItemName, _craftingData[? CRAFTING_FIRST_COST]);
		inventory_item_remove_amount(_secondItemName, _craftingData[? CRAFTING_SECOND_COST]);
		
		// Once the items for the recipe have had their quantities removed from the inventory, the crafted
		// item will be added to the inventory. If there was a set range of possible quantities the calculted
		// quantity will be pulled from that range of values. The item creation flag for the inventory add
		// function is toggled true in case there isn't space in the inventory for this new item. In that
		// case the item will be created and added to the physical game world for the player to pick up once
		// they have made space in their inventory.
		var _quantity = irandom_range(_craftingData[? CRAFTING_MIN_RESULT], _craftingData[? CRAFTING_MAX_RESULT]);
		// TODO -- Add check for the "Lucky Amulet being equipped here, which will max the quantity of the
		// possible amount crafted for any item that has a range of possibilitites.
		inventory_item_add(_craftingData[? CRAFTING_RESULT_ITEM], _quantity, global.itemData[? KEY_ITEM_LIST][? _craftingData[? CRAFTING_RESULT_ITEM]][? ITEM_DURABILITY], true);
	
		// Return true to signify that the crafting process was successfully executed by the function.
		return true;
	}
	
	// Return false because the required costs for the items in the recipe wasn't met by either the first
	// item, the second item, or both. This signifies a failed crafting attempt and should be handled
	// accordingly.
	return false;
}

#endregion

#region JSON functions

/// @description Simply loads in the supplied JSON file by decrypting the data into a temporary file and then
/// reading the information from that file; returning a matching data structure once the it is decoded.
/// @param {String}	filename
/// @param {String}	decryptKey
function encrypted_json_load(_filename, _decryptKey = ""){
	try{
		// TODO -- Add decryption stuff here
		
		// Load in the decrypted data from the temporarily created file; loading it in using a buffer.
		var _buffer, _bufferString;
		_buffer = buffer_load(_filename);
		_bufferString = buffer_read(_buffer, buffer_string);
		buffer_delete(_buffer); // Clear the buffer from memory after reading.
	
		// TODO -- Delete the decrypted file here
	
		// Return the decoded string that was loaded from the JSON file; returning a massive data structure
		// containing many lists within maps of lists and so on.
		return json_decode(_bufferString);
	} catch(_error){
		show_debug_message(_error.message + " in Script: " + _error.script);
	}
}

#endregion