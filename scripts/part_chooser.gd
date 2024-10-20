extends HBoxContainer

signal part_changed(index : int)

@export var parts : Array[String] = ["None"]

var current_part := 0

func _ready():
	changed()


func changed():
	print("changed")
	$Label.text = parts[current_part]
	part_changed.emit(current_part)


func _on_previous_button_down() -> void:
	current_part += 1
	if current_part > parts.size() - 1:
		current_part = 0
	changed()


func _on_next_button_down() -> void:
	current_part -= 1
	if current_part < 0:
		current_part = parts.size() - 1
	changed()
