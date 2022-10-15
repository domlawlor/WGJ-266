extends AudioStreamPlayer

onready var fadeInTimer = $FadeInTimer

var SILENT_DB = -30
var MAX_DB = -8

func _ready():
	self.volume_db = SILENT_DB
	self.play(0)

func _process(delta):
	var normTime = Global.normalize(0, fadeInTimer.wait_time, fadeInTimer.time_left)
	self.volume_db = lerp(MAX_DB, SILENT_DB, normTime)
