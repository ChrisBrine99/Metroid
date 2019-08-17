/// @description Draw a string value depending on the given key's unicode value.
/// @param posX
/// @param posY
/// @param key
/// @param textCol
/// @param outlineCol

var xPos, yPos, key, col, oCol, str;
xPos = argument0;	// The X position on the screen to draw to
yPos = argument1;	// The Y position on the screen to draw to
key = argument2;	// The keyboard key to find the string value for
col = argument3;	// The color of the text inside the lines
oCol = argument4;	// The text's outline color
str = "";			// The resulting keyboard key's string value

switch(key){
	case 8:
		str = "Backspace";
		break;
	case 9:
		str = "Tab";
		break;
	case 13:
		str = "Enter";
		break;
	case 16:
		str = "Shift";
		break;
	case 19:
		str = "Pause";
		break;
	case 20:
		str = "Caps Lck";
		break;
	case 27:
		str = "Escape";
		break;
	case 32:
		str = "Spacebar";
		break;
	case 33:
		str = "Pg Up";
		break;
	case 34:
		str = "Pg Down";
		break;
	case 35:
		str = "End";
		break;
	case 36:
		str = "Home";
		break;
	case 37:
		str = "L. Arrow";
		break;
	case 38:
		str = "U. Arrow";
		break;
	case 39:
		str = "R. Arrow";
		break;
	case 40:
		str = "D. Arrow";
		break;
	case 46:
		str = "Delete";
		break;
	case 91:
		str = "Windows";
		break;
	case 96:
		str = "Numpad 0";
		break;
	case 97:
		str = "Numpad 1";
		break;
	case 98:
		str = "Numpad 2";
		break;
	case 99:
		str = "Numpad 3";
		break;
	case 100:
		str = "Numpad 4";
		break;
	case 101:
		str = "Numpad 5";
		break;
	case 102:
		str = "Numpad 6";
		break;
	case 103:
		str = "Numpad 7";
		break;
	case 104:
		str = "Numpad 8";
		break;
	case 105:
		str = "Numpad 9";
		break;
	case 106:
		str = "*";
		break;
	case 107:
		str = "+";
		break;
	case 109:
		str = "-";
		break;
	case 111:
		str = "/";
		break;
	case 112:
		str = "F1";
		break;
	case 113:
		str = "F2";
		break;
	case 114:
		str = "F3";
		break;
	case 115:
		str = "F4";
		break;
	case 116:
		str = "F5";
		break;
	case 117:
		str = "F6";
		break;
	case 118:
		str = "F7";
		break;
	case 119:
		str = "F8";
		break;
	case 120:
		str = "F9";
		break;
	case 121:
		str = "F10";
		break;
	case 122:
		str = "F11";
		break;
	case 123:
		str = "F12";
		break;
	case 144:
		str = "Num Lock";
		break;
	case 160:
		str = "L. Shift";
		break;
	case 161:
		str = "R. Shift";
		break;
	case 162:
		str = "L. Ctrl";
		break;
	case 163:
		str = "R. Ctrl";
		break;
	case 164:
		str = "L. Alt";
		break;
	case 165:
		str = "R. Alt";
		break;
	case 186:
		str = ";";
		break;
	case 187:
		str = "=";
		break;
	case 188:
		str = ",";
		break;
	case 189:
		str = "_";
		break;
	case 190:
		str = ".";
		break;
	case 191:
		str = "?";
		break;
	case 192:
		str = "~";
		break;
	case 219:
		str = "[";
		break;
	case 220:
		str = "\\";
		break;
	case 221:
		str = "]";
		break;
	case 222:
		str = "'";
		break;
	case 226:
		str = "\\";
		break;
	default:
		str = chr(key);
		break;
}
// Draw the resulting string to the screen
draw_text_outline(xPos, yPos, str, col, oCol);