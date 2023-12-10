extends Node
@onready var TIMER = $Play/Timer
@onready var CAMERA = $Play/Node3D/Camera3D
@onready var SHIP = $Play/Buran

var score = 0
var min_speed = 800
var max_speed = 2000
var spawn_time = 0.8
var spawn_x = 2
var spawn_y = 1
var spawn_z = 100
var d_r = 0.002
var d_p = 0.002
var to_start_r = true
var to_start = true
var start_game = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Play/Score.visible = false
	get_tree().paused = true
	
	randomize()
	TIMER.start(spawn_time)

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
	
	if SHIP.move_and_collide(Vector3(0, 0, 0)):
			game_over()
	
	if to_start:
		
		if SHIP.rotation.x < 0:
			SHIP.rotation.x += 2 * d_r
			
		if SHIP.rotation.x > 0:
			SHIP.rotation.x -= 2 * d_r

	if to_start_r:	
		if SHIP.rotation.z < 0:
			SHIP.rotation.z += 2 * d_r
			
		if SHIP.rotation.z > 0:
			SHIP.rotation.z -= 2 * d_r	
			
	
	if TIMER.get_time_left() == 0.0:
		var scene = load('res://asteroid.tscn')
		var ast = scene.instantiate()
		ast.position.x = randf_range(-spawn_x, spawn_x)
		ast.position.y = randf_range(-spawn_y, spawn_y)
		ast.position.z = -spawn_z
		ast.get_node("MeshInstance3D").scale = Vector3(0.3, 0.3, 0.3)
		ast.get_node("CollisionShape3D").scale = Vector3(0.3, 0.3, 0.3)
		var speed = randi_range(min_speed, max_speed)
		ast.apply_force(speed * (Vector3(0, 0, 1)))
		$Play/Asteroids.add_child(ast)
		TIMER.start(spawn_time)
		
	if Input.is_action_pressed("Up"):
		to_start = false
		print(SHIP.position)
		print(SHIP.rotation)
		
		if SHIP.move_and_collide(Vector3(0, d_p, 0)):
			game_over()
		
		if SHIP.position.y > 1.5:
			SHIP.position.y = 1.5
			
		SHIP.rotation.x = min(0.3, SHIP.rotation.x + d_r)
		
	if Input.is_action_just_released("Up"):
		to_start = true
		
	if Input.is_action_pressed("Down"):
		to_start = false
		
		if SHIP.move_and_collide(Vector3(0, -d_p, 0)):
			game_over()
		
		if SHIP.position.y < -1.5:
			SHIP.position.y = -1.5
			
		SHIP.rotation.x = max(-0.3, SHIP.rotation.x - d_r)
		
	if Input.is_action_just_released("Down"):
		to_start = true
		
	if Input.is_action_pressed("Left"):
		to_start_r = false
		
		if SHIP.move_and_collide(Vector3(-d_p, 0, 0)):
			game_over()
		
		if SHIP.position.x < -1.5:
			SHIP.position.x = -1.5
			
		SHIP.rotation.z = min(0.3, SHIP.rotation.z + d_r)
		
	if Input.is_action_just_released("Left"):
		to_start_r = true
		
		
	if Input.is_action_pressed("Right"):
		to_start_r = false
		
		if SHIP.move_and_collide(Vector3(d_p, 0, 0)):
			game_over()
		
		if SHIP.position.x > 1.5:
			SHIP.position.x = 1.5
			
		SHIP.rotation.z = max(-0.3, SHIP.rotation.z - d_r)
		
	if Input.is_action_just_released("Right"):
		to_start_r = true
		
	pass


func _on_area_3d_body_entered(body):
	body.queue_free()
	score += 1
	pass # Replace with function body.
