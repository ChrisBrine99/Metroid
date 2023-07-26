with(platformID) {instance_destroy_object(id);}

var _length = ds_list_size(immunityAreas);
for (var i = 0; i < _length; i++) {instance_destroy(immunityAreas[| i]);}
ds_list_destroy(immunityAreas);

ds_list_destroy(weaknesses);
entity_cleanup();