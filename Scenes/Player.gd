extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var deathTimer = $DeathTimer
onready var jumpBuffer = $JumpBuffer
onready var fireParticles = $FireParticles
onready var burnDeathAudio1 = $BurnDeath1
onready var burnDeathAudio2 = $BurnDeath2
onready var hitDeathAudio1 = $HitDeath1
onready var hitDeathAudio2 = $HitDeath2
onready var jumpAudio1 = $Jump1
onready var jumpAudio2 = $Jump2
onready var jumpAudio3 = $Jump3

var GRAV = 18
var RUN_SPEED = 240
var SHIELD_SPEED = 70
var JUMP_FORCE = -500
var BURN_RATE = 0.005

enum State {
	GROUND,
	AIR,
	SHIELD,
	DEAD,
	END_LEVEL,
}

var m_state = State.AIR
var m_velocity = Vector2(0, 0)
var m_diamonds = 0
var m_lifeStartTimeMS : int = 0

var startPos : Vector2

func _ready():
	Global.Burn = 1.0
	Events.connect("hit_player", self, "_on_hit_player")
	Events.connect("player_death", self, "_on_player_death")
	Events.connect("hit_level_end", self, "_on_hit_level_end")
	Events.connect("diamond_collected", self, "_on_diamond_collected")
	Events.connect("restart_level", self, "_on_restart_level")
	animatedSprite.play("idle")
	
	# debug set start pos
	#position.x = 8500
	#position.y = 300
	startPos = self.position
	
func _physics_process(_delta):
	if Global.Burn < 0.5:
		fireParticles.visible = true
	else:
		fireParticles.visible = false
	
	if m_state == State.END_LEVEL:
		# if in end of level, don't do any movement
		return
	
	if m_state == State.DEAD:
		Global.Burn = min(Global.Burn + BURN_RATE, 1.0)
		var totalTime = deathTimer.wait_time
		var currentTime = deathTimer.time_left
		animatedSprite.modulate.a = currentTime / totalTime
		return
	
	var move = 0
	if Input.is_action_pressed("moveRight"):
		move += 1
	if Input.is_action_pressed("moveLeft"):
		move -= 1
	
	if m_state == State.SHIELD:
		ReduceBurn()
		if !Input.is_action_pressed("shield"):
			m_state = State.GROUND
		else:
			if move > 0:
				m_velocity.x = SHIELD_SPEED
				animatedSprite.flip_h = false
				if animatedSprite.animation == "shieldIdle":
					animatedSprite.play("shieldWalk")
			elif move < 0:
				m_velocity.x = -SHIELD_SPEED
				animatedSprite.flip_h = true
				if animatedSprite.animation == "shieldIdle":
					animatedSprite.play("shieldWalk")
			else:
				m_velocity.x = 0
				if animatedSprite.animation == "shieldWalk":
					animatedSprite.play("shieldIdle")
	
	if m_state != State.SHIELD:	
		#air and ground
		if move > 0:
			m_velocity.x = RUN_SPEED
			animatedSprite.flip_h = false
		elif move < 0:
			m_velocity.x = -RUN_SPEED
			animatedSprite.flip_h = true
		else:
			m_velocity.x = 0
		
		if m_state == State.GROUND:
			if Input.is_action_pressed("shield"):
				m_state = State.SHIELD
				animatedSprite.play("shieldTransition")
			else:
				if move != 0:
					animatedSprite.play("run")
				else:
					animatedSprite.play("idle")
					
				if Input.is_action_just_pressed("jump") or !jumpBuffer.is_stopped():
					playJumpAudio()
					m_velocity.y = JUMP_FORCE
					m_state = State.AIR
					animatedSprite.play("jump")
		elif m_state == State.AIR:
			if Input.is_action_just_pressed("jump"):
				jumpBuffer.start()
			
			var rightCol = move_and_collide(Vector2.RIGHT, true, true, true)
			var leftCol = move_and_collide(Vector2.LEFT, true, true, true)
			
			var hitWallRight = rightCol != null and m_velocity.x > 0 
			var hitWallLeft = leftCol != null and m_velocity.x < 0
			if hitWallRight or hitWallLeft:
				m_velocity.x = 0
		
		if Global.Daytime:
			IncreaseBurn()
		else:
			ReduceBurn()
		
	var col = move_and_collide(Vector2.DOWN, true, true, true)
	if col == null:
		m_velocity.y += GRAV
		if m_state != State.SHIELD:
			m_state = State.AIR
	
	col = move_and_collide(m_velocity * _delta)
	if col != null:
		var ang = floor(rad2deg(col.get_angle()))
		if ang == 0:
			m_state = State.GROUND
			m_velocity.y = 0
		else:
			m_velocity.x = 0

func IncreaseBurn():
	Global.Burn -= BURN_RATE
	if Global.Burn <= 0:
		#playBurnDeathAudio()
		Events.emit_signal("player_death", Global.Death.BURN)

func ReduceBurn():
	Global.Burn += BURN_RATE
	Global.Burn = min(Global.Burn, 1)

func playJumpAudio():
	var choice = randi() % 3
	if choice == 0:
		jumpAudio1.play(0)
	elif choice == 1:
		jumpAudio2.play(0)
	elif choice == 2:
		jumpAudio3.play(0)

func playBurnDeathAudio():
	if burnDeathAudio1.playing or burnDeathAudio2.playing:
		return
	var choice = randi() % 2
	if choice == 0:
		burnDeathAudio1.play(0)
	elif choice == 1:
		burnDeathAudio2.play(0)

func playHitDeathAudio():
	if hitDeathAudio1.playing or hitDeathAudio2.playing:
		return
	var choice = randi() % 2
	if choice == 0:
		hitDeathAudio1.play(0)
	elif choice == 1:
		hitDeathAudio2.play(0)

func _on_DeathTimer_timeout():
	pass # end game

func _on_hit_player():
	Events.emit_signal("player_death", Global.Death.HIT)

func _on_player_death(deathType):
	if m_state == State.DEAD:
		return
	m_state = State.DEAD
	animatedSprite.play("dead")
	deathTimer.start()
	if deathType == Global.Death.HIT or deathType == Global.Death.SPIKES:
		playHitDeathAudio()
	elif deathType == Global.Death.BURN:
		playBurnDeathAudio()

func _on_hit_level_end(body):
	m_state = State.END_LEVEL

func _on_restart_level():
	position = startPos
	m_state = State.AIR
	Global.Burn = 1
	animatedSprite.play("idle")
	m_velocity = Vector2.ZERO
	animatedSprite.modulate.a = 1
	m_diamonds = 0
	m_lifeStartTimeMS = Time.get_ticks_msec()
	
func _on_diamond_collected():
	m_diamonds += 1
	print("diamond collected, total: " + str(m_diamonds))


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "shieldTransition":
		if m_velocity.x != 0:
			animatedSprite.play("shieldWalk")
		else:
			animatedSprite.play("shieldIdle")
