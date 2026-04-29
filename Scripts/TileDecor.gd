extends Node

@export var tile_texture: Texture2D
@export var min_width: float = 0.0
@export var max_width: float = 0.0  # 0 = no limit

func _ready() -> void:
	if not tile_texture:
		return
	for body in get_parent().get_children():
		if body is StaticBody2D:
			_try_decorate(body)

func _try_decorate(body: StaticBody2D) -> void:
	var shape_node := body.get_node_or_null("Shape")
	if not shape_node or not (shape_node is CollisionShape2D):
		return
	var shape = shape_node.shape
	if not shape is RectangleShape2D:
		return
	var sw: float = shape.size.x
	if sw < min_width:
		return
	if max_width > 0.0 and sw > max_width:
		return
	for child in body.get_children():
		if child is Polygon2D:
			child.visible = false
	_decorate(body, shape.size)

func _decorate(body: StaticBody2D, size: Vector2) -> void:
	var tex_size := tile_texture.get_size()
	var tile_w := tex_size.x
	var tile_h := minf(tex_size.y, size.y)
	var cols := ceili(size.x / tile_w)
	for i in cols:
		var spr := Sprite2D.new()
		var atlas := AtlasTexture.new()
		atlas.atlas = tile_texture
		atlas.region = Rect2(0, 0, tile_w, tile_h)
		atlas.filter_clip = true
		spr.texture = atlas
		spr.centered = false
		spr.position = Vector2(-size.x / 2.0 + i * tile_w, -size.y / 2.0)
		spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		body.add_child(spr)
