extends Path2D

func _ready():
	Events.connect("camera_move", self, "_on_camera_move")

func _on_camera_move(xChange):
	position.x += xChange
