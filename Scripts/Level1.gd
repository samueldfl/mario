extends Node2D

const FIRE_FLOWER_SCENE := preload("res://Scenes/FireFlower.tscn")

func _ready() -> void:
	$Flag.reached.connect(_on_flag_reached)
	_spawn_fire_flower(Vector2(150, 655))
	_update_hud()

func _spawn_fire_flower(pos: Vector2) -> void:
	var flower := FIRE_FLOWER_SCENE.instantiate()
	flower.position = pos
	add_child(flower)

func _update_hud() -> void:
	$HUD/Objective.text = "Objetivo: Chegue à bandeira!"
	$HUD/Lives.text = "Vidas: %d" % GameManager.lives
	$HUD/Score.text = "Pontos: %d" % GameManager.score

func _on_flag_reached() -> void:
	GameManager.add_score(1000)
	await get_tree().create_timer(0.5).timeout
	GameManager.level_complete()
