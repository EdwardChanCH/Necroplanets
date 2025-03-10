class_name Planet
extends Node2D

const AU: float = 1000
const spacing: float = 100

@export var planet_id: int = 0
@export var planet_name: String = "PLANET"
@export var radius_au: float = 0
@export var angle_deg: float = 0
@export var planet_progress: float = 0
@export var alien_count: int = 0
@export var human_count: int = 0

func logx(value: float, base: float) -> float:
	base = absf(base)
	if (value < 0):
		return -log(-value) / log(base)
	else:
		return log(value) / log(base)

func _ready():
	update_planet_position()
	update_planet_label()
	update_alien_count(alien_count, true)
	update_human_count(human_count, true)
	pass

func set_planet_name(planet: String):
	planet_name = planet.to_upper()
	update_planet_label()
	pass

func set_planet_progress(progress: float):
	planet_progress = progress
	update_planet_label()
	pass

func update_planet_position():
	var r: float = (logx(radius_au, 10) + 1) * AU
	var rad: float = angle_deg / 360 * 2 * PI
	self.set_position(Vector2(r * cos(rad), -r * sin(rad)))
	pass

func update_planet_label():
	$PlanetLabel.set_text(planet_name + " (" + str(floori(planet_progress)) + "%)")
	pass

func update_alien_count(amount: int, overwrite: bool = false):
	if (overwrite):
		alien_count = amount
	else:
		alien_count += amount
	
	$AlienLabel.set_text(str(alien_count))
	pass

func update_human_count(amount: int, overwrite: bool = false):
	if (overwrite):
		human_count = amount
	else:
		human_count += amount
	
	$HumanLabel.set_text(str(human_count))
	pass
