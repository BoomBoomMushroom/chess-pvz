extends Node2D

@onready var boardHolder = %BoardHolder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in boardHolder.get_children():
		if child.has_signal("boardSquareClicked"):
			child.connect("boardSquareClicked", squareClicked)

func squareClicked(square):
	
	
	pass
