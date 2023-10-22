extends Node

@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
#	queue_redraw()
	pass

func _input(event):
	
	if event is InputEventMouseButton:
	
		if event.button_index == 2 and event.is_pressed():
			var scene = load('res://ball.tscn')
			var ball = scene.instantiate()
			ball.position = event.position
			add_child(ball)
		
		if  event.button_index == 1 and event.is_pressed():	
			timer.start(0.15)
			#print("start")
			
		if event.button_index == 1 and not event.is_pressed():
			#print(timer.get_time_left())
			if timer.get_time_left() > 0.0:
				for g in get_children():
					if not (g  is StaticBody2D) and not (g is Timer) and not (g is TextureRect):
						g.modulate = g.COLOR_OLD
			else:
				for g in get_children():
					if not (g  is StaticBody2D) and not (g is Timer) and not (g is TextureRect) and (g.modulate == Color(1, 0, 0)):
						g.get_node("RigidBody2D").apply_force(130 * (event.position - g.position))
			timer.stop()
			#print("stop")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
	# pass

