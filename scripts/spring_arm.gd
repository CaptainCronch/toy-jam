extends SpringArm3D

@export var mouse_sensitivity := 0.1
@export var turn_sensitivity := 2
@export var zoom_sensitivity := 10
@export var pan_sensitivity := 0.001
@export var max_offset := 1.0
@export var offset_speed := 0.1
@export var default_spring_length := 3
@export var max_spring_length := 8.0
@export var min_spring_length := 0.5

var cam_lock := false

@export var target : Node3D
@export var vertical : Node3D
@export var camera : Camera3D
@export var background : CanvasLayer

@export var hud_camera : Node3D
@export var hud_camera_holder : Node3D

func _process(delta) -> void:
	hud_camera_holder.global_rotation = camera.global_rotation
	hud_camera.position = Vector3(camera.h_offset * 0.2, camera.v_offset * 0.2, hud_camera.position.z)
	background.speed_multiplier = (inverse_lerp(min_spring_length, max_spring_length, spring_length) * 2) - 1
	#if Input.is_action_just_pressed("up"):
		#camera.v_offset = clampf(camera.v_offset + offset_speed, -max_offset, max_offset)
	#if Input.is_action_just_pressed("down"):
		#camera.v_offset = clampf(camera.v_offset - offset_speed, -max_offset, max_offset)
	#if Input.is_action_just_pressed("right"):
		#camera.h_offset = clampf(camera.h_offset + offset_speed, -max_offset, max_offset)
	#if Input.is_action_just_pressed("left"):
		#camera.h_offset = clampf(camera.h_offset - offset_speed, -max_offset, max_offset)


func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_released("zoom_in"):
		spring_length = clampf(spring_length - zoom_sensitivity * get_process_delta_time(), min_spring_length, max_spring_length)
	if event.is_action_released("zoom_out"):
		spring_length = clampf(spring_length + zoom_sensitivity * get_process_delta_time(), min_spring_length, max_spring_length)

	if event is InputEventMouseMotion and event.button_mask == 4:
		if event.shift_pressed:
			camera.v_offset = clampf(camera.v_offset + (event.relative.y * pan_sensitivity), -max_offset, max_offset)
			camera.h_offset = clampf(camera.h_offset + (-event.relative.x * pan_sensitivity), -max_offset, max_offset)
		else:
			vertical.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
			rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
			rotation.x = clampf(rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _on_hud_display_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse and event.button_mask == 1:
		spring_length = default_spring_length
		vertical.rotation.y = 0
		rotation.x = 0
		camera.h_offset = 0
		camera.v_offset = 0
