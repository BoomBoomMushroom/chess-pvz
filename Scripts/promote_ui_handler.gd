extends Node2D

@onready var piece_manager: Node2D = %PieceManager
@onready var queenHighlight: Sprite2D = $Wq/Highlight
@onready var rookHighlight: Sprite2D = $Wr/Highlight
@onready var bishopHighlight: Sprite2D = $Wb/Highlight
@onready var knightHighlight: Sprite2D = $Wn/Highlight

var pieceLetterToNode = {} # init in ready b/c if not they're all <null>

func _ready() -> void:
	pieceLetterToNode = {
		"q": queenHighlight,
		"r": rookHighlight,
		"b": bishopHighlight,
		"n": knightHighlight,
	}
	updateHighlights()

func updateHighlights():
	queenHighlight.visible = false
	rookHighlight.visible = false
	bishopHighlight.visible = false
	knightHighlight.visible = false
	
	pieceLetterToNode[piece_manager.pawnPromoteTo].visible = true

func wasLeftClick(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			return true
	return false

func QueenInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wasLeftClick(event):
		#print("Queen Clicked")
		piece_manager.pawnPromoteTo = "q"
		updateHighlights()

func RookInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wasLeftClick(event):
		#print("Rook Clicked")
		piece_manager.pawnPromoteTo = "r"
		updateHighlights()

func BishopInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wasLeftClick(event):
		#print("Bishop Clicked")
		piece_manager.pawnPromoteTo = "b"
		updateHighlights()

func KnightInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wasLeftClick(event):
		#print("Knight Clicked")
		piece_manager.pawnPromoteTo = "n"
		updateHighlights()
