extends ModelDraw

@export var head_anchor : BoneAttachment3D
@export var hip_anchor : BoneAttachment3D
@export var real_mesh : MeshInstance3D


func _ready() -> void:
	mesh_instance = real_mesh
	super()
