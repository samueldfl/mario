extends CharacterBody2D

const SPEED := 60.0
const GRAVITY := 900.0

var direction := -1
var is_dead := false
var spawn_position: Vector2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal stomped

func _ready() -> void:
	add_to_group("enemy")
	spawn_position = position

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	velocity.y += GRAVITY * delta
	velocity.x = direction * SPEED
	move_and_slide()

	if is_on_wall():
		direction = -direction
		sprite.flip_h = direction > 0

	if position.y > 900:
		position = spawn_position
		velocity = Vector2.ZERO
		direction = -1

func stomp(_player_x: float = 0.0) -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	sprite.play("flat")
	stomped.emit()
	GameManager.add_score(100)
	await get_tree().create_timer(0.5).timeout
	queue_free()
