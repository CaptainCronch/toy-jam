extends Node3D
class_name PainterContainer

@export var ears : Array[Node3D]
@export var fur : Array[Node3D]
@export var horns : Array[Node3D]
@export var tails : Array[Node3D]
@export var base : ModelDraw
@export var eyes : ModelDraw
@export var snout : ModelDraw

@export var ui : Control

var head_accessories : Array[Node3D] = []
var all : Array[Node3D] = []

@onready var deejay : Deejay = get_node("/root/Main/Deejay")


func _ready() -> void:
	head_accessories.append_array(ears)
	head_accessories.append_array(fur)
	head_accessories.append_array(horns)
	all.append_array(head_accessories)
	all.append_array(tails)
	all.append(base)
	all.append(eyes)
	all.append(snout)
	for accessory in head_accessories:
		accessory.reparent(base.head_anchor)
		accessory.transform = Transform3D()
		accessory.rotate_x(deg_to_rad(-90))

	for accessory in tails:
		accessory.reparent((base.hip_anchor))
		accessory.transform = Transform3D()
		accessory.translate(Vector3(0, 0, -0.105))
		#accessory.rotate_x(deg_to_rad(-90))
		#accessory.rotate_y(deg_to_rad(180))

	eyes.reparent(base.head_anchor)
	eyes.transform = Transform3D()
	eyes.rotate_x(deg_to_rad(-90))

	snout.reparent(base.head_anchor)
	snout.transform = Transform3D()
	snout.rotate_x(deg_to_rad(-90))

	#base.transform = Transform3D()

	call_deferred("clean")


func clean():
	var random_number := randi_range(0, head_accessories.size() - 1)
	var new = head_accessories.duplicate()
	new.remove_at(random_number)
	for acc in new:
		acc.visible = false
		acc.collider.disabled = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_key"):
		ui.visible = !ui.visible


var size_value := 10
func set_brush_size(size):
	call_in_all_children("set_brush_size", size, true)

	if size > size_value:
		deejay.play_if_not_playing(deejay.slider_up)
	elif size < size_value:
		deejay.play_if_not_playing(deejay.slider_down)
	size_value = size


func set_brush_type(type):
	if type == "circle": deejay.switch_music("edit")
	else: deejay.switch_music("view")
	call_in_all_children("set_brush_type", type)


func call_in_all_children(function : String, arg = null, played := false):
	if not played: deejay.select.play()
	for one in all:
		if arg == null: one.call(function)
		else: one.call(function, arg)


func _on_color_picker_primary_color_changed(color: Color) -> void:
	call_in_all_children("_on_color_picker_primary_color_changed", color)


func _on_fill_primary_pressed() -> void:
	call_in_all_children("_on_fill_primary_pressed")


func _on_color_picker_secondary_color_changed(color: Color) -> void:
	call_in_all_children("_on_color_picker_secondary_color_changed", color)


func _on_fill_secondary_pressed() -> void:
	call_in_all_children("_on_fill_secondary_pressed")


func _on_mirror_toggle_toggled(toggled_on: bool) -> void:
	call_in_all_children("_on_mirror_toggle_toggled", toggled_on)


func _on_unshade_toggle_toggled(toggled_on: bool) -> void:
	call_in_all_children("_on_unshade_toggle_toggled", toggled_on)


func chooser_helper(array, index, old_index):
	for item in array:
		item.visible = false
		item.collider.disabled = true
	if index == 0:
		return
	array[index - 1].visible = true
	array[index - 1].collider.disabled = false

	if index > old_index:
		deejay.play_if_not_playing(deejay.slider_up)
	elif index < old_index:
		deejay.play_if_not_playing(deejay.slider_down)


var ears_index := 0
func _on_part_chooser_ears_part_changed(index: int) -> void:
	chooser_helper(ears, index, ears_index)
	ears_index = index


var fur_index := 0
func _on_part_chooser_fur_part_changed(index: int) -> void:
	chooser_helper(fur, index, fur_index)
	fur_index = index


var horns_index := 0
func _on_part_chooser_horns_part_changed(index: int) -> void:
	chooser_helper(horns, index, horns_index)
	horns_index = index


var tails_index := 0
func _on_part_chooser_tails_part_changed(index: int) -> void:
	chooser_helper(tails, index, tails_index)
	tails_index = index


func _on_eyes_toggle_toggled(toggled_on: bool) -> void:
	deejay.select.play()
	eyes.visible = toggled_on
	eyes.collider.disabled = !toggled_on


func _on_snout_toggle_toggled(toggled_on: bool) -> void:
	deejay.select.play()
	snout.visible = toggled_on
	snout.collider.disabled = !toggled_on


func _on_erase_eyes_pressed() -> void:
	deejay.select.play()
	eyes.viewport.erase()


func _on_erase_snout_pressed() -> void:
	deejay.select.play()
	snout.viewport.erase()


func change_blend_shape(shape, value, old_value, change_snout := false):
	base.mesh_instance.set_blend_shape_value(base.mesh_instance.find_blend_shape_by_name(shape), value)
	if change_snout: snout.mesh_instance.set_blend_shape_value(snout.mesh_instance.find_blend_shape_by_name(shape), value)

	if value > old_value:
		deejay.play_if_not_playing(deejay.slider_up)
	elif value < old_value:
		deejay.play_if_not_playing(deejay.slider_down)


var arms_value := 0
func _on_arms_value_changed(value: float) -> void:
	change_blend_shape("arms", value / 100, arms_value / 100)
	arms_value = value


var chest_value := 0
func _on_chest_value_changed(value: float) -> void:
	change_blend_shape("chest", value / 100, chest_value / 100)
	chest_value = value


var belly_value := 0
func _on_belly_value_changed(value: float) -> void:
	change_blend_shape("belly", value / 100, belly_value / 100)
	belly_value = value


var thighs_value := 0
func _on_thighs_value_changed(value: float) -> void:
	change_blend_shape("thighs", value / 100, thighs_value / 100)
	thighs_value = value


var canine_value := 0
func _on_canine_value_changed(value: float) -> void:
	change_blend_shape("canine", value / 100, canine_value / 100, true)
	canine_value = value


var feline_value := 0
func _on_feline_value_changed(value: float) -> void:
	change_blend_shape("feline", value / 100, feline_value / 100, true)
	feline_value = value


var reptilian_value := 0
func _on_reptilian_value_changed(value: float) -> void:
	change_blend_shape("reptilian", value / 100, reptilian_value / 100, true)
	reptilian_value = value
