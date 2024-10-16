extends Node2D
class_name DrawingBrush

@export var texture : Texture2D
@export var brush_size := 10

var brush_queue := []
var last_brush := Vector2()


func queue_brush(pos : Vector2, color : Color):
	brush_queue.push_back({"pos": pos, "color": color})
	queue_redraw()
	last_brush


func _draw():
	for brush in brush_queue:
		draw_texture_rect(
			texture,
			Rect2(brush.pos.x - brush_size / 2, brush.pos.y - brush_size / 2, brush_size, brush_size),
			false,
			brush.color,
		)
	brush_queue = []
