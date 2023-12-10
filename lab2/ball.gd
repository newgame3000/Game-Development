extends Node3D

var RADIUS = 0
var MOUSE_ENT = false
var COLOR_OLD = Color.from_hsv(0, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$RigidBody3D/MeshInstance3D.mesh.material.albedo_color = Color.from_hsv(randf_range(1.0/6.0, 5.0/6.0), 1, 1)
	COLOR_OLD = $RigidBody3D/MeshInstance3D.mesh.material.albedo_color
	RADIUS = randf_range(1, 5)
	$RigidBody3D.mass = RADIUS / 10
	$RigidBody3D/CollisionShape3D.shape.radius = RADIUS
	$RigidBody3D/MeshInstance3D.mesh.radius = RADIUS
	$RigidBody3D/MeshInstance3D.mesh.height = RADIUS * 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if MOUSE_ENT and event.button_index == 1:
			var parent = get_parent().get_parent()
			var t = parent.get_node("Timer")
			t.start(100)
			print("rabotaet2")
			if event.is_pressed():
				if $RigidBody3D/MeshInstance3D.mesh.material.albedo_color != Color.from_hsv(0, 1, 1):
					$RigidBody3D/MeshInstance3D.mesh.material.albedo_color = Color.from_hsv(0, 1, 1)
				else:
					$RigidBody3D/MeshInstance3D.mesh.material.albedo_color = COLOR_OLD
			
			#parent.LINEDRAW = false
			#parent.LINE.clear_surfaces()
			#parent.DOT_MESH.visible = false
			get_viewport().set_input_as_handled()

func _on_rigid_body_3d_mouse_entered():
	MOUSE_ENT = true
	pass # Replace with function body.

func _on_rigid_body_3d_mouse_exited():
	MOUSE_ENT = false
	pass # Replace with function body.
