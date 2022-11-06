extends Area2D

onready var sfx = $SFX

var m_collected = false

func _ready():
	Events.connect("restart_level", self, "_on_restart_level")

func _on_DiamondPickup_body_entered(body):
	if !m_collected and body.is_in_group("player"):
		sfx.play(0)
		m_collected = true
		Events.emit_signal("diamond_collected")
		visible = false
		
func _on_restart_level():
	m_collected = false
	visible = true
