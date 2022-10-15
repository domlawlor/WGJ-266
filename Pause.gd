extends Node2D

var isPaused = false

func _ready():
	Events.connect("camera_move", self, "_on_camera_move")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		isPaused = !isPaused
		get_tree().paused = isPaused
		
		visible = isPaused

func _on_camera_move(xChange):
	position.x += xChange
