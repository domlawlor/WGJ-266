extends Node2D

onready var g = get_node("/root/Global")
onready var enemyPath1 = $EnemyPath1
onready var enemyPath2 = $EnemyPath2
onready var enemyPath3 = $EnemyPath3
onready var enemyPath4 = $EnemyPath4
onready var enemyPath5 = $EnemyPath5
onready var enemyPath6 = $EnemyPath6
onready var enemyPath7 = $EnemyPath7
onready var enemyPath8 = $EnemyPath8
onready var enemyPath9 = $EnemyPath9
onready var enemyPath10 = $EnemyPath10
onready var enemyPath11 = $EnemyPath11
onready var enemyPath12 = $EnemyPath12

func _ready():
	enemyPath1.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath2.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath3.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath4.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath5.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath6.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath7.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath8.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath9.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath10.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath11.get_node("AnimationPlayer").play("EnemyPath")
	enemyPath12.get_node("AnimationPlayer").play("EnemyPath")
	
	Events.connect("restart_level", self, "_on_restart_level")
	
func _on_restart_level():
	enemyPath1.get_node("AnimationPlayer").seek(0)
	enemyPath2.get_node("AnimationPlayer").seek(0)
	enemyPath3.get_node("AnimationPlayer").seek(0)
	enemyPath4.get_node("AnimationPlayer").seek(0)
	enemyPath5.get_node("AnimationPlayer").seek(0)
	enemyPath6.get_node("AnimationPlayer").seek(0)
	enemyPath7.get_node("AnimationPlayer").seek(0)
	enemyPath8.get_node("AnimationPlayer").seek(0)
	enemyPath9.get_node("AnimationPlayer").seek(0)
	enemyPath10.get_node("AnimationPlayer").seek(0)
	enemyPath11.get_node("AnimationPlayer").seek(0)
	enemyPath12.get_node("AnimationPlayer").seek(0)
