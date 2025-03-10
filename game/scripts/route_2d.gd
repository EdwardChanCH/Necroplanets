class_name Route2D
extends Node2D

@onready var path: Path2D = $Path
@onready var line: Line2D = $Line

var planetA: Planet
var planetB: Planet

func set_route():
	path.set_curve(Curve2D.new()) # Curve2D in a scene are shared by default
	path.get_curve().add_point(planetA.get_position())
	path.get_curve().add_point(planetB.get_position())
	line.set_points(path.curve.get_baked_points())
	pass
