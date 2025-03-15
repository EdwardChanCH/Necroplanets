class_name HumanAI
extends Node

@export var sol: SolarSystem
var weights: Array[int] = [0,6,2,10,6,4,4,1,1,0]
var order: Array[int] = [0,1,2,3,4,5,6,7,8]

func _on_pulsed_game_clock() -> void:
	# enemy logic
	order = randomize_array(order)
	take_action()
	pass

func randomize_array(input: Array[int]) -> Array[int]:
	var output: Array[int] = input
	var temp: int = 0
	var a: int = 0
	var b: int = 0
	var n: int = input.size() - 1
	
	for i in range(input.size()):
		a = Global.rng.randi_range(0, n)
		b = Global.rng.randi_range(0, n)
		temp = output[a]
		output[a] = output[b]
		output[b] = temp
	
	return output

func take_action() -> void:
	var arrayN: Array[int]
	var done: bool = false
	
	for pid in order:
		done = false
		
		if (defend(sol.planets[pid], true)):
			defend(sol.planets[pid])
			done = true
		
		if (done):
			continue
		
		arrayN = randomize_array(sol.planets[pid].neighbours.keys())
		
		for nid: int in arrayN:
			if (!done and reinforce(sol.planets[pid], sol.planets[nid], true)):
				reinforce(sol.planets[pid], sol.planets[nid])
				done = true
		
		if (done):
			continue
		
		for nid: int in arrayN:
			if (!done and attack(sol.planets[pid], sol.planets[nid], true)):
				attack(sol.planets[pid], sol.planets[nid])
				done = true
		
	pass

func min_defend(at: Planet) -> int:
	return (10 * (weights[at.planet_id] + 2))

func min_attack(at: Planet) -> int:
	@warning_ignore("integer_division")
	return (floori(at.alien_count * 1.5) + 10)

func defend(from: Planet, check_need: bool = false) -> bool:
	var is_needed: bool = false
	
	if (from.human_count < min_defend(from)):
		is_needed = true
	elif (from.alien_count > 0):
		is_needed = true
	
	if (check_need):
		return is_needed
	
	if (is_needed):
		# defend this planet and wait for reinforcement
		return true
	
	return false

func reinforce(from: Planet, to: Planet, check_need: bool = false) -> bool:
	var is_needed: bool = false
	
	if (!defend(from, true) and to.human_count > 0 and from.human_count > (4 * to.human_count)):
		is_needed = true
	
	if (check_need):
		return is_needed
	
	if (is_needed):
		# reinforce the other planet
		@warning_ignore("integer_division")
		sol.transfer_ships(
			from, 
			to, 
			max(0, from.human_count / 4), 
			false, 
			Global.human_accel
			)
		return true
	
	return false

func attack(from: Planet, to: Planet, check_need: bool = false) -> bool:
	var is_needed: bool = false
	
	if (!defend(from, true) and to.human_count <= 0 and from.human_count > min_attack(to)):
		is_needed = true
	
	if (check_need):
		return is_needed
	
	if (is_needed):
		# attack the other planet
		@warning_ignore("integer_division")
		sol.transfer_ships(
			from, 
			to, 
			max(0, min(min_attack(to), from.human_count)), 
			false, 
			Global.human_accel * 1 # normal speed
			)
		return true
	
	return false
