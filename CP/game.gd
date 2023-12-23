extends Node
@onready var MAIN = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if MAIN.get_parent().mode == "hard":
		if not MAIN.get_node("Hard").playing:
			MAIN.get_node("Hard").play()
			
	if MAIN.get_parent().mode == "real":
		if not MAIN.get_node("Real").playing:
			MAIN.get_node("Real").play()
			
	if MAIN.get_parent().mode == "easy" or MAIN.get_parent().mode == "norm":
		if not MAIN.get_node("Easy_Norm").playing:
			MAIN.get_node("Easy_Norm").play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if MAIN.get_parent().mode == "hard":
		if not MAIN.get_node("Hard").playing:
			MAIN.get_node("Hard").play()
			
	if MAIN.get_parent().mode == "real":
		if not MAIN.get_node("Real").playing:
			MAIN.get_node("Real").play()
	
	if MAIN.get_parent().mode == "easy" or MAIN.get_parent().mode == "norm":
		if not MAIN.get_node("Easy_Norm").playing:
			MAIN.get_node("Easy_Norm").play()
	
	if Input.is_action_pressed("Space") and not MAIN.start_game:
		MAIN.get_node("Text/Start").visible = false
		MAIN.get_node("Play").get_node("Score").visible = true
		MAIN.get_node("Text/Start/TextureRect").visible = false
		MAIN.get_node("Play").get_tree().paused = false
		MAIN.start_game = true
		
	if Input.is_action_pressed("R") and not MAIN.start_game:	
		MAIN.get_node("Text/End").visible = false
		MAIN.get_node("Text/End/TextureRect").visible = false
		MAIN.get_node("Text/EndScore").visible = false
		#MAIN.get_node("Play").process_mode = 4
		
		MAIN.get_parent().get_tree().paused = false
		MAIN.get_parent().get_tree().reload_current_scene()
		
		#MAIN.get_node("Play").reset()
		#MAIN.start_game = true
	pass
