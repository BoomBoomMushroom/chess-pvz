extends Node2D

var lightColor = Color8(214, 129, 201)
var darkColor = Color8(173, 78, 159)
var hightlightColor = Color8(255, 255, 0, 128)
var highlight = preload("res://Scenes/board_square.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		var childPos = child.position / Vector2(64, 64)
		var isLight = int(childPos.x + childPos.y) % 2 == 0
		child.modulate = lightColor if isLight else darkColor
		
		var highlighted = highlight.instantiate()
		highlighted.name = "Highlighted"
		child.add_child(highlighted)
		
		child.get_node("Highlighted").modulate = hightlightColor
		child.get_node("Highlighted").visible = false
		child.get_node("Highlighted").position = child.position + child.get_parent().position
		child.get_node("Highlighted").scale = child.scale
		child.get_node("Highlighted").set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
