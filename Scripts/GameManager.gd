extends Node

const GROUND_TILE_REGION := Rect2(0, 96, 96, 96)
const TILE_DISPLAY_PX := 48.0

var current_level: int = 1
var score: int = 0
var lives: int = 3

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

func tile_rect(parent: Node2D, size: Vector2, tile_px: float = TILE_DISPLAY_PX) -> void:
	var tex: Texture2D = load("res://Assets/Mario/mariotile.png")
	var cols := int(ceil(size.x / tile_px))
	var rows := int(ceil(size.y / tile_px))
	var origin := -size * 0.5
	var scale_factor := tile_px / GROUND_TILE_REGION.size.x
	for cy in range(rows):
		for cx in range(cols):
			var s := Sprite2D.new()
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = GROUND_TILE_REGION
			at.filter_clip = true
			s.texture = at
			s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			s.scale = Vector2(scale_factor, scale_factor)
			s.position = origin + Vector2(cx * tile_px + tile_px * 0.5, cy * tile_px + tile_px * 0.5)
			parent.add_child(s)

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
