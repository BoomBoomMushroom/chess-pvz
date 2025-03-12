extends Sprite2D

# https://docs.godotengine.org/en/4.3/getting_started/step_by_step/signals.html

signal boardSquareClicked

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#print("Left click", name)
			boardSquareClicked.emit(self)

func setHighlighted(isOn):
	var highlighted: Sprite2D = $Highlighted
	highlighted.visible = isOn
