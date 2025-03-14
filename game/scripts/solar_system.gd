class_name SolarSystem
extends Node2D

const route_2d_res: PackedScene = preload("res://scenes/route_2d.tscn")
const convoy_2d_res: PackedScene = preload("res://scenes/convoy_2d.tscn")

@export var convoyUI: ConvoyUI

var planets: Array[Planet] = []
var routes: Dictionary[int, Route2D] = {}
var ghost_routes: Array[Route2D] = []
var selected_ids: Array[int] = []

func _ready() -> void:
	planets.push_back($Pluto)
	planets.push_back($Mercury)
	planets.push_back($Venus)
	planets.push_back($Earth)
	planets.push_back($Mars)
	planets.push_back($Jupiter)
	planets.push_back($Saturn)
	planets.push_back($Uranus)
	planets.push_back($Neptune)
	
	for p: Planet in planets:
		p.planet_selected.connect(_on_planet_selected)
		p.planet_deselected.connect(_on_planet_deselected)
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
	transfer_ships(planets[2], planets[7], 1, false, Global.human_accel)
	transfer_ships(planets[2], planets[8], 1, false, Global.human_accel)
	
	pass

func _process(_delta: float) -> void:
	if (selected_ids.size() == 1):
		redraw_ghost_line(
			planets[selected_ids[0]].position, 
			get_global_mouse_position()
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

func redraw_ghost_line(start: Vector2, end: Vector2) -> void:
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
	for id in selected_ids:
		planets[id].set_button(false)
	selected_ids.clear()
	hide_ghost_line()
	pass

func redraw_map() -> void:
	for p in planets:
		p.redraw_planet_position()
	
	for r in routes.values():
		r.redraw_route()
	
	if (selected_ids.size() == 2):
		redraw_ghost_line(planets[selected_ids[0]].position, planets[selected_ids[1]].position)
	pass

func transfer_ships(source: Planet, destination: Planet, amount: int, is_alien: bool, accel: float):
	if (amount <= 0):
		deselect_all()
		return
	
	var convoy: Convoy2D = convoy_2d_res.instantiate()
	var route_id: int = source.planet_id * 10 + destination.planet_id
	var is_forward: bool = routes.has(route_id)
	if (!is_forward):
		route_id = destination.planet_id * 10 + source.planet_id
	
	convoy.has_takenoff.connect(_on_convoy_has_takenoff)
	convoy.has_terminated.connect(_on_convoy_has_terminated)
	convoy.set_convoy(routes[route_id], is_forward, amount, is_alien, accel)
	convoy.takeoff()
	pass

func redraw_human_count() -> void:
	for p in planets:
		p.redraw_human_count()
	pass

func _on_planet_selected(_id: int) -> void:
	if (selected_ids.size() == 0):
		selected_ids.push_back(_id)
	elif (selected_ids.size() == 1):
		if (planets[selected_ids[0]].neighbours.has(_id)):
			selected_ids.push_back(_id)
		else:
			planets[_id].set_button(false)
	elif (selected_ids.size() >= 2):
		deselect_all()
		selected_ids.push_back(_id)
	
	if (selected_ids.size() == 2):
		redraw_ghost_line(planets[selected_ids[0]].position, planets[selected_ids[1]].position)
		convoyUI.show_ui(planets[selected_ids[0]], planets[selected_ids[1]])
	pass

func _on_planet_deselected(_id: int) -> void:
	deselect_all()
	pass

func _on_convoy_has_takenoff() -> void:
	deselect_all()
	pass

func _on_convoy_has_terminated() -> void:
	redraw_map()
	convoyUI.update_ship_count()
	pass
