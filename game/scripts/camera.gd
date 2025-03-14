class_name Camera
extends Camera2D

@export var camera_zoom: float = 0.2
@export var camera_zoom_target: float = camera_zoom
@export var camera_zoom_min: float = 0.025
@export var camera_zoom_max: float = 1
@export var camera_zoom_step: float = 0.05
@export var camera_zoom_smooth: float = camera_zoom_step / 10

@export var camera_fov: float = 5
@export var camera_fov_target: float = camera_fov
@export var camera_fov_min: float = 1
@export var camera_fov_max: float = 40
@export var camera_fov_step: float = 1
@export var camera_fov_smooth: float = camera_fov_step / 5

var is_camera_dragging: bool = false
var old_mouse_pos: Vector2 = Vector2(0 ,0)

func _ready() -> void:
	update_camera_zoom()

func _process(_delta: float) -> void:
	if (camera_zoom < camera_zoom_target):
		camera_zoom += camera_zoom_smooth
		if (camera_zoom > camera_zoom_target):
			camera_zoom = camera_zoom_target
		update_camera_zoom()
			
	if (camera_zoom > camera_zoom_target):
		camera_zoom -= camera_zoom_smooth
		if (camera_zoom < camera_zoom_target):
			camera_zoom = camera_zoom_target
		update_camera_zoom()
	
	if (camera_fov < camera_fov_target):
		camera_fov += camera_fov_smooth
		if (camera_fov > camera_fov_target):
			camera_fov = camera_fov_target
		update_camera_zoom()
			
	if (camera_fov > camera_fov_target):
		camera_fov -= camera_fov_smooth
		if (camera_fov < camera_fov_target):
			camera_fov = camera_fov_target
		update_camera_zoom()
	
	if (is_camera_dragging):
		var new_mouse_pos: Vector2 = get_viewport().get_mouse_position()
		if (Global.use_fov_not_zoom):
			set_position(get_position() + (old_mouse_pos - new_mouse_pos) * camera_fov)
		else:
			set_position(get_position() + (old_mouse_pos - new_mouse_pos) * 1/camera_zoom)
		old_mouse_pos = new_mouse_pos
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom_in"):
		camera_zoom_target += camera_zoom_step
		if (camera_zoom_target > camera_zoom_max):
			camera_zoom_target = camera_zoom_max
		
		camera_fov_target -= camera_fov_step
		if (camera_fov_target < camera_fov_min):
			camera_fov_target = camera_fov_min
	
	if event.is_action_pressed("camera_zoom_out"):
		camera_zoom_target -= camera_zoom_step
		if (camera_zoom_target < camera_zoom_min):
			camera_zoom_target = camera_zoom_min
		
		camera_fov_target += camera_fov_step
		if (camera_fov_target > camera_fov_max):
			camera_fov_target = camera_fov_max
	
	if event.is_action_pressed("camera_drag"):
		Global.change_cursor_shape(Input.CURSOR_DRAG)
		is_camera_dragging = true
		old_mouse_pos = get_viewport().get_mouse_position()
	
	if event.is_action_released("camera_drag"):
		Global.change_cursor_shape(Input.CURSOR_ARROW)
		is_camera_dragging = false
	
	pass

func update_camera_zoom() -> void:
	if (Global.use_fov_not_zoom):
		set_zoom(Vector2(1/camera_fov, 1/camera_fov))
	else:
		set_zoom(Vector2(camera_zoom, camera_zoom))
	pass

func center_camera() -> void:
	set_position(Vector2(0, 0))
	pass
