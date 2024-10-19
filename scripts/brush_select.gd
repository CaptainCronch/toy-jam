extends TextureRect
class_name BrushSelect

signal clicked(shape : String)

@export var shape := "circle"


func _on_gui_input(event: InputEvent) -> void:
	if event.button_mask == 1:
		clicked.emit(shape)
