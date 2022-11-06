extends Node2D

onready var animationPlayer = $AnimationPlayer

onready var diamondsCollectedText = $DiamondsCollected
onready var timeTakenText = $TimeTaken
onready var victorySound = $VictorySFX

var resetInputEnabled = false

func _ready():
	Events.connect("hit_level_end", self, "on_hit_level_end")
	Events.connect("restart_level", self, "_on_restart_level")
	Events.connect("camera_move", self, "_on_camera_move")
	
	animationPlayer.play("RESET")

func _unhandled_input(event):
	if resetInputEnabled and event.is_action_pressed("jump"):
		Events.emit_signal("restart_level")

func on_hit_level_end(playerBody):
	victorySound.play()
	var startTimeMS = playerBody.m_lifeStartTimeMS
	var timeElapsedMS : int = Time.get_ticks_msec() - startTimeMS
	
	var workingTimeLeft = timeElapsedMS
	
	var msComp = workingTimeLeft % 1000
	workingTimeLeft = (workingTimeLeft - msComp) / 1000
	
	var secComp = workingTimeLeft % 60
	workingTimeLeft = (workingTimeLeft - secComp) / 60
	var minComp = workingTimeLeft % 60
	workingTimeLeft = (workingTimeLeft - minComp) / 60
	var hourComp = workingTimeLeft
	#var hourComp = workingTimeLeft % 60
	
	if hourComp > 0:
		var formatString = "Time - %d:%s:%s.%d"
		timeTakenText.text = formatString % [hourComp, str(minComp).pad_zeros(2), str(secComp).pad_zeros(2), msComp]
	else:
		var formatString = "Time - %s:%s.%d"
		timeTakenText.text = formatString % [str(minComp).pad_zeros(2), str(secComp).pad_zeros(2), msComp]
	
	var diamondCount = playerBody.m_diamonds	
	diamondsCollectedText.text = "Diamonds Collected - " + str(diamondCount)
	
	animationPlayer.play("win")

func _on_restart_level():
	animationPlayer.play("RESET")

func _on_camera_move(xChange):
	position.x += xChange

func SetRetryInputEnabled():
	resetInputEnabled = true
	
func SetRetryInputDisabled():
	resetInputEnabled = false
