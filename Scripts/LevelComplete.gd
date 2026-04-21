extends Control

func _ready() -> void:
	$Panel/VBox/LevelLabel.text = "Fase %d Concluída!" % GameManager.current_level
	$Panel/VBox/ScoreLabel.text = "Pontuação: %d" % GameManager.score
	$Panel/VBox/NextButton.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed() -> void:
	GameManager.next_level()
