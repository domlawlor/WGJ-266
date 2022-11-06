extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var deathTypeNode = $DeathTypeText

var resetInputEnabled = false 

func _ready():
	Events.connect("player_death", self, "_on_player_death")
	Events.connect("restart_level", self, "_on_restart_level")
	Events.connect("camera_move", self, "_on_camera_move")
	Events.emit_signal("restart_level")

func _unhandled_input(event):
	var restart = resetInputEnabled and event.is_action_pressed("jump")
	if restart:
		Events.emit_signal("restart_level")

func _on_player_death(deathType):
	match(deathType):
		Global.Death.HIT:
			deathTypeNode.text = "from the Wrath of Anubis!"	
		Global.Death.BURN:
			deathTypeNode.text = "Burnt to Death"
		Global.Death.SPIKES:
			deathTypeNode.text = "Impaled by Spikes"
	
	animationPlayer.play("death")

func _on_restart_level():
	animationPlayer.play("RESET")

func _on_camera_move(xChange):
	position.x += xChange

func SetRetryInputEnabled():
	resetInputEnabled = true
	
func SetRetryInputDisabled():
	resetInputEnabled = false
