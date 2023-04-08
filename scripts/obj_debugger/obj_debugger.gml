#region Initializing any macros that are useful/related to obj_debugger
#endregion

#region Initializing any globals that are useful/related to obj_debugger
#endregion

#region The main object code for obj_debugger

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_debugger(_index) : base_struct(_index) constructor{
	console = instance_create_struct(obj_console);
	console.isActive = false;
	
	/// @description 
	end_step = function(){
		with(console) {end_step();}
	}
	
	/// @description 
	draw = function(){
	}
	
	/// @description 
	draw_gui = function(){
		/*shader_set_outline(font_gui_small, RGB_GRAY);
		var _camera = CAMERA.camera;
		var _cameraWidth = camera_get_view_width(_camera);
		var _cameraHeight = camera_get_view_height(_camera);
		
		draw_set_halign(fa_center);
		draw_text_outline(_cameraWidth - 75, 5, "--- Player Data ---", HEX_WHITE, RGB_GRAY, 1);
		
		draw_set_halign(fa_right);
		with(PLAYER){
			draw_text_outline(_cameraWidth - 5, 15,
				player_get_state_name(curState) + "\n" +
				player_get_state_name(lastState) + "\n\n" +
				"[" + string(x) + ", " + string(y) + "]\n" +
				string(hspd) + "\n" +
				string(vspd) + "\n" +
				string(hspdFraction) + "\n" +
				string(vspdFraction) + "\n" +
				string(get_hor_accel()) + "\n" +
				string(get_vert_accel()) + "\n" +
				string(get_max_hspd()) + "\n" +
				string(get_max_vspd()),
				HEX_WHITE, RGB_GRAY, 1
			);
		}
		
		draw_set_halign(fa_left);
		draw_text_outline(_cameraWidth - 155, 15, "State\nLast State", HEX_RED, RGB_DARK_RED, 1);
		draw_text_outline(_cameraWidth - 95, 15, "\n\n\nPosition\nHspd\nVspd\nHspdFraction\nVspdFraction\nAccel\nGravity\nMax Hspd\nMax Vspd", HEX_RED, RGB_DARK_RED, 1);
		
		draw_text_outline(5, 5, game_state_get_name(GAME_CURRENT_STATE), HEX_WHITE, RGB_GRAY, 1);
		
		with(CAMERA){
			draw_text_outline(65, 15, 
				"[" + string(camera_get_view_x(_camera)) + ", " + string(camera_get_view_y(_camera)) + "]\n" +
				"[" + string(x) + ", " + string(y) + "]\n" +
				string(IS_CAMERA_X_LOCKED) + string(IS_CAMERA_Y_LOCKED) + string(CAN_RESET_TARGET_X) + string(CAN_RESET_TARGET_Y) + string(IS_VIEW_BOUND_ENABLED), 
				HEX_WHITE, RGB_GRAY, 1
			);
		}
		draw_text_outline(5, 15, "View Pos:\nCamera Pos:\nFlags:", HEX_RED, RGB_DARK_RED, 1);
		
		shader_reset();*/
		
		with(console) {draw_gui();}
	}
}

#endregion

#region Global functions related to obj_debugger

/// @description 
/// @param {Function}	state
function player_get_state_name(_state){
	if (object_index != obj_player) {return;}
	
	switch(_state){
		default:					return "NO_STATE";
		case state_intro:			return "state_intro";
		case state_default:			return "state_default";
		case state_airbourne:		return "state_airbourne";
		case state_crouching:		return "state_crouching";
		case state_morphball:		return "state_morphball";
		case state_enter_morphball:	return "state_enter_morphball";
	}
}

#endregion