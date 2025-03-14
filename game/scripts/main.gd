class_name Main
extends Node2D

func _ready() -> void:
	Global.changed_log_scale_map.connect($SolarSystem.redraw_map)
	Global.changed_log_scale_map.connect($Camera.center_camera)
	Global.changed_fov_not_zoom.connect($Camera.update_camera_zoom)
	Global.changed_cheat.connect($SolarSystem.redraw_human_count)
	Global.changed_bgm_volume.connect($AudioManager.change_bgm_volume)
	Global.changed_sfx_volume.connect($AudioManager.change_sfx_volume)
	pass
