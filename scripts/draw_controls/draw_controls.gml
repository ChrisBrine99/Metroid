/// @description Draws an image to the screen that tells the player what keyboard key they need to use to 
/// complete a certain action in the game. The script can draw the sprite to with a right, center, or
/// leftward orientation.
/// @param xPos
/// @param yPos
/// @param key
/// @param orientation

var xPos, yPos, key, orientation, sprite, index;
xPos = argument0;
yPos = argument1;
key = argument2;
orientation = argument3;	// 0 = origin is to the left, 1 = origin is centered, 2 = origin is to the right
sprite = spr_small_gui_controls;
index = 0;

switch(key){
	case 8: // Backspace
		sprite = spr_large_gui_controls;
		index = 1;
		break;
	case 9: // Tab Key
		sprite = spr_large_gui_controls;
		index = 13;
		break;
	case 13: // Enter Key
		index = 36;
		break;
	case 16: // Shift Key
		sprite = spr_large_gui_controls;
		index = 5;
		break;
	case 19: // Pause Key
		index = 54;
		break;
	case 20: // Caps Lock Key
		sprite = spr_large_gui_controls;
		index = 4;
		break
	case 27: // Escape Key
		sprite = spr_large_gui_controls;
		index = 2;
		break;
	case 32: // Space Key
		sprite = spr_large_gui_controls;
		index = 0;
		break;
	case 33: // Page Up Key
		sprite = spr_large_gui_controls;
		index = 11;
		break;
	case 34: // Page Down Key
		sprite = spr_large_gui_controls;
		index = 12;
		break;
	case 35: // End Key
		sprite = spr_large_gui_controls;
		index = 10;
		break;
	case 36: // Home Key
		sprite = spr_large_gui_controls;
		index = 9;
		break;
	case 37: // Left Arrow Key
		index = 2;
		break;
	case 38: // Up Arrow Key
		index = 0;
		break;
	case 39: // Right Arrow Key
		index = 3;
		break;
	case 40: // Down Arrow Key
		index = 1;
		break;
	case 45: // Insert Key
		sprite = spr_large_gui_controls;
		index = 7;
		break;
	case 46: // Delete Key
		sprite = spr_large_gui_controls;
		index = 8;
		break;
	case 48: // Number Row 0
		index = 53;
		break;
	case 49: // Number Row 1
		index = 44;
		break;
	case 50: // Number Row 2
		index = 45;
		break;
	case 51: // Number Row 3
		index = 46;
		break;
	case 52: // Number Row 4
		index = 47;
		break;
	case 53: // Number Row 5
		index = 48;
		break;
	case 54: // Number Row 6
		index = 49;
		break;
	case 55: // Number Row 7
		index = 50;
		break;
	case 56: // Number Row 8
		index = 51;
		break;
	case 57: // Number Row 9
		index = 52;
		break;
	case 65: // "A"
		index = 4;
		break;
	case 66: // "B"
		index = 5;
		break;
	case 67: // "C"
		index = 6;
		break;
	case 68: // "D"
		index = 7;
		break;
	case 69: // "E"
		index = 8;
		break;
	case 70: // "F"
		index = 9;
		break;
	case 71: // "G"
		index = 10;
		break;
	case 72: // "H"
		index = 11;
		break;
	case 73: // "I"
		index = 12;
		break;
	case 74: // "J"
		index = 13;
		break;
	case 75: // "K"
		index = 14;
		break;
	case 76: // "L"
		index = 15;
		break;
	case 77: // "M"
		index = 16;
		break;
	case 78: // "N"
		index = 17;
		break;
	case 79: // "O"
		index = 18;
		break;
	case 80: // "P"
		index = 19;
		break;
	case 81: // "Q"
		index = 20;
		break;
	case 82: // "R"
		index = 21;
		break;
	case 83: // "S"
		index = 22;
		break;
	case 84: // "T"
		index = 23;
		break;
	case 85: // "U"
		index = 24;
		break;
	case 86: // "V"
		index = 25;
		break;
	case 87: // "W"
		index = 26;
		break;
	case 88: // "X"
		index = 27;
		break;
	case 89: // "Y"
		index = 28;
		break;
	case 90: // "Z"
		index = 29;
		break;
	case 96: // Numpad 0
		sprite = spr_large_gui_controls;
		index = 26;
		break;
	case 97: // Numpad 1
		sprite = spr_large_gui_controls;
		index = 27;
		break;
	case 98: // Numpad 2
		sprite = spr_large_gui_controls;
		index = 28;
		break;
	case 99: // Numpad 3
		sprite = spr_large_gui_controls;
		index = 29;
		break;
	case 100: // Numpad 4
		sprite = spr_large_gui_controls;
		index = 30;
		break;
	case 101: // Numpad 5
		sprite = spr_large_gui_controls;
		index = 31;
		break;
	case 102: // Numpad 6
		sprite = spr_large_gui_controls;
		index = 32;
		break;
	case 103: // Numpad 7
		sprite = spr_large_gui_controls;
		index = 33;
		break;
	case 104: // Numpad 8
		sprite = spr_large_gui_controls;
		index = 34;
		break;
	case 105: // Numpad 9
		sprite = spr_large_gui_controls;
		index = 35;
		break;
	case 106: // "*"
		index = 42;
		break;
	case 107: // "+"
		index = 39;
		break;
	case 109: // "-"
		index = 40;
		break;
	case 111: // "/"
		index = 32;
		break;
	case 112: // F1 Key
		sprite = spr_large_gui_controls;
		index = 14;
		break;
	case 113: // F2 Key
		sprite = spr_large_gui_controls;
		index = 15;
		break;
	case 114: // F3 Key
		sprite = spr_large_gui_controls;
		index = 16;
		break;
	case 115: // F4 Key
		sprite = spr_large_gui_controls;
		index = 17;
		break;
	case 116: // F5 Key
		sprite = spr_large_gui_controls;
		index = 18;
		break;
	case 117: // F6 Key
		sprite = spr_large_gui_controls;
		index = 19;
		break;
	case 118: // F7 Key
		sprite = spr_large_gui_controls;
		index = 20;
		break;
	case 119: // F8 Key
		sprite = spr_large_gui_controls;
		index = 21;
		break;
	case 120: // F9 Key
		sprite = spr_large_gui_controls;
		index = 22;
		break;
	case 121: // F10 Key
		sprite = spr_large_gui_controls;
		index = 23;
		break;
	case 122: // F11 Key
		sprite = spr_large_gui_controls;
		index = 24;
		break;
	case 123: // F12 Key
		sprite = spr_large_gui_controls;
		index = 25;
		break;
	case 162: // Left-side Control
	case 163: // Right-side Control
		sprite = spr_large_gui_controls;
		index = 6;
		break;
	case 164: // Left-side Alt
	case 165: // Right-side Alt
		sprite = spr_large_gui_controls;
		index = 3;
		break;
	case 186: // ";"
		index = 33;
		break;
	case 187: // "="
		index = 55;
		break;
	case 188: // ","
		index = 30;
		break;
	case 189: // "_"
		index = 40;
		break;
	case 190: // "."
		index = 31;
		break;
	case 191: // "?"
		index = 41;
		break;
	case 192: // "~"
		index = 43;
		break;
	case 219: // "["
		index = 34;
		break;
	case 220: // "\"
		index = 37;
		break;
	case 221: // "]"
		index = 35;
		break;
	case 222: // "'"
		index = 0;
		break;
	case 226: // "\"
		index = 37;
		break;
}
// Draw the sprite to the screen
if (orientation == 0) {draw_sprite(sprite, index, xPos, yPos);}
else if (orientation == 1) {draw_sprite(sprite, index, xPos - (sprite_get_width(sprite) / 2), yPos);}
else {draw_sprite(sprite, index, xPos - sprite_get_width(sprite), yPos);}

// Return the sprite so the size can be used in drawing various things
return sprite;