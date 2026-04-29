extends Node2D

func _ready() -> void:
	GameManager.tile_rect($Ground, Vector2(4000, 48))
	GameManager.tile_rect($Platform1, Vector2(192, 32))
	GameManager.tile_rect($Platform2, Vector2(192, 32))
	GameManager.tile_rect($Platform3, Vector2(256, 32))
	GameManager.tile_rect($Platform4, Vector2(192, 32))
	GameManager.tile_rect($Platform5, Vector2(256, 32))
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
