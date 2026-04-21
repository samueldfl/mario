extends Control

func _ready() -> void:
	$Panel/VBox/ScoreLabel.text = "Pontuação Final: %d" % GameManager.score
	$Panel/VBox/RestartButton.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed() -> void:
	GameManager.goto_level(1)
