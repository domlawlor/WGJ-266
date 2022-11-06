extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var titleText = $TitleText

var playedAnim = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("player_death", self, "_on_player_death")
	Events.connect("restart_level", self, "on_restart_level")
	Events.connect("camera_move", self, "_on_camera_move")

func on_restart_level():
	animationPlayer.stop()
	playedAnim = false
	titleText.modulate.a = 1

func _on_player_death(deathType):
	titleText.modulate.a = 0

func _on_camera_move(xChange):
	if !playedAnim and xChange > 0:
		animationPlayer.play("fadeTitle")
		playedAnim = true
