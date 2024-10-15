extends Node3D

@export var mesh_instance : MeshInstance3D
@export var collider : StaticBody3D
@export var viewport : SubViewport
@export var spacing := 10
@export var space_threshold := 0.1

var primary_color := Color.RED
var secondary_color := Color.BLACK
var last_point = null


func _ready() -> void:
	UVPosition.set_mesh(mesh_instance)
	mesh_instance.material_override.albedo_texture.viewport_path = get_path_to(viewport)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		Global.average_color(mesh_instance.material_override.albedo_texture.get_image())


func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, _shape_idx: int) -> void:
	if event.button_mask == 0: last_point = null

	var color
	if event.button_mask == 1: color = primary_color
	elif event.button_mask == 2: color = secondary_color
	else: return

	var uv = UVPosition.get_uv_coords(event_position, normal, true)
	if uv:
		if not last_point == null and not last_point == uv and uv.distance_to(last_point) < space_threshold:
			for pos in Global.interpolated_line(last_point, uv, spacing):
				viewport.paint(pos, color)
		else:
			viewport.paint(uv, color)
	last_point = uv
