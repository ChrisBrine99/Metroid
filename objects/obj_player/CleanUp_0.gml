instance_destroy_struct(armCannon);

var _length = ds_list_size(jumpEffectID);
for (var i = 0; i < _length; i++) {instance_destroy_struct(jumpEffectID[| i]);}
ds_list_destroy(jumpEffectID);

delete liquidData;
entity_cleanup();