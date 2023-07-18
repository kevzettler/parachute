extends Node2D

var mode7: Transform3D;
@onready var mode7Node = $Mode7Shader
var depth = Vector2(0,0);
var rotation_angle = 0.0;
var zaxis = Vector3(0,0,1);

var translation_update = Vector3(0.0,-0.001,0.0);
var translation_direction = Vector3();
var translation_forward = Vector3(0.0, -0.001, 0.0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("rotate_right"):
		rotation_angle += 1.0 * delta 
	if Input.is_action_pressed("rotate_left"):
		rotation_angle -= 1.0 * delta
		
	if Input.is_action_pressed("move_down"):
		translation_direction = translation_forward * -1
	if Input.is_action_pressed("move_up"):
		translation_direction = translation_direction	

	translation_update = translation_update.rotated(zaxis, rotation_angle);
	translation_update += translation_direction;
	mode7 = mode7.translated(translation_update);

	var mat = mode7Node.material;
	mat.set_shader_parameter('DEPTH', depth);
	mat.set_shader_parameter('TRANSFORM', mode7); 
