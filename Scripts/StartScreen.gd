extends Control

func _ready() -> void:
	GameManager.score = 0
	GameManager.lives = 3
	GameManager.current_level = 1
	$CenterContainer/StartButton.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	GameManager.goto_level(1)
