extends Node3D
class_name Deejay

@export var paint : AudioStreamPlayer
@export var paint_speed : AudioStreamPlayer
@export var paint_timer : Timer
@export var music : AudioStreamPlayer
@export var color_player : AudioStreamPlayer
@export var pitch : AudioStreamPlayer
@export var twist : AudioStreamPlayer
@export var zoom : AudioStreamPlayer
@export var chirp_low : AudioStreamPlayer
@export var chirp_high : AudioStreamPlayer
@export var select : AudioStreamPlayer
@export var slider_down : AudioStreamPlayer
@export var slider_up : AudioStreamPlayer

var last_color := Color.WHITE
var colors : PackedStringArray = ["blue", "green", "purple", "red", "yellow"]

@onready var pitch_shift := AudioServer.get_bus_effect_instance(1, 0)


func _ready():
	play_color(-1)


func play_paint(speed : float):
	if not paint.playing:
		paint.play()
		paint_speed.play()
	paint_timer.start(0.2)
	#paint_speed.pitch_scale = 1
	#print(str(pitch_shift.get_method_list()).replace(str(AudioEffectInstance.new().get_method_list()), ""))


func play_if_not_playing(player : AudioStreamPlayer):
	if not player.playing: player.play()


func analyze_color(color : Color) -> void:
	if color.get_luminance() > 0.9 or color.get_luminance() < 0.1:
		play_color(-1)
	elif color.h > 0.527778 and color.h < 0.708333:
		play_color(colors.find("blue"))
	elif color.h > 0.222222 and color.h < 0.444444:
		play_color(colors.find("green"))
	elif color.h > 0.125 and color.h < 0.180556:
		play_color(colors.find("yellow"))
	elif color.h > 0.944444 and color.h < 0.0416667:
		play_color(colors.find("red"))
	elif color.h > 0.736111 and color.h < 0.805556:
		play_color(colors.find("purple"))


func play_color(index : int):
	print(index)
	for color in colors.size():
		if color == index:
			color_player.stream.set_sync_stream_volume(color, 0)
		else:
			color_player.stream.set_sync_stream_volume(color, -60)


func switch_music(clip):
	music["parameters/switch_to_clip"] = StringName(clip)


func _on_paint_timer_timeout() -> void:
	paint.stop()
	paint_speed.stop()


func _on_color_picker_primary_color_changed(color: Color) -> void:
	analyze_color(color)


func _on_color_picker_secondary_color_changed(color: Color) -> void:
	analyze_color(color)
