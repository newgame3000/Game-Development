extends Node
@onready var CAMERA = $Play/Node3D/Camera3D
@onready var SHIP = $Play/Buran

var VECTOR_UP = Vector3(0, 1, 0)
var VECTOR_RIGHT = Vector3(1, 0, 0)
var VECTOR_FORWARD = Vector3(0, 0, 1)
var ROTATION_SPEED = 0.0007
var OBJECT_COUNT = 200

var min_size_a = 3
var max_size_a = 7

var score = 0
var d_r = 0.002
var d_p = 0.006
var d_plr = 0.01

var to_start_r = true
var to_start = true
var start_game = false
var rotation_ud = 0
var rotation_lr = 0
var ud = 0
var lr = 0

#Инерция
var iud = 0
var ilr = 0
var di = 0.001
var coef = 0.01

var real = false

var last_ud = 0
var last_lr = 0

var halfone = true
var old_atan = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().mode == "easy":
		OBJECT_COUNT = 200
		ROTATION_SPEED = 0.0005
		d_p = 0.006
		d_plr = 0.01
		
	if get_parent().mode == "norm":
		OBJECT_COUNT = 300
		ROTATION_SPEED = 0.002
		d_p = 0.009
		d_plr = 0.012
		
	if get_parent().mode == "hard":
		OBJECT_COUNT = 400
		ROTATION_SPEED = 0.004
		d_p = 0.015
		d_plr = 0.02
		
	if get_parent().mode == "real":

		real = true
		OBJECT_COUNT = 350
		ROTATION_SPEED = 0.0002
		d_p = 0.0008
		d_r = 0.0005
		d_plr = 0.0015
	
	$Play/Score.visible = false
	get_tree().paused = true
	
	randomize()
	
	for i in range(OBJECT_COUNT):
		var phi = randf_range(2 * PI / 3, 2 * PI + PI / 2 - 0.1)
		var r = randf_range(42, 45)
		
		var lucky = 0
		lucky = randf_range(0, 1)
		
		if lucky <= 0.95:
			
			var scene = load('res://asteroid.tscn')
			var ast = scene.instantiate()
			
			ast.position.z = r * cos(phi)
			ast.position.y = r * sin(phi)
			ast.position.x = randf_range(-10, 10)
			
			var scale = randf_range(min_size_a, max_size_a)
			
			ast.get_node("MeshInstance3D").scale = Vector3(scale, scale, scale)
			ast.get_node("CollisionShape3D").scale = Vector3(scale, scale, scale)
			
			var rand = randf_range(0, 3)
			
			ast.get_node("MeshInstance3D").rotate_x(rand)
			ast.get_node("CollisionShape3D").rotate_x(rand)
			
			rand = randf_range(0, 3)
			
			ast.get_node("MeshInstance3D").rotate_y(rand)
			ast.get_node("CollisionShape3D").rotate_y(rand)
			
			rand = randf_range(0, 3)
			
			ast.get_node("MeshInstance3D").rotate_z(rand)
			ast.get_node("CollisionShape3D").rotate_z(rand)

			$Play/Asteroids.add_child(ast)
		else:
			var scene = load('res://satellite.tscn')
			var sat = scene.instantiate()
			
			sat.position.z = r * cos(phi)
			sat.position.y = r * sin(phi)
			sat.position.x = randf_range(-10, 10)
			
			var scale = 0.4
			
			sat.get_node("MeshInstance3D").scale = Vector3(scale, scale, scale)
			sat.get_node("CollisionShape3D").scale = Vector3(scale, scale, scale)
			
			var rand = randf_range(0, 3)
			
			sat.get_node("MeshInstance3D").rotate_x(rand)
			sat.get_node("CollisionShape3D").rotate_x(rand)
			
			rand = randf_range(0, 3)
			
			sat.get_node("MeshInstance3D").rotate_y(rand)
			sat.get_node("CollisionShape3D").rotate_y(rand)
			
			rand = randf_range(0, 3)
			
			sat.get_node("MeshInstance3D").rotate_z(rand)
			sat.get_node("CollisionShape3D").rotate_z(rand)

			$Play/Satellites.add_child(sat)

	pass # Replace with function body.

