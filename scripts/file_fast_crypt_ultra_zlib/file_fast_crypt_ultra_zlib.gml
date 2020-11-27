/// @description file_fast_crypt_ultra_zlib(input_file, output_file, is_encrypting, encryption_key_string);
/// @function file_fast_crypt_ultra_zlib
/// @param0 input_file
/// @param1 output_file
/// @param2 is_encrypting
/// @param3 encryption_key_string

function file_fast_crypt_ultra_zlib(_filename_in, _filename_out, _is_encrypting, _enc_key) {
	// Script by Andrius Valkiunas http://www.existical.com/
	// Part of the "Fast Crypt Ultra" bundle at https://marketplace.yoyogames.com/assets/6057/fast-crypt
	// Version 1.4 - 22nd September 2019

	/*
	******** README *****************************************************

	This is secure and fast file encryption script which can ENCRYPT and DECRYPT any file using provided ENCRYPTION KEY.
	Encrypted output file will look like a random sequence of bytes.
	Compared to script 'file_fast_crypt_ultra', which does not compress encrypted files, this one uses 'zlib' compression prior to encrypting.

	Same script is used to Encrypt and Decrypt files, but you must use different parameter 'is_encrypting' when encrypting and decrypting.

	This script  uses functions 'buffer_compress' prior to encryption and 'buffer_decompress' after decryption as 
	compression of an already encrypted file will not shrink file size and would be useless.

	!!! Please note: You must use 'true' as 'is_encrypting' parameter when encrypting file, and 'false' 
	when decrypting as apart of encryption this parameter also affects compression & decompression.

	You can use the same filename as input and output params.

	******** USAGE EXAMPLE: *********************************************

	* Encrypting to a different file:
	file_fast_crypt_ultra_ext("game_level_01.ini", "game_level_01.lev", true, "SomeEncryptionKey");
	* Decrypting to a different file
	file_fast_crypt_ultra_ext("game_level_01.lev", "game_level_01.ini", false, "SomeEncryptionKey");

	* Encrypting to the same file:
	file_fast_crypt_ultra_ext("user_progress.dat", "user_progress.dat", true, "SomeEncryptionKey");
	* Decrypting to the same file:
	file_fast_crypt_ultra_ext("user_progress.dat", "user_progress.dat", false, "SomeEncryptionKey");

	*********************************************************************

	If you like this script, please consider making a donation to the author using PayPal to valkiunas@gmail.com.

	*/

	var _data, _pos, _len, _xor_shift, _bit_shift, _shift_direction, _key_hash, _key_hash2, _key_pos, _key_len;
	_key_pos = 0; // Current position of encryptor key byte
	_pos = 0; // Initial 'seek' position in the buffer
	_bit_shift = 128; // Initial bit shift value
	_xor_shift = 1; // Initial xor shift value

	_key_hash = md5_string_unicode(_enc_key)+sha1_string_unicode(_enc_key)+md5_string_utf8(_enc_key)+sha1_string_utf8(_enc_key); // Getting first 72 byte (576 bit) long multi-hash string to use as encryption key
	_key_hash2 = md5_string_unicode(_key_hash)+sha1_string_unicode(_key_hash)+md5_string_utf8(_key_hash)+sha1_string_utf8(_key_hash); // Getting additional 72 byte (576 bit) long multi-hash string based on previous hash string
	_key_hash = _key_hash + _key_hash2; // Creating united unique 144 byte (1152 bit) hash key for encrypting data
	_key_len = string_length(_key_hash) div 2; // Key length in bytes

	// Setting bit shift direction (increments or decrements)
	if (_is_encrypting == true) { _shift_direction = 1; }
	else { _shift_direction = -1; }

	// Creating an array for each hash key byte {{{
	var _key_arr;
	for (var _i=0; _i<_key_len; _i++)
	{
	    _key_arr[_i] = hex_to_dec_fast(string_copy(_key_hash, (_i*2)+1, 2)); // Converting hexadecimal parts of hash key into decimal numbers which are stored in array
	}
	// Creating an array for each hash key byte }}}

	_xor_shift = _xor_shift mod 10; // Initial xor_shift value will depend on the key hash sum module of 10

	if (_is_encrypting) // If we are encrypting & compressing
	{
		var _input_buffer = buffer_load(_filename_in); // Reading uncompressed input file into the buffer
		var _input_buffer_size = buffer_get_size(_input_buffer);
	
		if(_input_buffer_size == 0) // If the buffer size is zero, return with an error
		{
			return 0; // Script returns 0 as unsuccessfull operation
		}
	
		var _data_buffer = buffer_compress(_input_buffer, 0, _input_buffer_size); // Compressing input_buffer to data_buffer
		buffer_delete(_input_buffer); // Deleting 'input_buffer' with uncompressed data from RAM to avoid memory leaks
	}
	else  // If we are decrypting & decompressing
	{
		var _data_buffer = buffer_load(_filename_in); // Reading compressed input file into the 'data_buffer'
	}
	_len = buffer_get_size(_data_buffer); // Getting lenght of the buffer (file size)
	buffer_seek(_data_buffer, buffer_seek_start, _pos); // Setting 'seek' at the initial position

	while(_pos != _len) // Processing each byte in the buffer step by step until the end of the buffer
	{
		switch (_shift_direction) // This depends of 'is_encrypting' argument
		{
		case 1: // When 'is_encrypting' is true
			_data = ((((buffer_read(_data_buffer, buffer_u8) + _bit_shift + _key_arr[_key_pos]) mod 256) ^ _xor_shift) ^ _key_arr[_key_pos]); // Reading current byte and encrypting it	
			break;
		case -1: // When 'is_encrypting' is false (for encrypting in opposite direction from above)
			_data = (((buffer_read(_data_buffer, buffer_u8)  ^ _xor_shift) ^ _key_arr[_key_pos]) + _bit_shift - _key_arr[_key_pos]) mod 256; // Reading current byte and encrypting it	
			break;
		}
	
		// Xor shift calculations {{{
		_xor_shift += 1;
	
		// Every 5000 bytes encryption key is changed
		if (_xor_shift > 5000)
		{ 
			_xor_shift = 1;
		
			// Modifying encryption key	{{{
			_key_hash = md5_string_unicode(_key_hash2)+sha1_string_unicode(_key_hash2)+md5_string_utf8(_key_hash2)+sha1_string_utf8(_key_hash2); // Getting first 72 byte (576 bit) long multi-hash string to use as encryption key
			_key_hash2 = md5_string_unicode(_key_hash)+sha1_string_unicode(_key_hash)+md5_string_utf8(_key_hash)+sha1_string_utf8(_key_hash); // Getting additional 72 byte (576 bit) long multi-hash string based on previous hash string
			_key_hash = _key_hash + _key_hash2; // Creating united unique 144 byte (1152 bit) hash key for encrypting data
		
			for (var _i=0; _i<_key_len; _i++)
			{
				_key_arr[_i] = hex_to_dec_fast(string_copy(_key_hash, (_i*2)+1, 2)); // Converting hexadecimal parts of hash key into decimal numbers which are stored in array
			}
			// Modifying encryption key	}}}
		}
		// Xor shift calculations }}}
	
		// Bit shift calculations {{{
		_bit_shift += _shift_direction * (_key_arr[(_key_len-1)-_key_pos] mod 2);
		if (_bit_shift > 255) { _bit_shift = 1;}
		else if (_bit_shift < 1) { _bit_shift = 255;}
		// Bit shift calculations }}}
	
		// Current Encryption Key byte position {{{
		_key_pos += 1;
		if (_key_pos > (_key_len-1)) {_key_pos = 0; }
		// Current Encryption Key byte position }}}
	
		buffer_seek(_data_buffer, buffer_seek_start, _pos); // Setting current 'seek' position in the buffer
		buffer_write(_data_buffer, buffer_u8, _data); // Writing processed byte to the buffer
		_pos = buffer_tell(_data_buffer); // Getting current 'seek' position in the buffer
	}

	if (_is_encrypting) // If we are encrypting & compressing
	{
		buffer_save(_data_buffer, _filename_out); // Writing compressed & encrypted 'data_buffer' into the output file
		buffer_delete(_data_buffer); // Removing 'data_buffer' buffer from RAM to avoid memory leaks
	}
	else  // If we are decrypting & decompressing
	{
		var _output_buffer = buffer_decompress(_data_buffer); // Decompressing data_buffer to 'output_buffer'
		buffer_delete(_data_buffer); // Removing compressed 'data_buffer' from memory	
		if (_output_buffer >= 0) // If buffer successfully decompressed
		{
			buffer_save(_output_buffer, _filename_out); // Writing final decrypted & decompressed 'output_buffer' data into the output file
			buffer_delete(_output_buffer); // Removing 'output_buffer' from RAM to avoid memory leaks
		}
		else // If buffer wasn't decompressed due to error (decompressing not compressed buffer)
		{
			return 0; // Script returns 0 as unsuccessfull operation
		}
	}

	return 1; // Script returns 1 as successfull operation
}
