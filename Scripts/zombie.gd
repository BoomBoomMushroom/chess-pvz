extends Node2D

@onready var board_holder: Node2D = %BoardHolder
var v = 0
var isEating = 0
var eatCooldown = Vector2(0, 1) # current cooldown, max cooldown

func _ready() -> void:
	v = 120

func _process(delta: float) -> void:
	position.x -= delta * v
	eatCooldown -= Vector2(delta, 0)
	


func area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	print(parent.name)
	if "Piece" in parent.name:
		v = 0
		isEating = parent


func area_exited(area: Area2D) -> void:
	pass # Replace with function body.
