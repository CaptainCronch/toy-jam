extends Node


func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Engine.max_fps = 60
	Input.use_accumulated_input = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_window().mode = Window.MODE_FULLSCREEN


func _process(_delta):
	if Input.is_action_just_pressed("debug_key"):
		if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.max_fps = 0
		elif DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			Engine.max_fps = 60

	if Input.is_action_just_pressed("escape"):
		get_tree().quit() # temporary for testing

	if Input.is_action_just_pressed("fullscreen"):
		if get_window().mode != Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED


func mouse_switch(pos := Vector2(0, 0)) -> void :
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_window().warp_mouse(pos)
	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func decay_towards(value : float, target : float,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> float :

	var new_value := (value - target) * pow(2, -delta * decay_power) + target

	if absf(new_value - target) < round_threshold:
		return target
	else:
		return new_value


func decay_towards_v3(value : Vector3, target : Vector3,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> Vector3 :

	var new_value := (value - target) * pow(2, -delta * decay_power) + target

	if (new_value - target).length() < round_threshold:
		return target
	else:
		return new_value


func decay_angle_towards(value : float, target : float,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> float :

	var new_value := angle_difference(target, value) * pow(2, -delta * decay_power) + target

	if absf(angle_difference(target, new_value)) < round_threshold:
		return target
	else:
		return new_value


func vec3_to_2(input : Vector3) -> Vector2: return Vector2(input.x, input.z)


func vec2_to_3(input : Vector2, add_y := 0.0) -> Vector3: return Vector3(input.x, add_y, input.y)


func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	get_tree().get_root().add_child(mesh_instance)
	if persist_ms:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance


func cube(box : BoxShape3D, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, material)
	immediate_mesh.surface_add_vertex(Vector3.RIGHT * box.size.x / -2)
	immediate_mesh.surface_add_vertex(Vector3.RIGHT * box.size.x / 2)
	immediate_mesh.surface_add_vertex(Vector3.FORWARD * box.size.z / -2)
	immediate_mesh.surface_add_vertex(Vector3.FORWARD * box.size.z / 2)
	immediate_mesh.surface_add_vertex(Vector3.UP * box.size.y / -2)
	immediate_mesh.surface_add_vertex(Vector3.UP * box.size.y / 2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	get_tree().get_root().add_child(mesh_instance)
	if persist_ms:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance


func interpolated_line(p0 : Vector2, p1 : Vector2, resolution : int) -> PackedVector2Array: ## Returns array of points
	var points : PackedVector2Array = []
	var dx := p1.x - p0.x
	var dy := p1.y - p0.y
	for i in resolution:
		var t := float(i) / float(resolution)
		var point := Vector2(lerpf(p0[0], p1[0], t), lerpf(p0[1], p1[1], t))
		points.append(point)
	return points


func average_color(img : Image) -> Color:
	var pixels := []
	img.resize(16, 16)
	for row in img.get_height():
		for column in img.get_width():
			pixels.push_back(img.get_pixel(column, row))

	var total := [0, 0, 0]
	for pixel in pixels:
		total[0] += pixel.r
		total[1] += pixel.g
		total[2] += pixel.b

	total = [total[0]/256, total[1]/256, total[2]/256]
	print(Color(total[0], total[1], total[2]))
	return Color(total[0], total[1], total[2])


func mode_color(img : Image) -> Array[Color]: # finish this
	var pixels : Array[Color] = []
	img.resize(16, 16)
	for row in img.get_height():
		for column in img.get_width():
			pixels.push_back(img.get_pixel(column, row))

	var unique_pixels : Array[Color] = []
	for pixel in pixels:
		if not pixels.has(pixel): unique_pixels.append(pixel)

	return unique_pixels
