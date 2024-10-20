extends VSlider

@export var model : Node3D
@export var label : Label


func _ready():
	label.text = str(value) + "px"


func _on_value_changed(value: float) -> void:
	model.set_brush_size(value)
	label.text = str(value) + "px"
