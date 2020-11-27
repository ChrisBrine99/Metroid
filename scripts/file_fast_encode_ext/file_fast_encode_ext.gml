/// @description file_fast_encode_ext(input_file, output_file, is_encoding);
/// @function file_fast_encode_ext
/// @param0 input_file
/// @param1 output_file
/// @param2 is_encoding

function file_fast_encode_ext(_filename_in, _filename_out, _is_encoding) {
	// Script by Andrius Valkiunas http://www.existical.com/
	// Part of the "Fast Crypt Ultra" bundle at https://marketplace.yoyogames.com/assets/6057/fast-crypt
	// Version 1.4 - 22nd September 2019

	/*
	****************************************************************************************************
	*** PLEASE NOTE, THIS IS A VERY SIMPLE AND FAST ENCODING INTENDED TO OBFUSCATE AND HIDE YOUR     ***
	*** GAME DATA, AND IT DOES NOT OFFER SECURE PROTECTION AGAINST PROFESSIONAL HACKERS/CRACKERS :)  ***
	*** FOR BEST SECURITY PLEASE USE SCRIPT 'file_fast_crypt_ultra' or 'file_fast_crypt_ultra_zlib'  ***
	*** AS THEY BOTH USE SECURE ENCRYPTION WITH A SECRET KEY AND ALSO COMPRESSION (LAST SCRIPT ONLY) ***
	****************************************************************************************************

	This is a simple file encoding script which can encode/decode any file by shifting each byte value.
	Compared to script 'file_fast_encode', this one uses floating number of bits for better encoding.

	Same script is used to Encode and Decode files, but you must use different parameter 'is_encoding' for encoding and decoding operations.
	Please note: If you use 'true' as 'is_encoded' parameter when encoding file, then you must use 'false' when decoding or vice versa.

	You can use same filename as input and output parameters.

	******** USAGE EXAMPLE: *********************************************

	* Encoding file to a different file:
	file_fast_encode_ext("game_level_01.ini", "game_level_01.lev", true);

	* Decoding encoded file to a different file:
	file_fast_encode_ext("game_level_01.lev", "game_level_01.ini", false);

	* Encoding file to the same file:
	file_fast_encode_ext("user_progress.dat", "user_progress.dat", true);

	* Decoding encoded file to the same file (same as above):
	file_fast_encode_ext("user_progress.dat", "user_progress.dat", false);

	*********************************************************************

	If you like this script, please consider making a donation to the author using PayPal to valkiunas@gmail.com.

	*/

	var _data, _pos, _len, _bit_shift, _shift_direction;
	_pos = 0; // Initial 'seek' position in the buffer
	_bit_shift = 128; // Initial bit shift value

	var _file_buffer = buffer_load(_filename_in); // Reading input file into the buffer
	_len = buffer_get_size(_file_buffer); // Getting lenght of the buffer (file size)
	buffer_seek(_file_buffer, buffer_seek_start, _pos); // Setting 'seek' at the initial position

	// Setting bit shift direction (increments or decrements)
	if (_is_encoding == true) { _shift_direction = 1; }
	else { _shift_direction = -1; }

	while(_pos != _len) // Processing each byte in the buffer step by step until the end of the buffer
	{
	    _data = (buffer_read(_file_buffer, buffer_u8) + _bit_shift) mod 256; // Reading current byte and encoding it
	
		// Bit shift calculations {{{
		_bit_shift += _shift_direction;
		if (_bit_shift > 255) { _bit_shift = 1;}
		else if (_bit_shift < 1) { _bit_shift = 255;}
	    // Bit shift calculations }}}
	
		buffer_seek(_file_buffer, buffer_seek_start, _pos); // Setting current 'seek' position in the buffer
		buffer_write(_file_buffer, buffer_u8, _data); // Writing processed byte to the buffer
		_pos = buffer_tell(_file_buffer); // Getting current 'seek' position in the buffer
	}

	buffer_save(_file_buffer, _filename_out); // Saving processed buffer into the output file
	buffer_delete(_file_buffer); // Removing buffer from memory
	
	return 1;
}
