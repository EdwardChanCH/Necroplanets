class_name Planet
extends Node2D

signal planet_selected(planet_id: int)
signal planet_deselected(planet_id: int)
signal alien_count_changed

const icon_planet: CompressedTexture2D = preload("res://textures/icon_planet.tres")
const icon_necroplanet: CompressedTexture2D = preload("res://textures/icon_necroplanet.tres")

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
@export var alien_tier: int = 0
@export var human_tier: int = 0
@export var fractured: bool = false

var neighbours: Dictionary[int, Route2D] = {}
var alien_incoming: int = 0
var human_incoming: int = 0
var guessed_human_count: int = -1

func logx(value: float, base: float) -> float:
	base = absf(base)
	if (value < 0):
		return -log(-value) / log(base)
	elif (value == 0):
		return 0
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

func _on_pulsed_game_clock() -> void:
	# gameplay logic
	var alien_death: int = 0
	var human_death: int = 0
	
	if (alien_count > 0 and human_count > 0):
		# has alien and humam, ship-to-ship combat
		alien_death = max(1, floorf(0.1 * human_count))
		human_death = max(1, floorf(0.1 * alien_count))
		set_alien_count(-alien_death, true) # decrement ships
		set_human_count(-human_death, true) # decrement ships
		pass
	else:
		if (alien_count > 0):
			# has alien only
			if (human_tier > 0):
				set_human_tier(-1, true) # attack factory
			else:
				set_planet_progress(logx(alien_count, 10) + 1, true) # attack planet
			pass
		
		if (human_count > 0):
			# has human only
			if (alien_tier > 0):
				set_alien_tier(-1, true) # attack factory
			pass
		
		if (human_count <= 0 and fractured and alien_tier > 0):
			# fractured planet, has factory, not attacked
			set_alien_count(alien_tier, true) # produce ships
			pass
		
		if (alien_count <= 0 and !fractured and human_tier > 0):
			# intact planet, has factory, not attacked
			set_human_count(human_tier, true) # produce ships
			pass
	pass

func set_planet_id(id: int) -> void:
	planet_id = id
	pass

func set_planet_name(planet: String) -> void:
	planet_name = planet.to_upper()
	redraw_planet_info()
	pass

func redraw_planet_info() -> void:
	if (alien_tier <= 0):
		$PlanetInfo.set_text(planet_name + " (" + str(floori(planet_progress)) + "%)")
	else:
		$PlanetInfo.set_text(planet_name + " (lv." + str(alien_tier) + ")")
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
	redraw_planet_info()
	pass

func set_alien_count(amount: int, relative: bool = false) -> void:
	if (relative):
		alien_count += amount
	else:
		alien_count = amount
	
	alien_count = max(0, alien_count)
	
	redraw_alien_count()
	redraw_human_count() # Reveal human count if alien count > 0
	
	alien_count_changed.emit()
	pass

func set_human_count(amount: int, relative: bool = false) -> void:
	if (relative):
		human_count += amount
	else:
		human_count = amount
	
	human_count = max(0, human_count)
	
	redraw_human_count()
	pass

func set_alien_tier(tier: int, relative: bool = false) -> void:
	if (relative):
		alien_tier += tier
	else:
		alien_tier = tier
	
	redraw_planet_info()
	pass

func set_human_tier(tier: int, relative: bool = false) -> void:
	if (relative):
		human_tier += tier
	else:
		human_tier = tier
	pass

func redraw_alien_count() -> void:
	$AlienCount.set_text(str(alien_count))
	pass

func redraw_human_count() -> void:
	if (Global.use_cheat):
		$HumanCount.set_text(str(human_count))
	elif (alien_count > 0):
		$HumanCount.set_text(str(human_count))
		guessed_human_count = human_count
	elif (guessed_human_count >= 0):
		$HumanCount.set_text(str(guessed_human_count) + "?")
	else:
		$HumanCount.set_text("??")
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
