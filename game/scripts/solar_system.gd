class_name SolarSystem
extends Node2D

const route_2d_res: PackedScene = preload("res://scenes/route_2d.tscn")
const convoy_2d_res: PackedScene = preload("res://scenes/convoy_2d.tscn")

@export var camera: Camera

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
	
	### TESTING AREA ###
	var convoy: Convoy2D = convoy_2d_res.instantiate()
	convoy.has_takenoff.connect(_on_convoy_has_takenoff)
	convoy.has_terminated.connect(_on_convoy_has_terminated)
	convoy.set_convoy(routes[79], true, 10, true, 1)
	convoy.takeoff()
	
	show_ghost_line(planets[4].position, planets[3].position)
	
	pass

func _process(_delta: float) -> void:
	if (selected_planets.size() == 1):
		show_ghost_line(
			planets[selected_planets[0]].position, 
			camera.correct_mouse_pos(get_viewport().get_mouse_position())
			)
		
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
	planet1.neighbours[planet2.planet_id] = route
	planet2.neighbours[planet1.planet_id] = route
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

func deselect_all() -> void:
	for id in selected_planets:
		planets[id].set_button(false)
	selected_planets.clear()
	hide_ghost_line()
	pass

func show_convoy_ui(_start: int, _end: int) -> void:
	pass

func _on_planet_selected(_id: int) -> void:
	if (selected_planets.size() >= 2):
		deselect_all()
	
	selected_planets.push_back(_id)
	
	if (selected_planets.size() == 2):
		show_ghost_line(planets[selected_planets[0]].position, planets[selected_planets[1]].position)
		show_convoy_ui(selected_planets[0], selected_planets[1])
	pass

func _on_planet_deselected(_id: int) -> void:
	deselect_all()
	pass

func _on_convoy_has_takenoff() -> void:
	deselect_all()
	pass

func _on_convoy_has_terminated() -> void:
	pass
