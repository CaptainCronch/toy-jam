extends TextureRect
class_name BrushSelect

signal clicked(texture : Texture2D)


func _on_gui_input(event: InputEvent) -> void:
	if event.button_mask == 1:
		clicked.emit(texture)
