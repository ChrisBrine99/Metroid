with(platformID) {instance_destroy_object(id);}

var _length = ds_list_size(colliderIDs);
for (var i = 0; i < _length; i++) {instance_destroy(colliderIDs[| i]);}
ds_list_destroy(colliderIDs);

entity_cleanup();