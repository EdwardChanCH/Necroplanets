class_name ConvoyUI
extends Window

@export var solar_system: SolarSystem

var source: Planet
var destination: Planet

func _ready() -> void:
	set_visible(false)
	pass

func show_ui(_source: Planet, _destination: Planet) -> void:
	set_visible(true)
	source = _source
	destination = _destination
	$VBox/HBox1/SourceLabel.set_text(source.planet_name)
	$VBox/HBox1/DestinationLabel.set_text(destination.planet_name)
	update_ship_count()
	$VBox/AmountSlider.set_value($VBox/AmountSlider.max_value)
	pass

func update_ship_count() -> void:
	if (Global.use_cheat):
		$VBox/AmountSlider.set_max(10000)
	elif (source != null):
		$VBox/AmountSlider.set_max(source.alien_count)
	else:
		$VBox/AmountSlider.set_max(0)
	pass

func _on_amount_slider_value_changed(value: float) -> void:
	$VBox/AmountLabel.set_text(str(roundi(value)))
	pass

func _on_convoy_yes_button_pressed() -> void:
	set_visible(false)
	if (source != null and destination != null):
		solar_system.transfer_ships(source, destination, $VBox/AmountSlider.value, true, Global.alien_accel)
	pass

func _on_convoy_no_button_pressed() -> void:
	set_visible(false)
	solar_system.deselect_all()
	pass

func _on_close_requested() -> void:
	set_visible(false)
	solar_system.deselect_all()
	pass
