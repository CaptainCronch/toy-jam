extends HBoxContainer

@export var drawing_brush : Node2D
@export var add_button : Button
@export var file_dialog : FileDialog
var file_path : String

var brush_select := preload("res://scenes/brush_select.tscn")

var brushes : Array[Texture2D] = [preload("res://assets/brush-50.png"), preload("res://assets/square-50.png")]
var primary_brush_size := 10
var secondary_brush_size := 10


func _ready():
	load_brushes()


func load_brushes():
	for child in get_children():
		if not child.get_class() == "Button":
			child.queue_free()
	for brush in brushes:
		var new_brush : BrushSelect = brush_select.instantiate()
		new_brush.texture = brush
		add_child(new_brush)
		move_child(new_brush, -2)
		new_brush.clicked.connect(func(texture : Texture2D): drawing_brush.texture = texture)


func _on_add_brush_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	file_path = path


func _on_file_dialog_confirmed() -> void:
	var img := Image.new()
	img.load(file_path)
	brushes.append(ImageTexture.create_from_image(img))
	load_brushes()
