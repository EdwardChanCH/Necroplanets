extends Node

signal changed_cheat
signal changed_log_scale_map
signal changed_fov_not_zoom
signal changed_cursor_shape
signal changed_bgm_volume
signal changed_sfx_volume
signal changed_game_clock_period
signal pulsed_game_clock
signal deselectd_ui

var has_cheated: bool = false
var use_cheat: bool = false
var use_log_scale_map: bool = true
var use_fov_not_zoom: bool = true
var bgm_value: float = 0.5
var sfx_value: float = 0.5
var cursor_shape: Input.CursorShape = Input.CURSOR_ARROW
var game_clock_period: float = 1 # second(s)
var _game_clock_sum: float = 0

var alien_accel: float = 1
var human_accel: float = 1

func _process(_delta: float) -> void:
	if (game_clock_period < 0.05):
		pulsed_game_clock.emit()
	else:
		_game_clock_sum += _delta
		if (_game_clock_sum > game_clock_period):
			_game_clock_sum = fmod(_game_clock_sum, game_clock_period)
			pulsed_game_clock.emit()
	pass

func change_cheat(value: bool) -> void:
	has_cheated = true
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

func change_game_clock_period(value: float) -> void:
	game_clock_period = value
	changed_game_clock_period.emit()
	pass

func deselect_ui() -> void:
	deselectd_ui.emit()
	pass
