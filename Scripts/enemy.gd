extends Area2D

var speed = 100.0
var speedMultiplier = 1
var damage = 1
var damageMultiplier = 1
var player: CharacterBody2D

#func _init() -> void:


func _process(delta: float) -> void:
	var playerPos = Vector2(player.position.x, player.position.y)
	var currPos = Vector2(position.x, position.y)
	position = currPos.move_toward(playerPos, speed * speedMultiplier * delta)
	
	#if hitting player
	if overlaps_body(player):
		player.was_hit(self, damage * damageMultiplier)

func updatePlayer(Player):
	player = Player
