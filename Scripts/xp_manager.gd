extends Node
const XpBlueprint: PackedScene = preload("res://Scenes/xp_orb.tscn")

var xpOrbList: Array[Sprite2D]

var xpOrbCombinationValue := 5
var xpOrbCombinationRange := 50
var xpOrbCombineWaitSecs := 1.0

@onready var xp_orb_combine_wait: Timer = $"XP Orb Combine Wait"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xp_orb_combine_wait.wait_time = xpOrbCombineWaitSecs
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnXP(pos, val):
	_createXpOrb(pos, val)
	

func _createXpOrb(pos, val):
	for i in range(val):
		var newXp = XpBlueprint.instantiate()
		newXp.global_position = pos
		#newXp.value = 1
		xpOrbList.append(newXp)
		add_child(newXp)
	pass

#plan to have timer that will combine all xporbs that are nearby evertime it goes off
