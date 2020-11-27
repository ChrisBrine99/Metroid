/// @description Cleaning Up surfaces/ds_lists/etc.

// De-allocating ds_lists
ds_list_destroy(option);
ds_list_destroy(optionActive);
ds_list_destroy(optionPosOffset);
ds_list_destroy(info);
ds_list_destroy(controlsPos);
ds_list_destroy(controlsAnchor);
ds_list_destroy(controlsInfo);