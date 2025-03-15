class_name UpgradeUI
extends Window

@export var solar_system: SolarSystem

var location: Planet
var cost: int = 1

func _ready() -> void:
	set_visible(false)
	pass

func show_ui(_location: Planet) -> void:
	set_visible(true)
	location = _location
	cost = max(1, 10 * pow(2, location.alien_tier) - 10)
	$VBox/HBox1/OldTierLabel.set_text(location.planet_name + " (lv." + str(location.alien_tier) +")")
	$VBox/HBox1/NewTierLabel.set_text(location.planet_name + " (lv." + str(location.alien_tier + 1) +")")
	update_ship_count()
	pass

func update_ship_count() -> void:
	var have_ship: int
	var need_ship: int
	
	if (location != null):
		have_ship = location.alien_count
	
	if (Global.use_cheat):
		need_ship = -1
	else:
		need_ship = cost
	
	$VBox/HBox3/AmountLabel.set_text(str(have_ship) + " / " + str(need_ship))
	
	if (need_ship > 0):
		$VBox/PercentageBar.set_as_ratio(minf(1, float(have_ship) / float(need_ship)))
	else:
		$VBox/PercentageBar.set_as_ratio(1)
	
	if (have_ship >= need_ship or Global.use_cheat):
		$VBox/HBox4/UpgradeYesButton.set_text("Upgrade!")
	else:
		$VBox/HBox4/UpgradeYesButton.set_text("Not Enough Ships...")
	pass

func _on_upgrade_yes_button_pressed() -> void:
	set_visible(false)
	solar_system.deselect_all()
	if (location != null):
		if (Global.use_cheat):
			location.set_alien_count(0, true)
			location.set_alien_tier(1, true)
			show_ui(location)
		elif (location.alien_count >= cost):
			location.set_alien_count(-cost, true)
			location.set_alien_tier(1, true)
			show_ui(location)
	pass

func _on_upgrade_no_button_pressed() -> void:
	set_visible(false)
	solar_system.deselect_all()
	pass

func _on_close_requested() -> void:
	set_visible(false)
	solar_system.deselect_all()
	pass
