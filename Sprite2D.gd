extends Sprite2D

var mode7: Transform3D;
var depth = Vector2(0,0);
var rotation_angle = 0.0;
var zaxis = Vector3(0,0,1);

var drift_update = Vector3(0.0,-0.001,0.0);
var drift_bump_direction = Vector3();
var drift_bump_forward = Vector3(0.0, -0.001, 0.0);

func _ready():
	var mat = get_material();
	mode7 = mat.get_shader_parameter('TRANSFORM');	
	mode7 = mode7.scaled(Vector3(2.0,2.0,1));
	print('initial transform: ', mode7);


func _process(delta):
	if Input.is_action_pressed("move_right"):
		rotation_angle += 1.0 * delta 
	if Input.is_action_pressed("move_left"):
		rotation_angle -= 1.0 * delta
		
	drift_bump_forward = drift_bump_forward.rotated(zaxis, rotation_angle)
	
	if Input.is_action_pressed("move_down"):
		drift_bump_direction = drift_bump_forward * -1
	if Input.is_action_pressed("move_up"):
		drift_bump_direction = drift_bump_forward	

	drift_update = drift_update.rotated(zaxis, rotation_angle);
	drift_update += drift_bump_direction;
	mode7 = mode7.translated(drift_update);

	mode7 = mode7.rotated_local(zaxis, rotation_angle);

	mode7 = mode7.scaled(Vector3(0.999,0.999,1));
	
	drift_update -= drift_bump_direction; #reset the drift bump
	rotation_angle = 0.0; # reset rotation angle
		
	var mat = get_material();
	mat.set_shader_parameter('DEPTH', depth);
	mat.set_shader_parameter('TRANSFORM', mode7); 
