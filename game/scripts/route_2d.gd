class_name Route2D
extends Node2D

const line_dotted: GradientTexture1D = preload("res://textures/line_dotted.tres")
const line_ghost_alien: GradientTexture1D = preload("res://textures/line_ghost_alien.tres")
const line_ghost_alien_curve: Curve = preload("res://textures/line_ghost_alien_curve.tres")

@export var path: Path2D
@export var line: Line2D

var planetA: Planet
var planetB: Planet
var routeID: int = 0
var length: float = 0

func cosine_law(pA: Planet, pB: Planet) -> float:
	var a: float = pA.radius_au
	var b: float = pB.radius_au
	var deg: float = abs(pA.angle_deg - pB.angle_deg)
	
	return sqrt(a*a + b*b - 2*a*b*cos(deg_to_rad(deg)))

func set_route(start: Planet, end: Planet) -> void:
	planetA = start
	planetB = end
	
	path.set_curve(Curve2D.new()) # Curve2D in a scene are shared by default
	path.get_curve().add_point(planetA.get_position())
	path.get_curve().add_point(planetB.get_position())
	line.set_points(path.curve.get_baked_points())
	
	length = cosine_law(start, end)
	pass
