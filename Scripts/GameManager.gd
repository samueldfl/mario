extends Node

var current_level: int = 1
var score: int = 0
var lives: int = 3

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

func goto_start() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartScreen.tscn")

func goto_level(level: int) -> void:
	current_level = level
	get_tree().change_scene_to_file("res://Scenes/Level%d.tscn" % level)

func next_level() -> void:
	if current_level < 4:
		goto_level(current_level + 1)
	else:
		goto_start()

func level_complete() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelComplete.tscn")

func game_over() -> void:
	lives = 3
	score = 0
	current_level = 1
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over()
	else:
		goto_level(current_level)
