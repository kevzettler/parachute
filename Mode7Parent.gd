extends Node2D

@onready var node_sprite = $Sprite2D
@onready var node_mode7 = get_parent()
var SCREEN_SIZE = Vector2();

func create_2d_perspective_matrix(depth: Vector2) -> Basis:
	return Basis(
		Vector3(1, 0, depth.x),
		Vector3(0, 1, depth.y),
		Vector3(0, 0, 1))

func mult_position_by_basis(pos: Vector2, mat: Basis) -> Vector3:
	var x = Vector3(pos.x, pos.y, 1.0)
	var res = mat * x
	return Vector3(res.x / res.z, res.y / res.z, res.z) # Important: dividing here applies perspective
	# Another important factor: the Z component is a depth. The bigger it is, the further
	# away the sprite is. Ideally, the sprite should be hidden if the Z component <= 0

func _ready():
	SCREEN_SIZE = get_viewport().size	

func _process(_delta: float):
	SCREEN_SIZE = get_viewport().size
	var material = node_mode7.material # should be a ShaderMatrial
	var transform = material.get_shader_parameter("TRANSFORM")
	var depth = material.get_shader_parameter("DEPTH")
	# Create perspective matrix
	var perspective_matrix = create_2d_perspective_matrix(depth)
	# Create view matrix from TRANFORM. Note that Z row is skipped, just like in the original shader.
	var view_matrix = Basis(
		Vector3(transform.x.x, transform.x.y, transform.x.z), 
		Vector3(transform.y.x, transform.y.y, transform.y.z), 
		Vector3.ZERO)
	
	# Transform to range [-1, 1] from world space
	var worldpos = (global_position / Vector2(SCREEN_SIZE.x / 2.0, SCREEN_SIZE.y / 2.0)) - Vector2.ONE
	var mat = perspective_matrix * view_matrix # May want to reverse order? I don't remember which way is correct
	var pos = mult_position_by_basis(worldpos, mat)
	
	print("sprite position = ", pos);
	#if (pos.z > 0.0):
		# Transform back to world space
	#node_sprite.global_position = (Vector2(pos.x, pos.y) + Vector2.ONE) * (SCREEN_SIZE / 2)
	node_sprite.show()
	#else:
	#	print("hiding sprite Z index is 0");
	#	node_sprite.hide()
