extends Node

func CalculateMoves(boardPos, pieces, zombies):
	var pieceToMove = null
	for piece in pieces:
		if piece["Position"] == boardPos: pieceToMove = piece
	
	if pieceToMove == null:
		# No piece selected
		return null
	
	var possibleMoves = []
	var pieceType = pieceToMove["PieceType"]
	
	if pieceType == "p": # Pawn
		var ahead = boardPos + Vector2(1, 0)
		var ahead2 = boardPos + Vector2(2, 0)
		var attackUp = boardPos + Vector2(1, -1)
		var attackDown = boardPos + Vector2(1, 1)
		
		if checkSquareOccupants(ahead, pieces, zombies) == null: possibleMoves.append(ahead)
		if checkSquareOccupants(attackUp, pieces, zombies) == "Zombie": possibleMoves.append(attackUp)
		if checkSquareOccupants(attackDown, pieces, zombies) == "Zombie": possibleMoves.append(attackDown)
		if pieceToMove["HasMoved"] == false:
			if checkSquareOccupants(ahead2, pieces, zombies) == null: possibleMoves.append(ahead2)
		
	elif pieceType == "n":
		var a = boardPos + Vector2(-1, 2) # down 2 left 1
		var b = boardPos + Vector2(1, 2) # down 2 rigth 1
		var c = boardPos + Vector2(-2, -1) # up 1 left 2
		var d = boardPos + Vector2(2, -1) # up 1 right 2 
		var e = boardPos + Vector2(-1, -2) # up 2 left 1
		var f = boardPos + Vector2(1, -2) # up 2 right 1
		var g = boardPos + Vector2(-2, 1) # down 1 left 2
		var h = boardPos + Vector2(2, 1) # down 1 right 2
		var aResult = checkSquareOccupants(a, pieces, zombies)
		var bResult = checkSquareOccupants(b, pieces, zombies)
		var cResult = checkSquareOccupants(c, pieces, zombies)
		var dResult = checkSquareOccupants(d, pieces, zombies)
		var eResult = checkSquareOccupants(e, pieces, zombies)
		var fResult = checkSquareOccupants(f, pieces, zombies)
		var gResult = checkSquareOccupants(g, pieces, zombies)
		var hResult = checkSquareOccupants(h, pieces, zombies)
		if aResult == null or aResult == "Zombie": possibleMoves.append(a)
		if bResult == null or bResult == "Zombie": possibleMoves.append(b)
		if cResult == null or cResult == "Zombie": possibleMoves.append(c)
		if dResult == null or dResult == "Zombie": possibleMoves.append(d)
		if eResult == null or eResult == "Zombie": possibleMoves.append(e)
		if fResult == null or fResult == "Zombie": possibleMoves.append(f)
		if gResult == null or gResult == "Zombie": possibleMoves.append(g)
		if hResult == null or hResult == "Zombie": possibleMoves.append(h)
	elif pieceType == "r":
		var rookMoves = getRookMoves(boardPos, pieces, zombies)
		for move in rookMoves:
			possibleMoves.append(move)
	elif pieceType == "b":
		var bishopMoves = getBishopMoves(boardPos, pieces, zombies)
		for move in bishopMoves:
			possibleMoves.append(move)
	elif pieceType == "k":
		var nw = boardPos + Vector2(-1, -1)
		var n = boardPos + Vector2(0, -1)
		var ne = boardPos + Vector2(1, -1)
		var e = boardPos + Vector2(1, 0)
		var se = boardPos + Vector2(1, 1)
		var s = boardPos + Vector2(0, 1)
		var sw = boardPos + Vector2(-1, 1)
		var w = boardPos + Vector2(-1, 0)
		
		if boardPos == Vector2(0, 4) and pieceToMove["HasMoved"] == false:
			var longCastleRookPos = Vector2(0, 0)
			var shortCastleRookPos = Vector2(0, 7)
			
			var canLongCastle = (
				checkSquareOccupants(Vector2(0, 3), pieces, zombies) == null and
				checkSquareOccupants(Vector2(0, 2), pieces, zombies) == null and
				checkSquareOccupants(Vector2(0, 1), pieces, zombies) == null and
				getPieceTypeAt(longCastleRookPos, pieces) == "r")
			var canShortCastle = (
				checkSquareOccupants(Vector2(0, 5), pieces, zombies) == null and
				checkSquareOccupants(Vector2(0, 6), pieces, zombies) == null and
				getPieceTypeAt(shortCastleRookPos, pieces) == "r")
			
			if canLongCastle and getPieceAt(longCastleRookPos, pieces)["HasMoved"] == false:
				possibleMoves.append(Vector2(0, 2))
			
			if canShortCastle and getPieceAt(shortCastleRookPos, pieces)["HasMoved"] == false:
				possibleMoves.append(Vector2(0, 6))
		
		
		var nwResult = checkSquareOccupants(nw, pieces, zombies)
		if nwResult == null or nwResult == "Zombie": possibleMoves.append(nw)
		
		var nResult = checkSquareOccupants(n, pieces, zombies)
		if nResult == null or nResult == "Zombie": possibleMoves.append(n)
		
		var neResult = checkSquareOccupants(ne, pieces, zombies)
		if neResult == null or neResult == "Zombie": possibleMoves.append(ne)
		
		var eResult = checkSquareOccupants(e, pieces, zombies)
		if eResult == null or eResult == "Zombie": possibleMoves.append(e)
		
		var seResult = checkSquareOccupants(se, pieces, zombies)
		if seResult == null or seResult == "Zombie": possibleMoves.append(se)
		
		var sResult = checkSquareOccupants(s, pieces, zombies)
		if sResult == null or sResult == "Zombie": possibleMoves.append(s)
		
		var swResult = checkSquareOccupants(sw, pieces, zombies)
		if swResult == null or swResult == "Zombie": possibleMoves.append(sw)
		
		var wResult = checkSquareOccupants(w, pieces, zombies)
		if wResult == null or wResult == "Zombie": possibleMoves.append(w)
	elif pieceType == "q":
		# Combine Rook and Bishop moves for the queen
		var rookMoves = getRookMoves(boardPos, pieces, zombies)
		for move in rookMoves:
			possibleMoves.append(move)
			
		var bishopMoves = getBishopMoves(boardPos, pieces, zombies)
		for move in bishopMoves:
			possibleMoves.append(move)
	
	possibleMoves = possibleMoves.filter(isPosOnBoard)
	
	return possibleMoves

