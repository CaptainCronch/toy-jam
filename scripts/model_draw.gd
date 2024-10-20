extends Node3D
class_name ModelDraw

@export var mesh_instance : MeshInstance3D
@export var viewport : PaintViewport
@export var collider : CollisionShape3D
@export var spacing := 10
@export var space_threshold := 0.03

var brush_size := 10
var brush_type := "circle"
var primary_color := Color.RED
var secondary_color := Color.BLACK
var last_point = null
var mirror := false
var last_mirror_point = null
var fresnel = null

@onready var uv_position := UVPosition.new()
@onready var deejay : Deejay = get_node("/root/Main").deejay


func _ready() -> void:
	await get_parent().get_parent().ready
	if mesh_instance == null:
		mesh_instance = get_child(0)
		print(get_child(0))
	else: print("nada")
	reset_collider()

	uv_position.set_mesh(mesh_instance)
	fresnel = mesh_instance.material_overlay
	mesh_instance.material_override.albedo_texture.viewport_path = get_path_to(viewport)


func reset_collider():
	if mesh_instance.has_node("StaticBody3D"):
		mesh_instance.get_node("StaticBody3D").queue_free()
	var shape := CollisionShape3D.new()
	shape.shape = mesh_instance.mesh.create_trimesh_shape()
	# create new staticbody3d with mesh collider and hook it up to the drawing signal
	var static_body := StaticBody3D.new()
	mesh_instance.add_child(static_body)
	static_body.add_child(shape)
	collider = shape
	static_body.connect("input_event", _on_input_event)


#func _process(_delta: float) -> void:
	#if Input.is_action_just_released("mouse"):
		#deejay.average(Global.average_color(mesh_instance.material_override.albedo_texture.get_image()))


func set_brush_size(size): brush_size = size


func set_brush_type(type): brush_type = type


#func align_with_y(xform, new_y):
	#xform.basis.y = new_y
	#xform.basis.x = -xform.basis.z.cross(new_y)
	#xform.basis = xform.basis.orthonormalized()
	#return xform


func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, _shape_idx: int) -> void:
	#brush_preview.position = event_position
	#brush_preview.global_transform = align_with_y(brush_preview.global_transform, normal)
	if event.button_mask == 0:
		last_point = null
		last_mirror_point = null

	var color
	if event.button_mask == 1: color = primary_color
	elif event.button_mask == 2: color = secondary_color
	else: return

	var uv = uv_position.get_uv_coords(event_position, normal)
	var mirrored_uv
	if mirror:
		var new_pos := Vector3(event_position.x * -1, event_position.y, event_position.z)
		var new_normal := Vector3(normal.x * -1, normal.y, normal.z)
		mirrored_uv = uv_position.get_uv_coords(new_pos, new_normal)


	if uv:
		deejay.play_paint(inverse_lerp(uv.distance_to(last_point), 0, 2) + 0.5 if last_point != null else 1.0)
		if not last_point == null and not last_point == uv and uv.distance_to(last_point) < space_threshold:
			for pos in Global.interpolated_line(last_point, uv, spacing):
				viewport.paint(pos, color, brush_type, brush_size)
		else:
			viewport.paint(uv, color, brush_type, brush_size)
	if mirror and mirrored_uv:
		if not last_mirror_point == null and not last_mirror_point == mirrored_uv and mirrored_uv.distance_to(last_mirror_point) < space_threshold:
			for pos in Global.interpolated_line(last_mirror_point, mirrored_uv, spacing):
				viewport.paint(pos, color, brush_type, brush_size)
		else:
			viewport.paint(mirrored_uv, color, brush_type, brush_size)
	last_point = uv
	last_mirror_point = mirrored_uv
	#mesh_instance.material_override.albedo_texture = viewport.get_texture()


func _on_color_picker_primary_color_changed(color: Color) -> void:
	primary_color = color


func _on_color_picker_secondary_color_changed(color: Color) -> void:
	secondary_color = color


func _on_fill_primary_pressed() -> void:
	viewport.bucket_fill(primary_color)


func _on_fill_secondary_pressed() -> void:
	viewport.bucket_fill(secondary_color)


func _on_mirror_toggle_toggled(toggled_on: bool) -> void:
	mirror = toggled_on


func _on_unshade_toggle_toggled(toggled_on: bool) -> void:
	mesh_instance.material_override.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED if toggled_on else StandardMaterial3D.SHADING_MODE_PER_PIXEL
	mesh_instance.material_overlay = null if toggled_on else fresnel
