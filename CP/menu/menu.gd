extends Control

var mode = "easy"
var game = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !$AudioStreamPlayer.playing and !game:
		$AudioStreamPlayer.play()
	
	pass


func _on_start_pressed():
	
	$VBoxContainer.visible = false
	$Mode.visible = true
	
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_easy_pressed():
	mode = "easy"
	
	var scene = load('res://main.tscn')
	var start = scene.instantiate()
	
	game = true
	$AudioStreamPlayer.stop()
	$Mode.visible = false
	get_parent().get_node("Label").visible = false
	get_parent().get_node("TextureRect").visible = false
	add_child(start)
	#get_tree().paused = true
	
	pass # Replace with function body.


func _on_norm_pressed():
	mode = "norm"
	
	var scene = load('res://main.tscn')
	var start = scene.instantiate()
	
	game = true
	$AudioStreamPlayer.stop()
	$Mode.visible = false
	get_parent().get_node("Label").visible = false
	get_parent().get_node("TextureRect").visible = false
	add_child(start)
	pass # Replace with function body.


func _on_hard_pressed():
	mode = "hard"
	
	var scene = load('res://main.tscn')
	var start = scene.instantiate()
	
	game = true
	$AudioStreamPlayer.stop()
	$Mode.visible = false
	get_parent().get_node("Label").visible = false
	get_parent().get_node("TextureRect").visible = false
	add_child(start)
	pass # Replace with function body.


func _on_real_pressed():
	mode = "real"
	
	var scene = load('res://main.tscn')
	var start = scene.instantiate()
	
	game = true
	$AudioStreamPlayer.stop()
	$Mode.visible = false
	get_parent().get_node("Label").visible = false
	get_parent().get_node("TextureRect").visible = false
	add_child(start)
	
	
	pass # Replace with function body.
