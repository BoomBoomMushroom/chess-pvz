extends Node

"""
Zombies:
- Normal, speed ?, damage 1, eat cooldown 1s
- Strong, speed ?, damage 3, eat cooldown 1s (Does more damage)
- Explosive Zombie, speed ?, damage 1, eat cooldown 1, (It blows up when it eats something or it dies)
- Summoner Zombie, speed ?, damage 1, eat cooldown 1s (It will at random summon n (5?) random zombes)
- Invisible Zomibe, speed ?, damage 1, eat cooldown 1s (Either really transparent or fully invisible)
- Jumping Zombie, speed ?, damage 1, eat cooldown 1s (Jumps over one piece and then breaks their legs)
"""

# 60 speed = 1 square per second
var ONE_SQUARE_PER_SECOND = 60

# Speed, damage, eat cooldown, health (health unused)
var zombieStats = {
	"Normal": [ONE_SQUARE_PER_SECOND, 1, 1, 0],
	"Strong": [ONE_SQUARE_PER_SECOND, 3, 1, 0],
	"Explosive": [ONE_SQUARE_PER_SECOND, 1, 1, 0],
	"Summoner": [ONE_SQUARE_PER_SECOND, 1, 1, 0],
	"Invisible": [ONE_SQUARE_PER_SECOND/3, 1, 1, 0],
	"Jumping": [ONE_SQUARE_PER_SECOND, 1, 1, 0],
}

var boardWidth = 16
var boardHeight = 8
