extends Node2D

func _ready():
	var viewport_size = get_viewport_rect().size
	var center_position = viewport_size / 2.0
	position = center_position

	for child in get_children():
		if child is Sprite2D:
			var child_half_size = child.texture.get_size() / 2.0
			child.global_position = center_position - child_half_size


