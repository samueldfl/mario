extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal collected

func _ready() -> void:
	sprite.play("spin")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.add_score(100)
		collected.emit()
		queue_free()
