extends Node

@onready var CAMERA = $Node3D/Camera3D
@onready var timer = $Timer
var VECTOR_UP = Vector3(0, 1, 0)
var LINEDRAW = false
var ROTATION_SPEED = 0.01
var SCROLL_SPEED = 0.05

var LINE = ImmediateMesh.new()
var LINE_MESH = MeshInstance3D.new()

var DOT_MESH = MeshInstance3D.new()
var DOT = SphereMesh.new()

var POINT1 = {}
var POINT2 = {}
var DIST = 0

var OLD_MOUSE_POSITION = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	LINE_MESH.mesh = LINE
	LINE_MESH.cast_shadow = false
	get_tree().get_root().call_deferred("add_child", LINE_MESH)
	
	DOT_MESH.mesh = DOT
	DOT_MESH.cast_shadow = false
	DOT_MESH.visible = false
	get_tree().get_root().call_deferred("add_child", DOT_MESH)
	
	timer.start(100)
	CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
	pass # Replace with function body.

func _input(event):
	
	if event is InputEventMouseButton:
	
		if event.button_index == 2 and event.is_pressed():
			var scene = load('res://ball.tscn')
			var ball = scene.instantiate()
			var from = CAMERA.project_ray_origin(event.position)
			var to = from + CAMERA.project_ray_normal(event.position) * 55
			ball.position = to
			$Balls.add_child(ball)
			
		if  event.button_index == 1 and event.is_pressed():	
			timer.stop()
			timer.start(0.5)
			
		if event.button_index == 1 and not event.is_pressed():
			if timer.get_time_left() > 0.0:
				for g in $Balls.get_children():
					g.get_node("RigidBody3D").get_node("MeshInstance3D").mesh.material.albedo_color = g.COLOR_OLD
			else:
				for g in  $Balls.get_children():
					if (g.get_node("RigidBody3D/MeshInstance3D").mesh.material.albedo_color == Color(1, 0, 0)):
						g.get_node("RigidBody3D").apply_force(330 * (DOT_MESH.position - g.position))
			timer.stop()
			LINEDRAW = false
			LINE.clear_surfaces()
			DOT_MESH.visible = false
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	
	if Input.is_mouse_button_pressed(1) and timer.get_time_left() == 0.0:
		print(timer.get_time_left())
		
		
		if not LINEDRAW:
			var space_state = $Node3D.get_world_3d().direct_space_state
			var mouse_position = get_viewport().get_mouse_position()
			var from = CAMERA.project_ray_origin(mouse_position)
			var to = from + CAMERA.project_ray_normal(mouse_position) * 2000
			var arr = PhysicsRayQueryParameters3D.create(from, to, 0x0004)
			POINT1 = space_state.intersect_ray(arr)
			arr = PhysicsRayQueryParameters3D.create(to, from, 0x0004)
			POINT2 = space_state.intersect_ray(arr)
			
			
			OLD_MOUSE_POSITION = mouse_position
			
			print(POINT1)
			print(POINT2)
			
			if not POINT1.is_empty() and not POINT2.is_empty():
				LINEDRAW = true
				DIST = POINT1.position.distance_to(POINT2.position)
				var material = ORMMaterial3D.new()
				material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
				material.albedo_color = Color(1, 0, 0)
				
				LINE.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
				LINE.surface_add_vertex(POINT1.position)
				LINE.surface_add_vertex(POINT2.position)
				LINE.surface_end()
		
		if LINEDRAW and not POINT1.is_empty() and not POINT2.is_empty():
			
			var mouse_position = get_viewport().get_mouse_position()
			
			DOT_MESH.position = (POINT1.position + POINT2.position ) / 2 + (POINT2.position - POINT1.position) * (mouse_position.x - OLD_MOUSE_POSITION.x) / 1000
		
			var dist1 = DOT_MESH.position.distance_to(POINT1.position)
			var dist2 = DOT_MESH.position.distance_to(POINT2.position)
			if dist1 > DIST:
				DOT_MESH.position = POINT2.position
			if dist2 > DIST:
				DOT_MESH.position = POINT1.position
			
			DOT_MESH.visible = true
			
			
	if Input.is_action_pressed("Up"):
		var new_position = Basis(CAMERA.transform.basis * Vector3.LEFT, ROTATION_SPEED) * CAMERA.position
		if new_position.y > -20:
			CAMERA.position = new_position
			VECTOR_UP = VECTOR_UP.rotated(CAMERA.transform.basis * Vector3.LEFT, ROTATION_SPEED)
			CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
	
	if Input.is_action_pressed("Down"):
		var new_position = Basis(CAMERA.transform.basis * Vector3.RIGHT, ROTATION_SPEED) * CAMERA.position
		if new_position.y >  -20:
			CAMERA.position = new_position
			VECTOR_UP = VECTOR_UP.rotated(CAMERA.transform.basis * Vector3.RIGHT, ROTATION_SPEED)
			CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
		
	if Input.is_action_pressed("Left"):
		var new_position = Basis(CAMERA.transform.basis * Vector3.DOWN, ROTATION_SPEED) * CAMERA.position
		if new_position.y > -20:
			CAMERA.position = new_position
			VECTOR_UP = VECTOR_UP.rotated(CAMERA.transform.basis * Vector3.DOWN, ROTATION_SPEED)
			CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
		
	if Input.is_action_pressed("Right"):
		var new_position = Basis(CAMERA.transform.basis * Vector3.UP, ROTATION_SPEED) * CAMERA.position
		if new_position.y >  -20:
			CAMERA.position = new_position
			VECTOR_UP = VECTOR_UP.rotated(CAMERA.transform.basis * Vector3.UP, ROTATION_SPEED)
			CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
		
	if Input.is_action_pressed("Rotate_right"):
		var new_position = Basis(CAMERA.transform.basis * Vector3.FORWARD, ROTATION_SPEED) * CAMERA.position
		if new_position.y >  -20:
			CAMERA.position = new_position
			VECTOR_UP = VECTOR_UP.rotated(CAMERA.transform.basis * Vector3.FORWARD, ROTATION_SPEED)
			CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
		
	if Input.is_action_pressed("Rotate_left"):
		var new_position = Basis(CAMERA.transform.basis * Vector3.BACK, ROTATION_SPEED) * CAMERA.position
		if new_position.y > -20:
			CAMERA.position = new_position
			VECTOR_UP = VECTOR_UP.rotated(CAMERA.transform.basis * Vector3.BACK, ROTATION_SPEED)
			CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
		
	if Input.is_action_just_released("Closer"):
		var new_position = CAMERA.position - CAMERA.position * SCROLL_SPEED
		if new_position.distance_to(Vector3.ZERO) > 45:
			CAMERA.position = new_position
	
	if Input.is_action_just_released("Further"):
		var new_position = CAMERA.position + CAMERA.position * SCROLL_SPEED
		if new_position.distance_to(Vector3.ZERO) < 80 and new_position.y > -20:
			CAMERA.position = new_position
	pass
