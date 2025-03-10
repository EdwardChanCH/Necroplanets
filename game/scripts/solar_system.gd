class_name SolarSystem
extends Node2D

const route_2d_res = preload("res://scenes/route_2d.tscn")

var routes: Dictionary[int, Route2D] = {}

func _ready() -> void:
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
	pass

func add_route(planetA: Planet, planetB: Planet):
	var new_route: Route2D = route_2d_res.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(new_route)
	var key: int
	
	if (planetA.planet_id < planetB.planet_id):
		key = planetA.planet_id * 10 + planetB.planet_id
		new_route.planetA = planetA
		new_route.planetB = planetB
	else:
		key = planetB.planet_id * 10 + planetA.planet_id
		new_route.planetA = planetB
		new_route.planetB = planetA
	
	routes[key] = new_route
	new_route.set_route()
	pass
