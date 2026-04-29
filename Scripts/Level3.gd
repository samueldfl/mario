extends Node2D

var enemies_left := 0

func _ready() -> void:
	GameManager.tile_rect($Ground, Vector2(4000, 48))
	GameManager.tile_rect($Platform1, Vector2(256, 32))
	GameManager.tile_rect($Platform2, Vector2(192, 32))
	GameManager.tile_rect($Platform3, Vector2(320, 32))
	GameManager.tile_rect($Platform4, Vector2(256, 32))
	for enemy in $Enemies.get_children():
		enemies_left += 1
		enemy.stomped.connect(_on_enemy_stomped)
	_update_hud()

func _update_hud() -> void:
	$HUD/Objective.text = "Goombas: %d restante(s)" % enemies_left
	$HUD/Lives.text = "Vidas: %d" % GameManager.lives
	$HUD/Score.text = "Pontos: %d" % GameManager.score

func _on_enemy_stomped() -> void:
	enemies_left -= 1
	_update_hud()
	if enemies_left <= 0:
		GameManager.add_score(500)
		await get_tree().create_timer(0.5).timeout
		GameManager.level_complete()
