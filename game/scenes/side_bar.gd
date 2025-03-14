class_name SideBar
extends HBoxContainer

@export var camera: Camera
@export var scroll_box: ScrollContainer

var current_menu_id: int = -1

func _ready() -> void:
	open_side_menu(0)
	pass

func get_side_menu(_id: int) -> Node:
	if (_id == 0):
		return $SidePanel/MenuBox
	elif (_id == 1):
		return $SidePanel/OptionsBox
	elif (_id == 2):
		return $SidePanel/NewsBox
	elif (_id == 3):
		return $SidePanel/GuideBox
	elif (_id == 4):
		return $SidePanel/CreditsBox
	elif (_id == 5):
		return $SidePanel/ExitBox
	else:
		return $SidePanel/MenuBox

func open_side_menu(_id: int = -1) -> void:
	if (_id == current_menu_id):
		$SidePanel.set_visible(!$SidePanel.visible)
		if ($SidePanel.visible):
			scroll_box.set_custom_minimum_size(Vector2(520, 0))
		else:
			scroll_box.set_custom_minimum_size(Vector2(120, 0))
		return
	elif (_id != -1):
		get_side_menu(current_menu_id).set_visible(false)
		get_side_menu(_id).set_visible(true)
		current_menu_id = _id
		$SidePanel.set_visible(true)
		scroll_box.set_custom_minimum_size(Vector2(520, 0))
	pass

func close_side_menu() -> void:
	$SidePanel.set_visible(false)
	scroll_box.set_custom_minimum_size(Vector2(120, 0))
	pass

func _on_menu_button_pressed() -> void:
	open_side_menu(0)
	pass

func _on_settings_button_pressed() -> void:
	open_side_menu(1)
	pass

func _on_news_button_pressed() -> void:
	open_side_menu(2)
	pass

func _on_guide_button_pressed() -> void:
	open_side_menu(3)
	pass

func _on_credits_button_pressed() -> void:
	open_side_menu(4)
	pass

func _on_exit_button_pressed() -> void:
	open_side_menu(5)
	pass

func _on_start_button_pressed() -> void:
	# TODO
	pass

func _on_exit_no_button_pressed() -> void:
	close_side_menu()
	pass

func _on_exit_yes_button_pressed() -> void:
	get_tree().quit()
	pass

func _on_use_cheat_check_box_toggled(toggled_on: bool) -> void:
	Global.change_cheat(toggled_on)
	pass

func _on_log_scale_check_box_toggled(toggled_on: bool) -> void:
	Global.change_log_scale_map(toggled_on)
	pass

func _on_fov_zoom_check_box_toggled(toggled_on: bool) -> void:
	Global.change_zoom_not_fov(toggled_on)
	pass

func _on_center_camera_button_pressed() -> void:
	camera.center_camera()
	pass
