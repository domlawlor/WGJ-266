extends AnimatedSprite

func _process(delta):
	material.set_shader_param("burn", Global.Burn)
