extends AudioStreamPlayer

var SILENT_DB = -30
var MIN_DB = -2
var MAX_DB = 15

func _ready():
	self.volume_db = SILENT_DB

func _process(delta):
	if Global.Burn == 1:
		self.volume_db = SILENT_DB
		self.stop()
	else:
		self.volume_db = lerp(MAX_DB, MIN_DB, Global.Burn)
		if not self.playing:
			self.play(0)
