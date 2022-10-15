extends Node2D

func _on_EndZone_body_entered(body):
	Events.emit_signal("hit_level_end", body)
