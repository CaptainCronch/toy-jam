extends Node2D

var texture : ImageTexture
var color := Color.BLACK
var needs_drawing := false

func _ready() -> void:
	var img := Image.create_empty(1024, 1024, false, Image.FORMAT_RGBH)
	img.fill(Color.WHITE)
	texture = ImageTexture.create_from_image(img)

func _draw() -> void:
	if needs_drawing:
		draw_texture(texture, Vector2(), color)
		needs_drawing = false
