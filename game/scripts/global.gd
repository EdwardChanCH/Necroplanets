extends Node

signal changed_cheat
signal changed_log_scale_map
signal changed_fov_not_zoom
signal changed_cursor_shape
signal changed_bgm_volume
signal changed_sfx_volume

var use_cheat: bool = false
var use_log_scale_map: bool = true
var use_fov_not_zoom: bool = true
var bgm_value: float = 0.5
var sfx_value: float = 0.5
var cursor_shape: Input.CursorShape = Input.CURSOR_ARROW

var alien_accel: float = 1
var human_accel: float = 1

func change_cheat(value: bool) -> void:
	use_cheat = value
	changed_cheat.emit()
	pass

func change_log_scale_map(value: bool) -> void:
	use_log_scale_map = value
	changed_log_scale_map.emit()
	pass

func change_fov_not_zoom(value: bool) -> void:
	use_fov_not_zoom = value
	changed_fov_not_zoom.emit()
	pass

func change_cursor_shape(value: Input.CursorShape) -> void:
	cursor_shape = value
	Input.set_default_cursor_shape(value)
	changed_cursor_shape.emit()
	pass

func change_bgm_value(value: float) -> void:
	bgm_value = value
	changed_bgm_volume.emit()
	pass

func change_sfx_value(value: float) -> void:
	sfx_value = value
	changed_sfx_volume.emit()
	pass
