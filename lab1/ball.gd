extends Node2D

var RADIUS = 0
var MOUSE_ENT = false
var COLOR_OLD = Color.from_hsv(0, 1, 1)

# Called when the node enters the scene tree for the first time.

func _ready():
	
	randomize()
	modulate = Color.from_hsv(randf_range(1.0/6.0, 5.0/6.0), 1, 1)
	COLOR_OLD = modulate
	RADIUS = randf_range(10, 40)
	$RigidBody2D.mass = RADIUS / 10
	$RigidBody2D/CollisionShape2D.shape.radius = RADIUS
	$RigidBody2D/Circle.scale.x = RADIUS / 1200
	$RigidBody2D/Circle.scale.y = RADIUS / 1200
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if MOUSE_ENT and event.button_index == 1:
			if event.is_pressed():
				if modulate != Color.from_hsv(0, 1, 1):
					modulate = Color.from_hsv(0, 1, 1)
				else:
					modulate = COLOR_OLD
			get_viewport().set_input_as_handled()


func _on_rigid_body_2d_mouse_entered():
	MOUSE_ENT = true
	pass # Replace with function body.


func _on_rigid_body_2d_mouse_exited():
	MOUSE_ENT = false
	pass # Replace with function body.
