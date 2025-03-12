extends Node2D

var pieceRoute = "res://Sprites/Pieces/"

var color = "w"
var pieces = []
var piecePrefab = preload("res://Scenes/piece.tscn")
var cooldownPrefab = preload("res://Scenes/cooldown.tscn")
@onready var boardHolder = %BoardHolder

var boardToWorldPosCache = {}
var worldToBoardPosCache = {}

var selectedSquare = Vector2(-1,-1)
var coolDownPieces = {}
var moveCooldown = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in boardHolder.get_children():
		var childBoardPos = child.position / Vector2(64, 64)
		var childRelativeWorldPos = child.position
		var childWorldPos = boardHolder.position + childRelativeWorldPos
		
		boardToWorldPosCache[childBoardPos] = childWorldPos
		worldToBoardPosCache[childRelativeWorldPos] = childBoardPos
		
		if child.has_signal("boardSquareClicked"):
			child.connect("boardSquareClicked", squareClicked)
	
	startPiecePositions()
	updatePiecesPosition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	"""
	{
		"time": 0,
		"object": null
	}
	"""
	
	for key in coolDownPieces.keys():
		coolDownPieces[key]["time"] -= delta # run down the cooldown time
		coolDownPieces[key]["object"].get_node("CircleProgress").value = (
			coolDownPieces[key]["time"] / coolDownPieces[key]["maxTime"]) * 100
		
		if coolDownPieces[key]["time"] <= 0:
			coolDownPieces[key]["object"].queue_free()
			coolDownPieces.erase(key)
	

func deselectSquare():
	selectedSquare = Vector2(-1, -1)
	updateHighligthedSquares([])

func makeBoardCooldown(boardPos):
	var boardObject = null
	for boardPiece in boardHolder.get_children():
		if worldToBoardPosCache[boardPiece.position] == boardPos:
			boardObject = boardPiece
	
	var cooldownObj = cooldownPrefab.instantiate()
	cooldownObj.position = boardObject.position + boardHolder.position
	cooldownObj.scale = boardObject.scale
	
	add_child(cooldownObj)
	
	coolDownPieces[boardPos] = {
		"maxTime": moveCooldown,
		"time": moveCooldown,
		"object": cooldownObj
	}

func squareClicked(square):
	var boardPos = worldToBoardPosCache[square.position]
	
	if boardPos == selectedSquare:
		return deselectSquare()
	
	if boardPos in coolDownPieces.keys():
		return deselectSquare()
	
	# Make a move
	if selectedSquare != Vector2(-1, -1):
		var selectedMoves = CalculateMoves.CalculateMoves(selectedSquare, pieces)
		if boardPos in selectedMoves:
			for piece in pieces:
				if piece["Position"] == selectedSquare:
					piece["Position"] = boardPos
					piece["HasMoved"] = true
					
					makeBoardCooldown(boardPos)
					doKingCastleMoveRookCheck(piece, boardPos)
					
					updatePiecesPosition()
					return deselectSquare()
	
	selectedSquare = boardPos
	var realMoves = CalculateMoves.CalculateMoves(boardPos, pieces)
	if realMoves == null:
		deselectSquare()
		return
	
	square.setHighlighted(true)
	updateHighligthedSquares(realMoves)

func doKingCastleMoveRookCheck(piece, boardPos):
	var pieceType = piece["PieceType"]
	if pieceType in ["k", "r"]: piece["CanCastle"] = false
	if pieceType == "k":
		if boardPos == Vector2(0, 2): # Long Castle
			for findRook in pieces:
				if findRook["Position"] == Vector2(0, 0):
					findRook["Position"] = Vector2(0, 3)
					makeBoardCooldown(findRook["Position"])
		if boardPos == Vector2(0, 6): # Short Castle
			for findRook in pieces:
				if findRook["Position"] == Vector2(0, 7):
					findRook["Position"] = Vector2(0, 5)
					makeBoardCooldown(findRook["Position"])

func updateHighligthedSquares(squares):
	for child in boardHolder.get_children():
		var toBeHighlighted = false
		for square in squares:
			if child.position + boardHolder.position == boardToWorldPosCache[square]:
				toBeHighlighted = true
		
		child.setHighlighted(toBeHighlighted)

func createPiece(type="p", pos=Vector2(0,0)):
	return {
		"Position": pos, "PieceType": type, "Object": null,
		"HasMoved": false, "CanCastle": true,
		"MaxHealth": 100, "Health": 100,
	}

func startPiecePositions():
	pieces = [
		createPiece("r", Vector2(0,0)),
		createPiece("n", Vector2(0,1)),
		createPiece("b", Vector2(0,2)),
		createPiece("q", Vector2(0,3)),
		createPiece("k", Vector2(0,4)),
		createPiece("b", Vector2(0,5)),
		createPiece("n", Vector2(0,6)),
		createPiece("r", Vector2(0,7)),
		
		createPiece("p", Vector2(1,0)),
		createPiece("p", Vector2(1,1)),
		createPiece("p", Vector2(1,2)),
		createPiece("p", Vector2(1,3)),
		createPiece("p", Vector2(1,4)),
		createPiece("p", Vector2(1,5)),
		createPiece("p", Vector2(1,6)),
		createPiece("p", Vector2(1,7)),
	]

func updatePiecesPosition():
	var i = 0
	for piece in pieces:
		i += 1
		if piece["Object"] == null:
			var pieceObject = piecePrefab.instantiate()
			var texturePath = pieceRoute + color + piece["PieceType"] + ".png"
			pieceObject.set_texture(load(texturePath))
			pieceObject.name = "Piece_" + piece["PieceType"] + "_" + str(i)
			pieceObject.get_node("HealthBar").max_value = piece["MaxHealth"]
			pieceObject.get_node("HealthBar").value = piece["Health"]
			add_child(pieceObject)
			piece["Object"] = pieceObject
		
		piece["Object"].position = boardToWorldPosition(piece["Position"])

func boardToWorldPosition(boardPosition) -> Vector2:
	if boardPosition in boardToWorldPosCache:
		return boardToWorldPosCache[boardPosition]
	
	return Vector2(0,0)

var pieceTakeDamage