func isPosOnBoard(boardPos) -> bool:
	if boardPos.x < 0 or boardPos.y < 0: return false
	# TODO: Make these global vars or remember to update this if I want to change board size?
	if boardPos.y >= Globals.boardHeight: return false
	if boardPos.x >= Globals.boardWidth: return false
	
	return true

func checkSquareOccupants(boardPos, pieces, zombies):
	var occupants = null
	for piece in pieces:
		if piece["Position"] == boardPos:
			occupants = "Piece"
			break
	
	for zombie in zombies.values():
		if occupants != null: break # Have "Piece" take priority (we don't want to take our own piece)
		if zombie.currentTile == boardPos:
			occupants = "Zombie"
			break
	
	return occupants

func getPieceTypeAt(boardPos, pieces):
	var piece = getPieceAt(boardPos, pieces)
	if piece: return piece["PieceType"]
	return null

func getPieceAt(boardPos, pieces):
	for piece in pieces:
		if piece["Position"] == boardPos:
			return piece
	
	return null

func getRookMoves(boardPos, pieces, zombies):
	var possibleMoves = []
	var offset = 1
	var doUp = true
	var doDown = true
	var doLeft = true
	var doRight = true
	
	while true:
		var up = boardPos + Vector2(0, -offset)
		var down = boardPos + Vector2(0, offset)
		var left = boardPos + Vector2(-offset, 0)
		var right = boardPos + Vector2(offset, 0)
		var upResult = checkSquareOccupants(up, pieces, zombies)
		var downResult = checkSquareOccupants(down, pieces, zombies)
		var leftResult = checkSquareOccupants(left, pieces, zombies)
		var rightResult = checkSquareOccupants(right, pieces, zombies)
		
		if doUp: doUp = isPosOnBoard(up)
		if doDown: doDown = isPosOnBoard(down)
		if doLeft: doLeft = isPosOnBoard(left)
		if doRight: doRight = isPosOnBoard(right)
		
		if (upResult == null or upResult == "Zombie") and doUp: possibleMoves.append(up)
		if upResult == "Piece" or upResult == "Zombie": doUp = false
		
		if (downResult == null or downResult == "Zombie") and doDown: possibleMoves.append(down)
		if downResult == "Piece" or downResult == "Zombie": doDown = false
		
		if (leftResult == null or leftResult == "Zombie") and doLeft: possibleMoves.append(left)
		if leftResult == "Piece" or leftResult == "Zombie": doLeft = false
		
		if (rightResult == null or rightResult == "Zombie") and doRight: possibleMoves.append(right)
		if rightResult == "Piece" or rightResult == "Zombie": doRight = false
		
		if doUp == false and doDown == false and doLeft == false and doRight == false:
			break
		
		offset += 1
	
	return possibleMoves

func getBishopMoves(boardPos, pieces, zombies):
	var possibleMoves = []
	var offset = 1
	var doUpLeft = true
	var doUpRight = true
	var doDownLeft = true
	var doDownRight = true
	
	while true:
		var upLeft = boardPos + Vector2(-offset, -offset)
		var upRight = boardPos + Vector2(offset, -offset)
		var downLeft = boardPos + Vector2(-offset, offset)
		var downRight = boardPos + Vector2(offset, offset)
		var upLeftResult = checkSquareOccupants(upLeft, pieces, zombies)
		var upRightResult = checkSquareOccupants(upRight, pieces, zombies)
		var downLeftResult = checkSquareOccupants(downLeft, pieces, zombies)
		var downRightResult = checkSquareOccupants(downRight, pieces, zombies)
		
		if doUpLeft: doUpLeft = isPosOnBoard(upLeft)
		if doUpRight: doUpRight = isPosOnBoard(upRight)
		if doDownLeft: doDownLeft = isPosOnBoard(downLeft)
		if doDownRight: doDownRight = isPosOnBoard(downRight)
		
		if (upLeftResult == null or upLeftResult == "Zombie") and doUpLeft: possibleMoves.append(upLeft)
		if upLeftResult == "Piece" or upLeftResult == "Zombie": doUpLeft = false
		
		if (upRightResult == null or upRightResult == "Zombie") and doUpRight: possibleMoves.append(upRight)
		if upRightResult == "Piece" or upRightResult == "Zombie": doUpRight = false
		
		if (downLeftResult == null or downLeftResult == "Zombie") and doDownLeft: possibleMoves.append(downLeft)
		if downLeftResult == "Piece" or downLeftResult == "Zombie": doDownLeft = false
		
		if (downRightResult == null or downRightResult == "Zombie") and doDownRight: possibleMoves.append(downRight)
		if downRightResult == "Piece" or downRightResult == "Zombie": doDownRight = false
		
		if doUpLeft == false and doUpRight == false and doDownLeft == false and doDownRight == false:
			break
		
		offset += 1
	return possibleMoves
