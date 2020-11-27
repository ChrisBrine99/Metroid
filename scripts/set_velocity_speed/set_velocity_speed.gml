/// @description Sets the entity's horizontal acceleration and the strength of gravity on them.
/// @param accel
/// @param gravity

function set_velocity_speed(_accel, _gravity){
	accel = max(0, _accel);
	grav = max(0, _gravity);
}