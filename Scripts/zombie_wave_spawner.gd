extends Node2D

const ZOMBIE_PREFAB = preload("res://Scenes/zombie.tscn")
var tileTopY = -224
var xSpawnMin = 592
@onready var piece_manager: Node2D = %PieceManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	summonWave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func summonWave():
	var numberOfZombies = randi_range(3, 10)
	
	for i in range(numberOfZombies):
		var newZombie = ZOMBIE_PREFAB.instantiate()
		var zombieType = Globals.zombieStats.keys().pick_random()
		add_child(newZombie)
		newZombie.global_position = Vector2(getRandomXPosition(), getRandomYPosition())
		
		newZombie.setupZombieFromName(zombieType)

func getRandomXPosition():
	return xSpawnMin + randf_range(0, 64 * 8)

func getRandomYPosition():
	var row = randi_range(0, Globals.boardHeight-1)
	var y = tileTopY + (row * 64)
	return y
