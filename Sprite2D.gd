extends Sprite2D

var fall_velocity = 0.0001;
var mode7: Transform3D;
var depth = Vector2(0,0);
var rotation_angle = 0.0;
var zaxis = Vector3(0,0,1);
var scale_update = Vector3(1.0,1.0,1.0);

var drift_update = Vector3(0.0,-0.001,0.0);
var drift_bump_direction = Vector3();
var drift_bump_forward = Vector3(0.0, -0.001, 0.0);

func _ready():
	var mat = get_material();
	mode7 = mat.get_shader_parameter('TRANSFORM');	


func _process(delta):
	if Input.is_action_pressed("move_right"):
		rotation_angle += 1.0 * delta 
	if Input.is_action_pressed("move_left"):
		rotation_angle -= 1.0 * delta
		
	mode7 = mode7.rotated(zaxis, rotation_angle);
	drift_bump_forward = drift_bump_forward.rotated(zaxis, rotation_angle)
	
	if Input.is_action_pressed("move_down"):
		drift_bump_direction = drift_bump_forward * -1
	if Input.is_action_pressed("move_up"):
		drift_bump_direction = drift_bump_forward	
		
	scale_update.x -= fall_velocity * delta;
	scale_update.y -= fall_velocity * delta;
	print("scale_update", scale_update);
	mode7 = mode7.scaled(scale_update);
	
	drift_update = drift_update.rotated(zaxis, rotation_angle);
	drift_update += drift_bump_direction;
	mode7 = mode7.translated(drift_update);
	
	drift_update -= drift_bump_direction; #reset the drift bump
	rotation_angle = 0.0; # reset rotation angle
		
	var mat = get_material();
	mat.set_shader_parameter('DEPTH', depth);
	mat.set_shader_parameter('TRANSFORM', mode7); 
