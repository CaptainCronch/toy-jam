extends CanvasLayer

@export var big_speed := Vector2(128, 128)
@export var small_speed := Vector2(-64, 64)

@export var parallax_big : Parallax2D
@export var parallax_small : Parallax2D

var speed_multiplier := 1.0


func _process(delta: float) -> void:
	parallax_big.scroll_offset += big_speed * speed_multiplier * delta
	parallax_small.scroll_offset += small_speed * speed_multiplier * delta
