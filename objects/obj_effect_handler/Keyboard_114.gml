/// @description CHANGING SATURATION

var _delta = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
lightSaturation += (_delta * 0.01);