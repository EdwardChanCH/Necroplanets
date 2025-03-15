class_name Convoy2D
extends PathFollow2D

signal has_takenoff
signal has_terminated

@export var icon_alien: Texture2D
@export var icon_human: Texture2D

var route: Route2D
var direction: bool # false if backwards
var ship_count: int
var is_alien: bool

var start: Planet
var end: Planet
var accel: float
var duration: float
var time_taken: float
var completion: float

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	$Sprite.hide()
	pass

func _process(delta: float) -> void:
	time_taken += delta * (1 / Global.game_clock_period)
	completion = time_taken / duration
	
	if (!direction):
		completion = 1 - completion
	
	if (completion < 0 or completion > 1):
		landing()
	else:
		set_progress_ratio(completion)
	pass

func set_convoy(_route: Route2D, _direction: bool, _ship_count: int, _is_alien: bool, _accel: float) -> void:
	route = _route
	direction = _direction
	ship_count = _ship_count
	is_alien = _is_alien
	accel = _accel # in AU
	duration = sqrt(4 * route.length / accel) # t = 2 * sqrt(2 * x/2 / a)
	time_taken = 0
	
	if (direction):
		start = route.planetA
		end = route.planetB
		completion = 0
	else:
		start = route.planetB
		end = route.planetA
		completion = 1
	
	$ShipCount.set_text(str(ship_count))
	if (_is_alien):
		$ShipCount.set_position(Vector2(-200, 50))
	else:
		$ShipCount.set_position(Vector2(-200, -150))
	route.path.add_child(self)
	pass

func takeoff() -> void:
	if (is_alien):
		$Sprite.set_texture(icon_alien)
	else:
		$Sprite.set_texture(icon_human)
	$Sprite.show()
	
	if (is_alien):
		start.set_alien_count(-ship_count, true)
		end.set_alien_incoming(+ship_count, true)
	else:
		start.set_human_count(-ship_count, true)
		end.set_human_incoming(+ship_count, true)
	
	self.process_mode = Node.PROCESS_MODE_INHERIT
	has_takenoff.emit()
	pass

func landing() -> void:
	if (is_alien):
		end.set_alien_count(ship_count, true)
		end.set_alien_incoming(-ship_count, true)
	else:
		end.set_human_count(ship_count, true)
		end.set_human_incoming(-ship_count, true)
	terminate()
	pass

func terminate() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	has_terminated.emit()
	self.queue_free()
	pass
