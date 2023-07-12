extends Polygon2D

func _ready():
	var uvs = [
		Vector2(0, 0),  # Top-left corner
		Vector2(1, 0),  # Top-right corner
		Vector2(1, 1),  # Bottom-right corner
		Vector2(0, 1)   # Bottom-left corner
	]
	uv = uvs		
	update_polygon()

func _process(_delta):
	update_polygon()

func update_polygon():
	var screen_size = get_viewport().get_visible_rect().size
	var points = [
		Vector2(0, 0),
		Vector2(screen_size.x, 0),
		Vector2(screen_size.x, screen_size.y),
		Vector2(0, screen_size.y)
	]
	polygon = points
