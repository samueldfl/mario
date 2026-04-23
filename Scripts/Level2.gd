extends Node2D

var coins_left := 0

func _ready() -> void:
	GameManager.tile_rect($Ground, Vector2(4000, 48))
	GameManager.tile_rect($Platform1, Vector2(256, 32))
	GameManager.tile_rect($Platform2, Vector2(256, 32))
	GameManager.tile_rect($Platform3, Vector2(256, 32))
	GameManager.tile_rect($Platform4, Vector2(256, 32))
	GameManager.tile_rect($Platform5, Vector2(256, 32))
	for coin in $Coins.get_children():
		coins_left += 1
		coin.collected.connect(_on_coin_collected)
	_update_hud()

func _update_hud() -> void:
	$HUD/Objective.text = "Moedas: %d restante(s)" % coins_left
	$HUD/Lives.text = "Vidas: %d" % GameManager.lives
	$HUD/Score.text = "Pontos: %d" % GameManager.score

func _on_coin_collected() -> void:
	coins_left -= 1
	_update_hud()
	if coins_left <= 0:
		GameManager.add_score(500)
		await get_tree().create_timer(0.5).timeout
		GameManager.level_complete()
