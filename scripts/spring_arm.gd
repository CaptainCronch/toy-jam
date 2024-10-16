extends SpringArm3D

@export var mouse_sensitivity := 0.1
@export var turn_sensitivity := 2
@export var zoom_sensitivity := 10
@export var max_offset := 1.0
@export var offset_speed := 0.1

var cam_lock := false

@export var target : Node3D
@export var vertical : Node3D
@export var camera : Camera3D

func _process(delta):
	if Input.is_action_just_pressed("up"):
		camera.v_offset = clampf(camera.v_offset + offset_speed, -max_offset, max_offset)
	if Input.is_action_just_pressed("down"):
		camera.v_offset = clampf(camera.v_offset - offset_speed, -max_offset, max_offset)
	if Input.is_action_just_pressed("right"):
		camera.h_offset = clampf(camera.h_offset + offset_speed, -max_offset, max_offset)
	if Input.is_action_just_pressed("left"):
		camera.h_offset = clampf(camera.h_offset - offset_speed, -max_offset, max_offset)


func _unhandled_input(event : InputEvent):
	if event.is_action_released("zoom_in"):
		spring_length = clampf(spring_length - zoom_sensitivity * get_process_delta_time(), 0.5, 8)
	if event.is_action_released("zoom_out"):
		spring_length = clampf(spring_length + zoom_sensitivity * get_process_delta_time(), 0.5, 8)

	if event is InputEventMouseMotion and event.button_mask == 4:
		vertical.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		rotation.x = clampf(rotation.x, deg_to_rad(-80), deg_to_rad(80))
