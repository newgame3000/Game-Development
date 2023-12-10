extends Node
@onready var MAIN = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	MAIN.get_node("AudioStreamPlayer").play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not get_parent().get_node("AudioStreamPlayer").playing:
		get_parent().get_node("AudioStreamPlayer").play()
	
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
		MAIN.get_node("Play").get_tree().reload_current_scene()
		#MAIN.get_node("Play").reset()
		MAIN.start_game = true
	pass
