class_name AudioManager
extends Node

@export var bgm_intro: AudioStreamPlayer
@export var bgm_loop: AudioStreamPlayer
@export var sfx_explode: AudioStreamPlayer
@export var sfx_select: AudioStreamPlayer

var bgm: Array[AudioStreamPlayer] = []
var sfx: Array[AudioStreamPlayer] = []

func _ready() -> void:
	bgm.push_back($bgmIntro)
	bgm.push_back($bgmLoop)
	
	sfx.push_back($sfxExplode)
	sfx.push_back($sfxselect)
	
	change_bgm_volume()
	change_sfx_volume()
	bgm_intro.play()
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

func _on_bgm_intro_finished() -> void:
	bgm_loop.play()
	pass

func _on_bgm_loop_finished() -> void:
	bgm_loop.play()
	pass
