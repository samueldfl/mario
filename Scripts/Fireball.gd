extends Area2D

const SPEED := 420.0
const HIT_RADIUS := 22.0

var direction := 1

func _ready() -> void:
	get_tree().create_timer(2.5).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta
	_check_enemy_hit()

func _check_enemy_hit() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.is_dead:
			continue
		if global_position.distance_to(enemy.global_position) < HIT_RADIUS:
			enemy.stomp(global_position.x)
			GameManager.add_score(100)
			queue_free()
			return
