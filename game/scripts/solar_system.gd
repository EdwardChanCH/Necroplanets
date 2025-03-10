class_name SolarSystem
extends Node2D

const route_2d_res: PackedScene = preload("res://scenes/route_2d.tscn")

@export var camera: Camera2D

var planets: Array[Planet] = []
var routes: Dictionary[int, Route2D] = {}
var ghost_routes: Array[Route2D] = []
var selected_planets: Array[int] = []

func _ready() -> void:
	planets.push_back(null)
	planets.push_back($Mercury)
	planets.push_back($Venus)
	planets.push_back($Earth)
	planets.push_back($Mars)
	planets.push_back($Jupiter)
	planets.push_back($Saturn)
	planets.push_back($Uranus)
	planets.push_back($Neptune)
	planets.push_back($Pluto)
	
	for i in range(1, 10):
		planets[i].planet_selected.connect(_on_planet_selected)
		planets[i].planet_deselected.connect(_on_planet_deselected)
		pass
	
	add_route($Earth, $Mercury)
	add_route($Earth, $Mars)
	add_route($Mercury, $Jupiter)
	add_route($Mars, $Saturn)
	add_route($Jupiter, $Venus)
	add_route($Saturn, $Venus)
	add_route($Venus, $Uranus)
	add_route($Venus, $Neptune)
	add_route($Jupiter, $Uranus)
	add_route($Saturn, $Neptune)
	add_route($Uranus, $Pluto)
	add_route($Neptune, $Pluto)
	
	show_ghost_line($Pluto.position, $Neptune.position)
	pass

func _process(delta: float) -> void:
	if (selected_planets.size() == 1):
		var mouse_pos = get_viewport().get_mouse_position()
		var camera_pos = camera.position
		var camera_zoom = camera.camera_zoom
		var local_pos = (mouse_pos - Vector2(960, 540)) * 1/camera_zoom + camera_pos 
		show_ghost_line(planets[selected_planets[0]].position, local_pos)
		print(camera_pos)
		
		
	pass

func add_route(planet1: Planet, planet2: Planet) -> void:
	if (planet1.planet_id > planet2.planet_id):
		var planet0: Planet = planet1
		planet1 = planet2
		planet2 = planet0
	var routeID = planet1.planet_id * 10 + planet2.planet_id
	var route: Route2D = route_2d_res.instantiate()
	
	add_child(route) # Must be added first to setup node path
	route.set_route(planet1, planet2)
	
	routes[routeID] = route
	planet1.neighbours[planet2] = route
	planet2.neighbours[planet1] = route
	pass

func show_ghost_line(start: Vector2, end: Vector2) -> void:
	$GhostLine.set_visible(true)
	$GhostLine.clear_points()
	$GhostLine.clear_points()
	$GhostLine.add_point(start)
	$GhostLine.add_point(end)
	pass

func hide_ghost_line() -> void:
	$GhostLine.set_visible(false)
	pass

func show_convoy_ui(from: int, to: int) -> void:
	pass

func _on_planet_selected(planet_id: int) -> void:
	selected_planets.push_back(planet_id)
	if (selected_planets.size() >= 2):
		show_ghost_line(planets[selected_planets[0]].position, planets[selected_planets[1]].position)
		show_convoy_ui(selected_planets[0], selected_planets[1])
	pass

func _on_planet_deselected(planet_id: int) -> void:
	selected_planets.erase(planet_id)
	hide_ghost_line()
	pass
