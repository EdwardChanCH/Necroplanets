class_name Planet
extends Node2D

signal planet_selected(planet_id: int)
signal planet_deselected(planet_id: int)

const icon_planet: CompressedTexture2D = preload("res://textures/icon_planet.tres")
const icon_necroplanet: CompressedTexture2D = preload("res://textures/icon_necroplanet.tres")

enum STATUS {
	EMPTY      = 0, #  no alien,  no human, intact
	ABANDONED  = 1, #  no alien,  no human, fractured
	PRODUCING  = 2, #  no alien, has human, intact
	BLOCKING   = 3, #  no alien, has human, fractured
	BOMBARDING = 4, # has alien,  no human, intact
	MINING     = 5, # has alien,  no human, fractured
	ATTACKING  = 6, # has alien, has human, intact
	DEFENDING  = 7, # has alien, has human, fractured
	ERROR      = -1 # error
	}

const AU: float = 1000
const spacing: float = 100
const base_color: Color = Color(1, 1, 1, 1)
const hover_color: Color = Color(0, 1, 0, 1)
const selected_color: Color = Color(0, 0.75, 0, 1)

@export var planet_id: int = 0
@export var planet_name: String = "PLANET"
@export var radius_au: float = 0
@export var angle_deg: float = 0
@export var planet_progress: float = 0
@export var alien_count: int = 0
@export var human_count: int = 0
@export var fractured: bool = false

var status: STATUS = STATUS.EMPTY
var neighbours: Dictionary[int, Route2D] = {}
var alien_incoming: int = 0
var human_incoming: int = 0

func logx(value: float, base: float) -> float:
	base = absf(base)
	if (value < 0):
		return -log(-value) / log(base)
	else:
		return log(value) / log(base)

func _ready() -> void:
	set_planet_id(planet_id)
	set_planet_name(planet_name)
	set_planet_position(radius_au, angle_deg)
	set_planet_progress(planet_progress)
	set_alien_count(alien_count)
	set_human_count(human_count)
	pass

func set_planet_id(id: int) -> void:
	planet_id = id
	pass

func set_planet_name(planet: String) -> void:
	planet_name = planet.to_upper()
	$PlanetLabel.set_text(planet_name + " (" + str(floori(planet_progress)) + "%)")
	pass

func set_planet_position(radius: float, angle: float, relative: bool = false) -> void:
	var r: float
	var rad: float
	
	if (relative):
		radius_au += radius
		angle_deg += angle
	else:
		radius_au = radius
		angle_deg = angle
	
	if (Global.use_log_scale_map):
		r = (logx(radius_au, 10) + 1) * AU
	else:
		r = radius_au * AU
	rad = deg_to_rad(angle_deg)
	
	self.set_position(Vector2(r * cos(rad), -r * sin(rad)))
	pass

func redraw_planet_position() -> void:
	set_planet_position(0, 0, true)
	pass

func set_planet_progress(amount: float, relative: bool = false) -> void:
	if (relative):
		planet_progress += amount
	else:
		planet_progress = amount
	
	if (planet_progress > 100.0):
		planet_progress = 100.0
	
	if (planet_progress < 100.0):
		fractured = false
		$PlanetIcon.set_texture(icon_planet)
	else:
		fractured = true
		$PlanetIcon.set_texture(icon_necroplanet)
	
	$ProgressBar.set_value(planet_progress)
	pass

func set_alien_count(amount: int, relative: bool = false) -> void:
	if (relative):
		alien_count += amount
	else:
		alien_count = amount
	
	$AlienLabel.set_text(str(alien_count))
	pass

func set_human_count(amount: int, relative: bool = false) -> void:
	if (relative):
		human_count += amount
	else:
		human_count = amount
		
	$HumanLabel.set_text(str(human_count))
	pass

func set_alien_incoming(amount: int, relative: bool = false) -> void:
	if (relative):
		alien_incoming += amount
	else:
		alien_incoming = amount
	pass

func set_human_incoming(amount: int, relative: bool = false) -> void:
	if (relative):
		human_incoming += amount
	else:
		human_incoming = amount
	pass

func update_status() -> void:
	if (alien_count == 0 and human_count == 0 and !fractured):
		status = STATUS.EMPTY
	elif (alien_count == 0 and human_count == 0 and fractured):
		status = STATUS.ABANDONED
	elif (alien_count == 0 and human_count > 0 and !fractured):
		status = STATUS.PRODUCING
	elif (alien_count == 0 and human_count > 0 and fractured):
		status = STATUS.BLOCKING
	elif (alien_count > 0 and human_count == 0 and !fractured):
		status = STATUS.BOMBARDING
	elif (alien_count > 0 and human_count == 0 and fractured):
		status = STATUS.MINING
	elif (alien_count > 0 and human_count > 0 and !fractured):
		status = STATUS.ATTACKING
	elif (alien_count > 0 and human_count > 0 and fractured):
		status = STATUS.DEFENDING
	else:
		status = STATUS.ERROR
	pass

func set_button(toggled_on: bool) -> void:
	$Button.set_pressed_no_signal(toggled_on)
	if ($Button.is_pressed()):
		$PlanetIcon.set_modulate(selected_color)
	else:
		$PlanetIcon.set_modulate(base_color)
	pass

func _on_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		planet_selected.emit(planet_id)
	else:
		planet_deselected.emit(planet_id)
	pass

func _on_button_mouse_entered() -> void:
	$PlanetIcon.set_modulate(hover_color)
	pass

func _on_button_mouse_exited() -> void:
	if ($Button.is_pressed()):
		$PlanetIcon.set_modulate(selected_color)
	else:
		$PlanetIcon.set_modulate(base_color)
	pass
