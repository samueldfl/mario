extends Node2D

func _ready() -> void:
	$Flag.reached.connect(_on_flag_reached)
	_update_hud()

func _update_hud() -> void:
	$HUD/Objective.text = "Objetivo: Chegue à bandeira!"
	$HUD/Lives.text = "Vidas: %d" % GameManager.lives
	$HUD/Score.text = "Pontos: %d" % GameManager.score

func _on_flag_reached() -> void:
	GameManager.add_score(1000)
	await get_tree().create_timer(0.5).timeout
	GameManager.level_complete()
