extends SubViewport

@export var brush : Node2D

func paint(pos : Vector2, color : Color):
	brush.queue_brush(pos * size.x, color)
