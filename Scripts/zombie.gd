extends Node2D

var piece_manager: Node2D = null
var speed = 0
var damage = 0
var health = 0
var isEating = {}
var eatCooldown = Vector2(0, 1) # current cooldown, max cooldown
var pieceNameIdentifier = "Piece"
var UUID = ""
var currentTile = Vector2(-1, -1)
var isDead = false
var removeTime = INF

var random = RandomNumberGenerator.new()

func setupZombie(setSpeed=0, setDamage=0, setEatCooldown=0, setHealth=0):
	speed = setSpeed
	damage = setDamage
	eatCooldown.y = setEatCooldown
	health = setHealth
	UUID = createUUID(16)
	
	piece_manager.zombies[UUID] = self

func setupZombieFromName(zombieNameType):
	var stats = Globals.zombieStats[zombieNameType]
	setupZombie(stats[0], stats[1], stats[2], stats[3])

func _ready() -> void:
	piece_manager = get_node("/root/Main/PieceManager")
	random.randomize()
	# One of theses needs to be called from the creator
	#setupZombieFromName("Normal")
	#setupZombie(260, 1, 1, 0)

func _process(delta: float) -> void:
	if removeTime <= 0: queue_free()
	
	if isDead:
		removeTime -= delta
		currentTile = Vector2(-1, -1)
		return
	
	if len(isEating.values()) == 0:
		position.x -= delta * speed
	
	eatProcess(delta)
	getClosestBoardPos()

func kill():
	piece_manager.zombies.erase(UUID)
	isDead = true
	removeTime = 2 # in seconds
	# Do other stuff like play animations and destroy object

func eatProcess(delta):
	eatCooldown -= Vector2(delta, 0)
	if len(isEating.values()) != 0 and eatCooldown.x <= 0:
		eatCooldown.x = eatCooldown.y
		
		piece_manager.pieceTakeDamage(isEating.values()[0].position, damage)

func getClosestBoardPos():
	var closestDistance = INF;
	var closestBoardPos = null
	
	var myPos = self.global_position - piece_manager.boardHolder.position
	for worldPos in piece_manager.worldToBoardPosCache.keys():
		var distance = myPos.distance_to(worldPos)
		if distance < closestDistance:
			closestBoardPos = piece_manager.worldToBoardPosCache[worldPos]
			closestDistance = distance
	
	currentTile = closestBoardPos

func area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	#print(parent.name)
	if pieceNameIdentifier in parent.name:
		var eatingUUID = createUUID(16)
		isEating[eatingUUID] = parent

func area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	#print("Exited!!!" + parent.name)
	if pieceNameIdentifier in parent.name:
		for item in isEating.values():
			if item.name == parent.name:
				isEating.erase( isEating.find_key(item) )


func createUUID(length=16, characters="abcdefghijklmnopqrstuvwxyz1234567890"):
	var newUUID = ""
	for i in range(0, length):
		var charIndex = randi() % len(characters)
		newUUID += characters[charIndex]
	
	return newUUID
