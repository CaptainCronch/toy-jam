extends SubViewport

@export var brush : Node2D

func paint(pos : Vector2, color := Color(1, 1, 1, 1)):
	brush.queue_brush(pos * size.x, color)
