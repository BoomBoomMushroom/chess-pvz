extends Node2D

@onready var piece_manager: Node2D = %PieceManager
var speed = 0
var damage = 0
var health = 0
var isEating = null
var eatCooldown = Vector2(0, 0.1) # current cooldown, max cooldown
var pieceNameIdentifier = "Piece"
var UUID = ""
var currentTile = Vector2(-1, -1)

var random = RandomNumberGenerator.new()

func setupZombie(setSpeed=0, setDamage=0, setEatCooldown=0, setHealth=0):
	speed = setSpeed
	damage = setDamage
	eatCooldown.y = setEatCooldown
	health = setHealth
	UUID = createUUID(16)
	
	piece_manager.zombies[UUID] = self
	# add this zombie to the piece_manager's list

func _ready() -> void:
	random.randomize()
	setupZombie(260, 1, 1, 0)

func _process(delta: float) -> void:
	if isEating == null:
		position.x -= delta * speed
	
	eatProcess(delta)
	getClosestBoardPos()

func eatProcess(delta):
	eatCooldown -= Vector2(delta, 0)
	if isEating != null and eatCooldown.x <= 0:
		eatCooldown.x = eatCooldown.y
		
		piece_manager.pieceTakeDamage(isEating.position, damage)

func getClosestBoardPos():
	var closestDistance = INF;
	var closestBoardPos = null
	
	var myPos = position - piece_manager.boardHolder.position
	for worldPos in piece_manager.worldToBoardPosCache.keys():
		var distance = myPos.distance_to(worldPos)
		if distance < closestDistance:
			closestBoardPos = piece_manager.worldToBoardPosCache[worldPos]
			closestDistance = distance
	
	currentTile = closestBoardPos
	#print(closestDistance, " ", closestBoardPos)

func area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	#print(parent.name)
	if pieceNameIdentifier in parent.name:
		isEating = parent

func area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	#print("Exited!!!" + parent.name)
	if pieceNameIdentifier in parent.name:
		if isEating.name == parent.name:
			isEating = null

func createUUID(length=16, characters="abcdefghijklmnopqrstuvwxyz1234567890"):
	var newUUID = ""
	for i in range(0, length):
		var charIndex = randi() % len(characters)
		newUUID += characters[charIndex]
	
	return newUUID
