extends Node3D

@export var mesh_instance : MeshInstance3D
@export var collider : StaticBody3D
@export var viewport : SubViewport
@export var spacing := 10
@export var space_threshold := 0.03
@export var camera : Camera3D
@export var brush_preview : Node3D

var primary_color := Color.RED
var secondary_color := Color.BLACK
var last_point = null
var mirror := false
var last_mirror_point = null
var fresnel : ShaderMaterial


func _ready() -> void:
	UVPosition.set_mesh(mesh_instance)
	mesh_instance.material_override.albedo_texture.viewport_path = get_path_to(viewport)
	fresnel = mesh_instance.material_overlay


func _process(_delta: float) -> void:
	#brush_preview.hide()
	if Input.is_action_just_pressed("space"):
		Global.average_color(mesh_instance.material_override.albedo_texture.get_image())


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform


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

	var uv = UVPosition.get_uv_coords(event_position, normal, true)
	var mirrored_uv
	if mirror:
		var new_pos := Vector3(event_position.x * -1, event_position.y, event_position.z)
		var new_normal := Vector3(normal.x * -1, normal.y, normal.z)
		mirrored_uv = UVPosition.get_uv_coords(new_pos, new_normal, true)

	if uv:
		if not last_point == null and not last_point == uv and uv.distance_to(last_point) < space_threshold:
			for pos in Global.interpolated_line(last_point, uv, spacing):
				viewport.paint(pos, color)
		else:
			viewport.paint(uv, color)
	if mirror and mirrored_uv:
		if not last_mirror_point == null and not last_mirror_point == mirrored_uv and mirrored_uv.distance_to(last_mirror_point) < space_threshold:
			for pos in Global.interpolated_line(last_mirror_point, mirrored_uv, spacing):
				viewport.paint(pos, color)
		else:
			viewport.paint(mirrored_uv, color)
	last_point = uv
	last_mirror_point = mirrored_uv


func _on_color_picker_primary_color_changed(color: Color) -> void:
	primary_color = color


func _on_color_picker_secondary_color_changed(color: Color) -> void:
	secondary_color = color


func _on_fill_primary_pressed() -> void:
	viewport.bucket_fill(primary_color)


func _on_fill_secondary_pressed() -> void:
	viewport.bucket_fill(secondary_color)


func _on_mirror_toggled(toggled_on: bool) -> void:
	mirror = toggled_on


func _on_unshade_toggle_toggled(toggled_on: bool) -> void:
	mesh_instance.material_override.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED if toggled_on else StandardMaterial3D.SHADING_MODE_PER_PIXEL
	mesh_instance.material_overlay = null if toggled_on else fresnel
