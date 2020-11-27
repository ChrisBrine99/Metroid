/// @description CHANGING BRIGHTNESS

var _delta = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
lightBrightness += (_delta * 0.01);