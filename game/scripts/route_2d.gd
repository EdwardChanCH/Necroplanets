class_name Route2D
extends Node2D

const line_dotted: GradientTexture1D = preload("res://textures/line_dotted.tres")
const line_ghost_alien: GradientTexture1D = preload("res://textures/line_ghost_alien.tres")
const line_ghost_alien_curve: Curve = preload("res://textures/line_ghost_alien_curve.tres")

@export var path: Path2D
@export var line: Line2D

var planetA: Planet
var planetB: Planet
var length: float = 0
var is_hinted: bool = false

func cosine_law(pA: Planet, pB: Planet) -> float:
	var a: float = pA.radius_au
	var b: float = pB.radius_au
	var deg: float = abs(pA.angle_deg - pB.angle_deg)
	
	return sqrt(a*a + b*b - 2*a*b*cos(deg_to_rad(deg)))

func set_route(start: Planet, end: Planet) -> void:
	planetA = start
	planetB = end
	length = cosine_law(start, end)
	
	path.set_curve(Curve2D.new()) # Curve2D in a scene are shared by default
	path.get_curve().add_point(planetA.get_position())
	path.get_curve().add_point(planetB.get_position())
	line.set_points(path.curve.get_baked_points())
	
	recolor_route()
	pass

func redraw_route() -> void:
	set_route(planetA, planetB)
	pass

func recolor_route() -> void:
	if (is_hinted):
		line.set_default_color(Color(0, 0, 1, 1))
	else:
		var diff_A: float = planetA.alien_count - planetA.human_count
		var diff_B: float = planetB.alien_count - planetB.human_count
		
		if (diff_A >= 0 and diff_B >= 0):
			line.set_default_color(Color(0, 1, 0, 1))
		elif (diff_A < 0 and diff_B < 0):
			line.set_default_color(Color(1, 0, 0, 1))
		else:
			line.set_default_color(Color(0, 1, 1, 1))
	pass

func hint_route(_is_hinted: bool) -> void:
	is_hinted = _is_hinted
	recolor_route()
	pass
