extends Node2D
class_name DrawingBrush

@export var shape := "circle"
@export var brush_size := 10

var fill_texture : ImageTexture
var brush_queue := []


func _ready() -> void:
	var img := Image.create_empty(1024, 1024, false, Image.FORMAT_RGBH)
	img.fill(Color.WHITE)
	fill_texture = ImageTexture.create_from_image(img)


func queue_brush(pos : Vector2, color : Color, fill := false):
	brush_queue.push_back({"pos": pos, "color": color, "fill": fill, "shape": shape})
	queue_redraw()


func _draw():
	for brush in brush_queue:
		if brush.fill:
			draw_texture(fill_texture, Vector2(), brush.color)
		else:
			if brush.shape == "circle":
				draw_circle(brush.pos, brush_size / 2, brush.color)
			else:
				draw_rect(
					Rect2(brush.pos.x - brush_size / 2, brush.pos.y - brush_size / 2, brush_size, brush_size),
					brush.color
				)
			#draw_texture_rect(
				#texture,
				#Rect2(brush.pos.x - brush_size / 2, brush.pos.y - brush_size / 2, brush_size, brush_size),
				#false,
				#brush.color,
			#)
	brush_queue = []
