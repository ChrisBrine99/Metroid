// FOR DOORS WITH LOCKS ONLY -- Check if the flag tied to the door has already been set. If so, switch this door
// to a general door as it is now considered unlocked.
if (object_index == obj_general_door || !event_get_flag(flagID)) {return;}
instance_change(obj_general_door, true);