/// @description Finds and returns an array containing the sprite index and image index that the keybinding
/// supplied in the argument field uses when drawn to the screen. If the key can't be found, the array will
/// return [-1, -1] instead.
/// @param	key		argument0

function keybinding_get_sprite(_key) {
	var _keyData = array_create(2, -1);
	switch(_key){
		case vk_backspace:		// KEY CODE == 8
			_keyData = [spr_control_icons_large, 1];
			break;
		case vk_tab:			// KEY CODE == 9
			_keyData = [spr_control_icons_large, 13];
			break;
		case vk_enter:			// KEY CODE == 13
			_keyData = [spr_control_icons_small, 36];
			break;
		case vk_shift:			// KEY CODE == 16
			_keyData = [spr_control_icons_large, 5];
			break;
		case vk_pause:			// KEY CODE == 19
			_keyData = [spr_control_icons_small, 54];
			break;
		case 20:				// KEY == CAPS LOCK
			_keyData = [spr_control_icons_large, 2];
			break;
		case vk_escape:			// KEY CODE == 27
			_keyData = [spr_control_icons_large, 2];
			break;
		case vk_space:			// KEY CODE == 32
			_keyData = [spr_control_icons_large, 0];
			break;
		case vk_pageup:			// KEY CODE == 33
			_keyData = [spr_control_icons_large, 11];
			break;
		case vk_pagedown:		// KEY CODE == 34
			_keyData = [spr_control_icons_large, 12];
			break;
		case vk_end:			// KEY CODE == 35
			_keyData = [spr_control_icons_large, 10];
			break;
		case vk_home:			// KEY CODE == 36
			_keyData = [spr_control_icons_large, 9];
			break;
		case vk_left:			// KEY CODE == 37
			_keyData = [spr_control_icons_small, 2];
			break;
		case vk_up:				// KEY CODE == 38
			_keyData = [spr_control_icons_small, 0];
			break;
		case vk_right:			// KEY CODE == 39
			_keyData = [spr_control_icons_small, 3];
			break;
		case vk_down:			// KEY CODE == 40
			_keyData = [spr_control_icons_small, 1];
			break;
		case vk_insert:			// KEY CODE == 45
			_keyData = [spr_control_icons_large, 7];
			break;
		case vk_delete:			// KEY CODE == 46
			_keyData = [spr_control_icons_large, 8];
			break;
		case ord("0"):			// KEY CODE == 48
			_keyData = [spr_control_icons_small, 53];
			break;
		case ord("1"):			// KEY CODE == 49
			_keyData = [spr_control_icons_small, 44];
			break;
		case ord("2"):			// KEY CODE == 50
			_keyData = [spr_control_icons_small, 45];
			break;
		case ord("3"):			// KEY CODE == 51
			_keyData = [spr_control_icons_small, 46];
			break;
		case ord("4"):			// KEY CODE == 52
			_keyData = [spr_control_icons_small, 47];
			break;
		case ord("5"):			// KEY CODE == 53
			_keyData = [spr_control_icons_small, 48];
			break;
		case ord("6"):			// KEY CODE == 54
			_keyData = [spr_control_icons_small, 49];
			break;
		case ord("7"):			// KEY CODE == 55
			_keyData = [spr_control_icons_small, 50];
			break;
		case ord("8"):			// KEY CODE == 56
			_keyData = [spr_control_icons_small, 51];
			break;
		case ord("9"):			// KEY CODE == 57
			_keyData = [spr_control_icons_small, 52];
			break;
		case ord("A"):			// KEY CODE == 65
			_keyData = [spr_control_icons_small, 4];
			break;
		case ord("B"):			// KEY CODE == 66
			_keyData = [spr_control_icons_small, 5];
			break;
		case ord("C"):			// KEY CODE == 67
			_keyData = [spr_control_icons_small, 6];
			break;
		case ord("D"):			// KEY CODE == 68
			_keyData = [spr_control_icons_small, 7];
			break;
		case ord("E"):			// KEY CODE == 69
			_keyData = [spr_control_icons_small, 8];
			break;
		case ord("F"):			// KEY CODE == 70
			_keyData = [spr_control_icons_small, 9];
			break;
		case ord("G"):			// KEY CODE == 71
			_keyData = [spr_control_icons_small, 10];
			break;
		case ord("H"):			// KEY CODE == 72
			_keyData = [spr_control_icons_small, 11];
			break;
		case ord("I"):			// KEY CODE == 73
			_keyData = [spr_control_icons_small, 12];
			break;
		case ord("J"):			// KEY CODE == 74
			_keyData = [spr_control_icons_small, 13];
			break;
		case ord("K"):			// KEY CODE == 75
			_keyData = [spr_control_icons_small, 14];
			break;
		case ord("L"):			// KEY CODE == 76
			_keyData = [spr_control_icons_small, 15];
			break;
		case ord("M"):			// KEY CODE == 77
			_keyData = [spr_control_icons_small, 16];
			break;
		case ord("N"):			// KEY CODE == 78
			_keyData = [spr_control_icons_small, 17];
			break;
		case ord("O"):			// KEY CODE == 79
			_keyData = [spr_control_icons_small, 18];
			break;
		case ord("P"):			// KEY CODE == 80
			_keyData = [spr_control_icons_small, 19];
			break;
		case ord("Q"):			// KEY CODE == 81
			_keyData = [spr_control_icons_small, 20];
			break;
		case ord("R"):			// KEY CODE == 82
			_keyData = [spr_control_icons_small, 21];
			break;
		case ord("S"):			// KEY CODE == 83
			_keyData = [spr_control_icons_small, 22];
			break;
		case ord("T"):			// KEY CODE == 84
			_keyData = [spr_control_icons_small, 23];
			break;
		case ord("U"):			// KEY CODE == 85
			_keyData = [spr_control_icons_small, 24];
			break;
		case ord("V"):			// KEY CODE == 86
			_keyData = [spr_control_icons_small, 25];
			break;
		case ord("W"):			// KEY CODE == 87
			_keyData = [spr_control_icons_small, 26];
			break;
		case ord("X"):			// KEY CODE == 88
			_keyData = [spr_control_icons_small, 27];
			break;
		case ord("Y"):			// KEY CODE == 89
			_keyData = [spr_control_icons_small, 28];
			break;
		case ord("Z"):			// KEY CODE == 90
			_keyData = [spr_control_icons_small, 29];
			break;
		case vk_numpad0:		// KEY CODE == 96
			_keyData = [spr_control_icons_large, 26];
			break;
		case vk_numpad1:		// KEY CODE == 97
			_keyData = [spr_control_icons_large, 27];
			break;
		case vk_numpad2:		// KEY CODE == 98
			_keyData = [spr_control_icons_large, 28];
			break;
		case vk_numpad3:		// KEY CODE == 99
			_keyData = [spr_control_icons_large, 29];
			break;
		case vk_numpad4:		// KEY CODE == 100
			_keyData = [spr_control_icons_large, 30];
			break;
		case vk_numpad5:		// KEY CODE == 101
			_keyData = [spr_control_icons_large, 31];
			break;
		case vk_numpad6:		// KEY CODE == 102
			_keyData = [spr_control_icons_large, 32];
			break;
		case vk_numpad7:		// KEY CODE == 103
			_keyData = [spr_control_icons_large, 33];
			break;
		case vk_numpad8:		// KEY CODE == 104
			_keyData = [spr_control_icons_large, 34];
			break;
		case vk_numpad9:		// KEY CODE == 105
			_keyData = [spr_control_icons_large, 35];
			break;
		case vk_multiply:		// KEY CODE == 106
			_keyData = [spr_control_icons_small, 42];
			break;
		case vk_add:			// KEY CODE == 107
			_keyData = [spr_control_icons_small, 39];
			break;
		case vk_subtract:		// KEY CODE == 109
			_keyData = [spr_control_icons_small, 40];
			break;
		case vk_divide:			// KEY CODE == 111
			_keyData = [spr_control_icons_small, 32];
			break;
		case vk_f1:				// KEY CODE == 112
			_keyData = [spr_control_icons_large, 14];
			break;
		case vk_f2:				// KEY CODE == 113
			_keyData = [spr_control_icons_large, 15];
			break;
		case vk_f3:				// KEY CODE == 114
			_keyData = [spr_control_icons_large, 16];
			break;
		case vk_f4:				// KEY CODE == 115
			_keyData = [spr_control_icons_large, 17];
			break;
		case vk_f5:				// KEY CODE == 116
			_keyData = [spr_control_icons_large, 18];
			break;
		case vk_f6:				// KEY CODE == 117
			_keyData = [spr_control_icons_large, 19];
			break;
		case vk_f7:				// KEY CODE == 118
			_keyData = [spr_control_icons_large, 20];
			break;
		case vk_f8:				// KEY CODE == 119
			_keyData = [spr_control_icons_large, 21];
			break;
		case vk_f9:				// KEY CODE == 120
			_keyData = [spr_control_icons_large, 22];
			break;
		case vk_f10:			// KEY CODE == 121
			_keyData = [spr_control_icons_large, 23];
			break;
		case vk_f11:			// KEY CODE == 122
			_keyData = [spr_control_icons_large, 24];
			break;
		case vk_f12:			// KEY CODE == 123
			_keyData = [spr_control_icons_large, 25];
			break;
		case vk_lcontrol:		// KEY CODE == 162
			_keyData = [spr_control_icons_large, 6];
			break;
		case vk_rcontrol:		// KEY CODE == 163
			_keyData = [spr_control_icons_large, 37];
			break;
		case vk_lalt:			// KEY CODE == 164
			_keyData = [spr_control_icons_large, 3];
			break;
		case vk_ralt:			// KEY CODE == 165
			_keyData = [spr_control_icons_large, 36];
			break;
		case 186:				// KEY == COLON/SEMI-COLON
			_keyData = [spr_control_icons_small, 33];
			break;
		case 187:				// KEY == EQUAL
			_keyData = [spr_control_icons_small, 55];
			break;
		case 188:				// KEY == COMMA
			_keyData = [spr_control_icons_small, 30];
			break;
		case 189:				// KEY == UNDERSCORE
			_keyData = [spr_control_icons_small, 40];
			break;
		case 190:				// KEY == PERIOD
			_keyData = [spr_control_icons_small, 31];
			break;
		case 191:				// KEY == QUESTION MARK
			_keyData = [spr_control_icons_small, 41];
			break;
		case 192:				// KEY == TILDE
			_keyData = [spr_control_icons_small, 43];
			break;
		case 219:				// KEY == OPEN CURLY/SQUARE BRACKET
			_keyData = [spr_control_icons_small, 34];
			break;
		case 220:				// KEY == BACKSLASH
			_keyData = [spr_control_icons_small, 37];
			break;
		case 221:				// KEY == CLOSE CURLY/SQUARE BRACKET
			_keyData = [spr_control_icons_small, 35];
			break;
		case 222:				// KEY == SINGLE/DOUBLE QUOTATION
			_keyData = [spr_control_icons_small, 55];
			break;
	}

	return _keyData;
}
