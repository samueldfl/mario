extends Area2D

signal collected

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	rotation += delta * 2.5

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.gain_fire_power()
		GameManager.add_score(50)
		collected.emit()
		queue_free()
