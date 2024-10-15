extends SpringArm3D

@export var mouse_sensitivity := 0.1
@export var turn_sensitivity := 2
@export var zoom_sensitivity := 10
@export var max_offset := 1.0
@export var offset_speed := 0.1


var _analog_look := 0.0
var cam_lock := false

@export var target : Node3D
@export var vertical : Node3D
@export var camera : Camera3D

func _process(delta):
	#var dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	#vertical.rotate_y(dir.x * turn_sensitivity * delta)
	#rotate_x(dir.y * turn_sensitivity * delta * 0.5)

	var zoom = 0
	if Input.is_action_just_released("zoom_in"): zoom -= 1
	if Input.is_action_just_released("zoom_out"): zoom += 1
	spring_length = clampf(spring_length + zoom * zoom_sensitivity * delta, 0.5, 8)

	if Input.is_action_just_pressed("up"):
		camera.v_offset = clampf(camera.v_offset + offset_speed, -max_offset, max_offset)
	if Input.is_action_just_pressed("down"):
		camera.v_offset = clampf(camera.v_offset - offset_speed, -max_offset, max_offset)
	if Input.is_action_just_pressed("right"):
		camera.h_offset = clampf(camera.h_offset + offset_speed, -max_offset, max_offset)
	if Input.is_action_just_pressed("left"):
		camera.h_offset = clampf(camera.h_offset - offset_speed, -max_offset, max_offset)
	#$"../UI/FPS".text = str(Engine.get_frames_per_second())
	#_analog_look = Input.get_axis("look_left", "look_right")
	#rotate_y(deg_to_rad(_analog_look * analog_sensitivity))
	#global_position.x = target.global_position.x + offset.x
	#global_position.z = target.global_position.z + offset.z
	#global_position.y = target.global_position.y + offset.y
	#if player.is_on_floor() or absf(player.velocity.y) > player.plat_comp.jump_force * 1.5 or player.plat_comp.explosive_jumping:
	#	global_position.y = player.global_position.y + offset.y
	#if cam_lock:
		#plat_comp.turn_target = Vector2.UP.rotated(-rotation.y)
	#else:
		#plat_comp.turn_target = Vector2()


func _unhandled_input(event):
	if event is InputEventMouseMotion and event.button_mask == 4:
		vertical.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))

		rotation.x = clampf(rotation.x, deg_to_rad(-80), deg_to_rad(80))
	#elif event is InputEventMouseButton and event.button_index == 0 and event.pressed:
		#pass
	#elif event.is_action_pressed("lock_camera"):
		#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#else:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
