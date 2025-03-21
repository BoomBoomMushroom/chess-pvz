extends Sprite2D

@onready var bg_blur: Sprite2D = $Sprite2D
@onready var reload: Label = $Reload

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			onClick()

func onClick():
	get_tree().paused = !get_tree().paused
	bg_blur.visible = get_tree().paused
	reload.visible = get_tree().paused
