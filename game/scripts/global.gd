extends Node

signal changed_cheat
signal changed_log_scale_map
signal changed_zoom_not_fov
signal changed_cursor_shape

var use_cheat: bool = false
var use_log_scale_map: bool = true
var use_zoom_not_fov: bool = true
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

func change_zoom_not_fov(value: bool) -> void:
	use_zoom_not_fov = value
	changed_zoom_not_fov.emit()
	pass

func change_cursor_shape(value: Input.CursorShape) -> void:
	cursor_shape = value
	Input.set_default_cursor_shape(value)
	changed_cursor_shape.emit()
	pass
