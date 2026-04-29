extends Node2D

var enemies_left := 0
var all_defeated := false

func _ready() -> void:
	GameManager.tile_rect($Ground, Vector2(5000, 48))
	GameManager.tile_rect($Platform1, Vector2(256, 32))
	GameManager.tile_rect($Platform2, Vector2(192, 32))
	GameManager.tile_rect($Platform3, Vector2(320, 32))
	GameManager.tile_rect($Platform4, Vector2(256, 32))
	GameManager.tile_rect($Platform5, Vector2(192, 32))
	for enemy in $Enemies.get_children():
		enemies_left += 1
		enemy.stomped.connect(_on_enemy_stomped)
	$Flag.reached.connect(_on_flag_reached)
	_update_hud()

func _update_hud() -> void:
	if not all_defeated:
		$HUD/Objective.text = "Inimigos: %d restante(s) — depois chegue ao castelo!" % enemies_left
	else:
		$HUD/Objective.text = "Chegue ao castelo!"
	$HUD/Lives.text = "Vidas: %d" % GameManager.lives
	$HUD/Score.text = "Pontos: %d" % GameManager.score

func _on_enemy_stomped() -> void:
	enemies_left -= 1
	if enemies_left <= 0:
		all_defeated = true
	_update_hud()

func _on_flag_reached() -> void:
	if all_defeated:
		GameManager.add_score(2000)
		await get_tree().create_timer(0.5).timeout
		GameManager.level_complete()
	else:
		$HUD/Objective.text = "Derrote todos os inimigos primeiro!"
