extends CharacterBody2D

const SPEED := 180.0
const JUMP_VELOCITY := -540.0
const GRAVITY := 900.0

var is_dead := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal died

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var dir := Input.get_axis("left", "right")
	velocity.x = dir * SPEED if dir != 0 else move_toward(velocity.x, 0, SPEED * 2)

	if dir != 0:
		sprite.flip_h = dir > 0

	_update_animation()
	var vel_y_before := velocity.y
	move_and_slide()
	_check_enemy_collisions(vel_y_before)

	if position.y > 900:
		die()

func _update_animation() -> void:
	var anim: StringName
	if not is_on_floor():
		anim = &"jump"
	elif abs(velocity.x) > 10:
		anim = &"walk"
	else:
		anim = &"idle"
	if sprite.animation != anim:
		sprite.play(anim)

func _check_enemy_collisions(vel_y_before: float) -> void:
	for i in get_slide_collision_count():
		var col := get_slide_collision(i)
		var body := col.get_collider()
		if not body.is_in_group("enemy"):
			continue
		if body.is_dead:
			continue
		if vel_y_before > 0 and col.get_normal().y < -0.3:
			body.stomp(position.x)
			stomp_bounce()
		else:
			die()
			return

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	sprite.play("die")
	died.emit()
	await get_tree().create_timer(1.5).timeout
	GameManager.lose_life()

func stomp_bounce() -> void:
	velocity.y = JUMP_VELOCITY * 0.5
