extends Sprite2D

var fall_velocity = 0.001;
var mode7: Transform3D;
var depth = Vector2(0,0);
var rotation_angle = 0.0;
var zaxis = Vector3(0,0,1);
var scale_update = Vector3(1.0,1.0,1.0);
var drift_update = Vector3(0.0,-0.001,0.0);

func _ready():
	var mat = get_material();
	mode7 = mat.get_shader_parameter('TRANSFORM');	


func _process(delta):
	if Input.is_action_pressed("move_right"):
		rotation_angle += 1.0 * delta 
	if Input.is_action_pressed("move_left"):
		rotation_angle -= 1.0 * delta
	if Input.is_action_pressed("move_down"):
		drift_update.y = 0.01
	if Input.is_action_pressed("move_up"):
		drift_update.y = -0.01
		
	mode7 = mode7.rotated(zaxis, rotation_angle);
		
	scale_update.x -= fall_velocity * delta;
	scale_update.y -= fall_velocity * delta;
	mode7 = mode7.scaled(scale_update);
	
	drift_update = drift_update.rotated(zaxis, rotation_angle);
	mode7 = mode7.translated(drift_update);
	rotation_angle = 0.0; # reset rotation angle
		
	var mat = get_material();
	mat.set_shader_parameter('DEPTH', depth);
	mat.set_shader_parameter('TRANSFORM', mode7); 
