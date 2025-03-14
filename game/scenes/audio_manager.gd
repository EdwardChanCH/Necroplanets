class_name AudioManager
extends Node

@export var bgm_intro_loop: AudioStreamPlayer
@export var sfx_explode: AudioStreamPlayer
@export var sfx_select: AudioStreamPlayer

var bgm: Array[AudioStreamPlayer] = []
var sfx: Array[AudioStreamPlayer] = []

func _ready() -> void:
	bgm.push_back(bgm_intro_loop)
	
	sfx.push_back(sfx_explode)
	sfx.push_back(sfx_select)
	
	change_bgm_volume()
	change_sfx_volume()
	pass

func change_bgm_volume() -> void:
	for a: AudioStreamPlayer in bgm:
		a.set_volume_linear(Global.bgm_value)
		if (Global.bgm_value < 0.01):
			a.set_stream_paused(true)
		else:
			a.set_stream_paused(false)
	pass

func change_sfx_volume() -> void:
	for a: AudioStreamPlayer in sfx:
		a.set_volume_linear(Global.sfx_value)
		if (Global.bgm_value < 0.01):
			a.set_stream_paused(true)
		else:
			a.set_stream_paused(false)
	pass
