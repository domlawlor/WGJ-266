extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	Events.connect("restart_level", self, "_on_restart_level")
	animationPlayer.play("FullCycle")
	animationPlayer.seek(0)

func SetDayActive(_active):
	Global.Daytime = _active
	
func _on_restart_level():
	animationPlayer.play("FullCycle")
	animationPlayer.seek(0)
