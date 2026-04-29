extends CharacterBody2D

const WALK_SPEED := 60.0
const SHELL_SPEED := 300.0
const GRAVITY := 900.0

enum State { WALKING, SHELL_IDLE, SHELL_MOVING }

var state := State.WALKING
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

	match state:
		State.WALKING:
			velocity.x = direction * WALK_SPEED
			sprite.play("walk")
		State.SHELL_IDLE:
			velocity.x = 0
		State.SHELL_MOVING:
			velocity.x = direction * SHELL_SPEED

	move_and_slide()

	if is_on_wall():
		direction = -direction

	if position.y > 900:
		position = spawn_position
		velocity = Vector2.ZERO
		state = State.WALKING
		direction = -1

func stomp(player_x: float) -> void:
	match state:
		State.WALKING:
			state = State.SHELL_IDLE
			sprite.play("shell")
			velocity.x = 0
			stomped.emit()
			GameManager.add_score(200)
		State.SHELL_IDLE:
			direction = -1 if player_x > position.x else 1
			state = State.SHELL_MOVING
		State.SHELL_MOVING:
			state = State.SHELL_IDLE
			sprite.play("shell")
			velocity.x = 0
