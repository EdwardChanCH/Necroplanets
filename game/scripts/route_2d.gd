class_name Route2D
extends Node2D

const line_dotted: GradientTexture1D = preload("res://textures/line_dotted.tres")
const line_ghost_alien: GradientTexture1D = preload("res://textures/line_ghost_alien.tres")
const line_ghost_alien_curve: Curve = preload("res://textures/line_ghost_alien_curve.tres")

@onready var path: Path2D = $Path
@onready var line: Line2D = $Line

var planetA: Planet
var planetB: Planet
var routeID: int = 0
var length: float = 0

func set_route(start: Planet, end: Planet) -> void:
	planetA = start
	planetB = end
	
	path.set_curve(Curve2D.new()) # Curve2D in a scene are shared by default
	path.get_curve().add_point(planetA.get_position())
	path.get_curve().add_point(planetB.get_position())
	line.set_points(path.curve.get_baked_points())
	
	length = path.curve.get_baked_length()
	pass
