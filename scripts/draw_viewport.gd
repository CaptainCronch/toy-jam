extends SubViewport

@export var brush : Node2D
@export var fill : Node2D

func paint(pos : Vector2, color : Color):
	brush.queue_brush(pos * size.x, color)

func bucket_fill(color : Color):
	brush.queue_brush(Vector2(), color, true)
