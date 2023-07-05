extends Sprite2D

var mode7: Transform3D;
var depth = Vector2(0,0);
var rotation_angle = 0.0;
var zaxis = Vector3(0,0,1);

var drift_update = Vector3(0.0,-0.001,0.0);
var drift_bump_direction = Vector3();
var drift_bump_forward = Vector3(0.0, -0.001, 0.0);

var end_scale = Vector3(0.223373, 0.223373, 1);
signal landing_signal;

var shadow: Polygon2D;

func scale_polygon(polygon: Polygon2D, scale_factor: Vector2) -> void:
	var points = polygon.polygon
	for i in range(points.size()):
		points[i] *= scale_factor
	polygon.polygon = points

func is_close_enough(v1: Vector3, v2: Vector3, tolerance: float) -> bool:
	return (v1 - v2).length() < tolerance

func _ready():
	var mat = get_material();
	mode7 = mat.get_shader_parameter('TRANSFORM');	
	mode7 = mode7.scaled(Vector3(2.0,2.0,1));
	print('initial transform: ', mode7);
	shadow = get_node("/root/gameplay/parachute/shadow");
	scale_polygon(shadow, Vector2(0.4,0.4));
	shadow.hide();


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
	if(is_close_enough(mode7.basis.get_scale(), end_scale, 0.2)):
		print("End game");
		emit_signal("landing_signal");
		return;
	
	if(is_close_enough(mode7.basis.get_scale(), Vector3(0.323373, 0.323373, 1), 0.2)):
		depth.y += 0.01;
		shadow.show();
		
	if(shadow.is_visible_in_tree()):
		scale_polygon(shadow, Vector2(1.003,1.003));
	# (0.235471, 0.166823, 0), Y: (-0.166823, 0.235471, 0), Z: (0, 0, 1), O: (0.63017, -0.613187, 0)]
	
	drift_update -= drift_bump_direction; #reset the drift bump
	rotation_angle = 0.0; # reset rotation anglel
		
	var mat = get_material();
	mat.set_shader_parameter('DEPTH', depth);
	mat.set_shader_parameter('TRANSFORM', mode7); 
