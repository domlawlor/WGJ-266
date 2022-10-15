extends Area2D

func _on_Spikes_body_entered(body):
	if body.is_in_group("player"):
		Events.emit_signal("player_death", Global.Death.SPIKES)
