extends Camera3D

@export var target : Node3D
@export var translation_speed := 8
@export var rotation_speed := 12

func _process(_delta: float) -> void:
	global_position.x = Global.decay_towards(global_position.x, target.global_position.x, translation_speed)
	global_position.y = Global.decay_towards(global_position.y, target.global_position.y, translation_speed)
	global_position.z = Global.decay_towards(global_position.z, target.global_position.z, translation_speed)
	global_rotation.x = Global.decay_angle_towards(global_rotation.x, target.global_rotation.x, rotation_speed)
	global_rotation.y = Global.decay_angle_towards(global_rotation.y, target.global_rotation.y, rotation_speed)
	global_rotation.z = Global.decay_angle_towards(global_rotation.z, target.global_rotation.z, rotation_speed)
