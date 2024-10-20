extends SubViewport
class_name PaintViewport

@export var brush : Node2D
@export var texture_size := 1024


func _ready():
	size = Vector2(texture_size, texture_size)
	bucket_fill(Color.BLACK)


func paint(pos : Vector2, color : Color, brush_type : String, brush_size : int):
	brush.visible = true
	brush.queue_brush(pos * size.x, color, false, brush_type, brush_size)


func bucket_fill(color : Color):
	brush.queue_brush(Vector2(), color, true)


func erase():
	render_target_clear_mode = ClearMode.CLEAR_MODE_ONCE
	brush.visible = false