func game_over():
	
	$Text/End.visible = true
	$Text/End/TextureRect.visible = true
	$Text/EndScore.visible = true
	get_tree().paused = true
	$Explosion.play()
	start_game = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CAMERA.transform = CAMERA.transform.orthonormalized()
	SHIP.transform = SHIP.transform.orthonormalized()

	var new_position = Basis(Vector3.LEFT, ROTATION_SPEED) * CAMERA.position
	CAMERA.position = new_position
	
	VECTOR_UP = VECTOR_UP.rotated(Vector3.LEFT, ROTATION_SPEED)
	#VECTOR_RIGHT = VECTOR_RIGHT.rotated( Vector3.LEFT, ROTATION_SPEED)
	VECTOR_FORWARD = VECTOR_FORWARD.rotated( Vector3.LEFT, ROTATION_SPEED)

	CAMERA.look_at(Vector3(0, 0, 0), VECTOR_UP)
	CAMERA.rotate_x(ROTATION_SPEED * 0.9 / ROTATION_SPEED)
	
	var atan = atan($Play/Area3D.position.y / $Play/Area3D.position.z)
	if old_atan > 0 and atan < 0:
		halfone = !halfone
	old_atan = atan

		
	new_position = Basis( Vector3.LEFT, ROTATION_SPEED) * SHIP.position
	if SHIP.move_and_collide(new_position - SHIP.position):
		game_over()

	SHIP.rotate_x(-ROTATION_SPEED)

	new_position = Basis( Vector3.LEFT, ROTATION_SPEED) * $Play/Area3D.position
	$Play/Area3D.position = new_position
	$Play/Area3D.rotate_x(-ROTATION_SPEED)
	
	
	if to_start:
		
		if real and iud > 0 and ud <= 2.5:
			ud += d_p + abs(iud) * coef
			new_position =  SHIP.position + VECTOR_UP * ((d_p + abs(iud)) * coef)
			if SHIP.move_and_collide(new_position - SHIP.position):
				game_over()
		else:
			if ud >= 2.5:
				iud = 0

		if real and iud < 0 and ud >= -1:
			ud -= d_p + abs(iud) * coef
			new_position =  SHIP.position - VECTOR_UP * ((d_p + abs(iud)) * coef)
			if SHIP.move_and_collide(new_position - SHIP.position):
				game_over()
		else:
			if ud == -1:
				iud = 0
	
		if rotation_ud > 0:
			
			rotation_ud -= 2 * d_r
			SHIP.rotate(-VECTOR_RIGHT, 2 * d_r)
			
		if rotation_ud < 0:
			rotation_ud += 2 * d_r
			SHIP.rotate(VECTOR_RIGHT, 2 * d_r)
	
	if to_start_r:
		
		if real and ilr < 0 and lr >= -3:
			lr -= d_plr + abs(ilr) * coef
			new_position =  SHIP.position - VECTOR_RIGHT * ((d_plr + abs(ilr)) * coef)
			if SHIP.move_and_collide(new_position - SHIP.position):
				game_over()
		else:
			if lr == -3:
				ilr = 0
				
		if real and ilr > 0 and lr <= 3:
			lr += d_plr + abs(ilr) * coef
			new_position =  SHIP.position + VECTOR_RIGHT * ((d_plr + abs(ilr))  * coef)
			if SHIP.move_and_collide(new_position - SHIP.position):
				game_over()
		else:
			if lr == 3:
				ilr = 0
		
		if rotation_lr > 0:
			rotation_lr -= 2 * d_r
			SHIP.rotate(-VECTOR_FORWARD, 2 * d_r)
			
		if rotation_lr < 0:
			rotation_lr += 2 * d_r
			SHIP.rotate(VECTOR_FORWARD, 2 * d_r)
			
		
	if Input.is_action_pressed("Up"):
		to_start = false
		
		if real:
			
			ud += d_p + abs(iud) * coef
			if ud < 2.5:
				iud += di
				if iud >= 0:
					new_position =  SHIP.position + VECTOR_UP * ((d_p + abs(iud)) * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
				else:
					iud += di
					ud -= d_p + abs(iud) * coef
					new_position =  SHIP.position - VECTOR_UP * ((d_p + abs(iud)) * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
					ud -= d_p + abs(iud) * coef
			else:
				iud = 0
				
		else:
			
			ud += d_p
			if ud < 2.5:
					new_position =  SHIP.position + VECTOR_UP * d_p
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
			else:
				ud -= d_p
		
		rotation_ud += d_r
		
		if rotation_ud < 0.2:
			SHIP.rotate(VECTOR_RIGHT, d_r)
		else:
			rotation_ud -= d_r
		
	if Input.is_action_just_released("Up"):
		to_start = true
		
		
	if Input.is_action_pressed("Down"):
		to_start = false
		
		if real:
			ud -= d_p + abs(iud) * coef
			if ud > -1:
				iud -= di
				if iud <= 0:
					new_position =  SHIP.position - VECTOR_UP * ((d_p + abs(iud)) * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
				else:
					iud -= di
					ud += d_p + abs(iud) * coef
					new_position =  SHIP.position + VECTOR_UP * ((d_p + abs(iud)) * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
					ud += d_p + abs(iud) * coef
					
			else:
				iud = 0
		else:
			ud -= d_p
			if ud > -1:
					new_position =  SHIP.position - VECTOR_UP * d_p
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
			else:
				ud += d_p
		
		rotation_ud -= d_r
		
		if rotation_ud > -0.2:
			SHIP.rotate(-VECTOR_RIGHT, d_r)
		else:
			rotation_ud += d_r
		
	if Input.is_action_just_released("Down"):
		to_start = true
		
	if Input.is_action_pressed("Left"):
		to_start_r = false
		
		if real:
			lr -= d_plr + abs(ilr) * coef
			if lr > -3:
				ilr -= di
				if ilr <= 0:
					new_position =  SHIP.position - VECTOR_RIGHT * ((d_plr + abs(ilr))  * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
				else:
					ilr -= di
					lr += d_plr + abs(ilr) * coef
					new_position =  SHIP.position + VECTOR_RIGHT * ((d_plr + abs(ilr))  * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
					lr += d_plr + abs(ilr) * coef
			else:
				ilr = 0
		else:
			lr -= d_plr
			
			if lr > -3:
				new_position =  SHIP.position - VECTOR_RIGHT * d_plr
				if SHIP.move_and_collide(new_position - SHIP.position):
					game_over()
			else:
				lr += d_plr

		rotation_lr += d_r
	
		if rotation_lr < 0.3:
			SHIP.rotate(VECTOR_FORWARD, d_r)
		else:
			rotation_lr -= d_r
		
	if Input.is_action_just_released("Left"):
		to_start_r = true
		
	if Input.is_action_pressed("Right"):
		to_start_r = false
		
		if real:
			lr += d_plr + abs(ilr) * coef
			if lr < 3:
				ilr += di
				if ilr > 0:
					new_position =  SHIP.position + VECTOR_RIGHT * ((d_plr + abs(ilr)) * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
				else:
					ilr += di
					lr -= d_plr + abs(ilr) * coef
					new_position =  SHIP.position - VECTOR_RIGHT * ((d_plr + abs(ilr)) * coef)
					if SHIP.move_and_collide(new_position - SHIP.position):
						game_over()
					lr -= d_plr + abs(ilr) * coef
			else:
				ilr = 0
		else:
			lr += d_plr
			
			if lr < 3:
				new_position =  SHIP.position + VECTOR_RIGHT * d_plr
				if SHIP.move_and_collide(new_position - SHIP.position):
					game_over()
			else:
				lr -= d_plr

		rotation_lr -= d_r
	
		if rotation_lr > -0.3:
			SHIP.rotate(-VECTOR_FORWARD, d_r)
		else:
			rotation_lr += d_r
		
	if Input.is_action_just_released("Right"):
		to_start_r = true
		
	pass


func _on_area_3d_body_entered(body):
	body.queue_free()
	
	score += 1
	var lucky = 0
	lucky = randf_range(0, 1)
	
	if lucky <= 0.95:
		var scene = load('res://asteroid.tscn')
		var ast = scene.instantiate()
		
		var r = randf_range(42, 45)
		var phi = atan($Play/Area3D.position.y / $Play/Area3D.position.z) - 0.2
		
		if !halfone:
			phi += PI
			
		ast.position.z = r * cos(phi)
		ast.position.y = r * sin(phi)
		ast.position.x = randf_range(-7, 7)
		
		var scale = randf_range(min_size_a, max_size_a)
		
		ast.get_node("MeshInstance3D").scale = Vector3(scale, scale, scale)
		ast.get_node("CollisionShape3D").scale = Vector3(scale, scale, scale)

		var rand = randf_range(0, 3)
			
		ast.get_node("MeshInstance3D").rotate_x(rand)
		ast.get_node("CollisionShape3D").rotate_x(rand)
		
		rand = randf_range(0, 3)
		
		ast.get_node("MeshInstance3D").rotate_y(rand)
		ast.get_node("CollisionShape3D").rotate_y(rand)
		
		rand = randf_range(0, 3)
		
		ast.get_node("MeshInstance3D").rotate_z(rand)
		ast.get_node("CollisionShape3D").rotate_z(rand)

		$Play/Asteroids.add_child(ast)
	else:
		var scene = load('res://satellite.tscn')
		var sat = scene.instantiate()
		
		var r = randf_range(42, 45)
		var phi = atan($Play/Area3D.position.y / $Play/Area3D.position.z) - 0.2
		
		if !halfone:
			phi += PI
	
		sat.position.z = r * cos(phi)
		sat.position.y = r * sin(phi)
		sat.position.x = randf_range(-8, 8)
		
		var scale = 0.4
		
		sat.get_node("MeshInstance3D").scale = Vector3(scale, scale, scale)
		sat.get_node("CollisionShape3D").scale = Vector3(scale, scale, scale)
		
		var rand = randf_range(0, 3)
		
		sat.get_node("MeshInstance3D").rotate_x(rand)
		sat.get_node("CollisionShape3D").rotate_x(rand)
		
		rand = randf_range(0, 3)
		
		sat.get_node("MeshInstance3D").rotate_y(rand)
		sat.get_node("CollisionShape3D").rotate_y(rand)
		
		rand = randf_range(0, 3)
		
		sat.get_node("MeshInstance3D").rotate_z(rand)
		sat.get_node("CollisionShape3D").rotate_z(rand)

		$Play/Satellites.add_child(sat)
	#if phi < 0:
		#phi = 2 * PI - phi
	
	#phi *= 2
	

	pass # Replace with function body.
