extends Camera2D

onready var player = get_parent().get_node("Player")

func _process(delta):
	var xStart = position.x
	position.x = max(320, player.position.x)
	position.x = min(8800, position.x)
	position.y = 240
	
	Events.emit_signal("camera_move", position.x - xStart)
