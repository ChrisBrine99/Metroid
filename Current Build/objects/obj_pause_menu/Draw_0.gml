/// @description Insert description here
// You can write your code in this editor

var alpha;
alpha = self.alpha * backAlpha;
if (nextMenu == obj_options_menu)
	alpha = backAlpha;
draw_rect(alpha, self.alpha, rectCol, c_black, true, global.camX, global.camY, global.camWidth, global.camHeight);

// Call the parent's draw event
event_inherited();