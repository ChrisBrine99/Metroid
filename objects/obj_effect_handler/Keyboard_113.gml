/// @description CHANGING CONTRAST

var _delta = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
lightContrast += (_delta * 0.01);