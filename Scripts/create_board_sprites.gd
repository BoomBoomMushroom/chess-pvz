extends Node2D

var boardTile = preload("res://Scenes/board_square.tscn")
var boardHeight = 8
var boardWidth = 16
var boardTileSize = 16
var scaleTo = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	for y in range(0, boardHeight):
		for x in range(0, boardWidth):
			var tile = boardTile.instantiate()
			var color = Color(0,0,0) if (x+y)%2 == 0 else Color(1, 1, 1)
			tile.modulate = color
			
			tile.position = Vector2(x, y) * boardTileSize * scaleTo
			tile.get_child(0).position = Vector2(x, y) * boardTileSize * scaleTo
			
			tile.scale = Vector2(scaleTo, scaleTo)
			tile.get_child(0).scale = Vector2(scaleTo, scaleTo)
			
			add_child(tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
