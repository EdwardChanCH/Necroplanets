class_name Camera
extends Camera2D

@export var camera_zoom: float = 0.2
@export var camera_zoom_target: float = 0.2
@export var camera_zoom_min: float = 0.2
@export var camera_zoom_max: float = 1
@export var camera_zoom_step: float = 0.05
@export var camera_zoom_smooth: float = 0.005

var is_camera_dragging: bool = false
var old_mouse_pos: Vector2 = Vector2(0 ,0)

func _input(event: InputEvent):
	if event.is_action_pressed("camera_zoom_in"):
		camera_zoom_target += camera_zoom_step
		if (camera_zoom_target > camera_zoom_max):
			camera_zoom_target = camera_zoom_max
	
	if event.is_action_pressed("camera_zoom_out"):
		camera_zoom_target -= camera_zoom_step
		if (camera_zoom_target < camera_zoom_min):
			camera_zoom_target = camera_zoom_min
	
	if event.is_action_pressed("camera_drag"):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		is_camera_dragging = true
		old_mouse_pos = get_viewport().get_mouse_position()
	
	if event.is_action_released("camera_drag"):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		is_camera_dragging = false
	
	pass

func _ready():
	set_zoom(Vector2(camera_zoom, camera_zoom))

func _process(_delta: float):
	if (camera_zoom < camera_zoom_target):
		camera_zoom += camera_zoom_smooth
		if (camera_zoom > camera_zoom_target):
			camera_zoom = camera_zoom_target
		set_zoom(Vector2(camera_zoom, camera_zoom))
			
	if (camera_zoom > camera_zoom_target):
		camera_zoom -= camera_zoom_smooth
		if (camera_zoom < camera_zoom_target):
			camera_zoom = camera_zoom_target
		set_zoom(Vector2(camera_zoom, camera_zoom))
	
	if (is_camera_dragging):
		var new_mouse_pos: Vector2 = get_viewport().get_mouse_position()
		set_position(get_position() + (old_mouse_pos - new_mouse_pos) * 1/camera_zoom)
		old_mouse_pos = new_mouse_pos
	
	pass
