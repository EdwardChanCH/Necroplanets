class_name Main
extends Node2D

func _ready() -> void:
	Global.changed_log_scale_map.connect($SolarSystem.redraw_map)
	Global.changed_log_scale_map.connect($Camera.center_camera)
	Global.changed_zoom_not_fov.connect($Camera.update_camera_zoom)
	pass
