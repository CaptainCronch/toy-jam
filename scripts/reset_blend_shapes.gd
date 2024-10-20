extends Button

@onready var boxes := get_parent().get_children()

func _on_pressed() -> void:
	for box in boxes:
		if box.is_class("HBoxContainer"):
			box.get_child(1).value = 0
