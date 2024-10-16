extends VSlider

@export var drawing_brush : DrawingBrush
@export var label : Label


func _ready():
	label.text = str(value) + "px"


func _on_value_changed(value: float) -> void:
	drawing_brush.brush_size = value
	label.text = str(value) + "px"
