extends Node2D

const FIRE_FLOWER_SCENE := preload("res://Scenes/FireFlower.tscn")

var coins_left := 0

func _ready() -> void:
	for coin in $Coins.get_children():
		coins_left += 1
		coin.collected.connect(_on_coin_collected)
	_spawn_fire_flower(Vector2(150, 655))
	_update_hud()

func _spawn_fire_flower(pos: Vector2) -> void:
	var flower := FIRE_FLOWER_SCENE.instantiate()
	flower.position = pos
	add_child(flower)

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
