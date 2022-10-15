extends Area2D

onready var sprite = $AnimatedSprite

func FaceRight():
	sprite.flip_h = false

func FaceLeft():
	sprite.flip_h = true

func _on_Anubis_body_entered(body):
	if body.is_in_group("player"):
		Events.emit_signal("hit_player")
