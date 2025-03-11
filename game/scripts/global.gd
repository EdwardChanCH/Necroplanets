extends Node

signal changed_log_scale_map(value: bool)
signal changed_zoom_not_fov(value: bool)

var use_log_scale_map: bool = true
var use_zoom_not_fov: bool = true

func change_log_scale_map(value: bool) -> void:
	if (value == use_log_scale_map):
		return
	
	changed_log_scale_map.emit(value)
	pass

func change_zoom_not_fov(value: bool) -> void:
	if (value == use_zoom_not_fov):
		return
	
	changed_zoom_not_fov.emit(value)
	pass
