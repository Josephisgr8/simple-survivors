extends Node
const XpBlueprint: PackedScene = preload("res://Scenes/xp_orb.tscn")

var xpOrbList: Array[Sprite2D]

#var xpOrbCombinationValue := 5
var xpOrbBaseScale := 2.0
var xpOrbCombinationRange := 100
var xpOrbGrowthFactor := 0.05 #how much an xp orb will scale in size per xpValue it is
var xpOrbCombineWaitSecs := 0.2

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
		newXp.resize(xpOrbBaseScale, xpOrbGrowthFactor)
		newXp.global_scale = Vector2(xpOrbBaseScale, xpOrbBaseScale)
		newXp.xpValue = val
		xpOrbList.append(newXp)
		add_child(newXp)
	pass


func _on_xp_orb_combine_wait_timeout() -> void:
	if (xpOrbList.size() <= 1):
		return
	
	var xpOrbHashMap: Dictionary
	var xpOrbCombinationRangeSquared = xpOrbCombinationRange * xpOrbCombinationRange #using this with .distance_squared_to is apparently much more efficient than regular distance and .distance_to()
	
	for orb in xpOrbList:
		var gridCoords: Vector2i = Vector2i(floori(orb.global_position.x/xpOrbCombinationRange), floori(orb.global_position.y/xpOrbCombinationRange))
		#if the hashmap doesn't have the key (grid coordinate vector), then create it and append the current orb to the array
		if !xpOrbHashMap.has(gridCoords):
			xpOrbHashMap[gridCoords] = [] as Array[Sprite2D]
		xpOrbHashMap[gridCoords].append(orb)
			
	#create array to delete orbs after, as we don't want to modify a list mid-loop of that list
	var orbsToDelete: Array[Sprite2D]
	#loop through each grid coord
	for gridCell1 in xpOrbHashMap:
		var currentOrbs: Array[Sprite2D] = xpOrbHashMap[gridCell1]
		#loop through the neigghbouring cells
		for xCoord in range(-1, 2, 1):
			for yCoord in range(-1, 2, 1):
				var gridCell2: Vector2i = gridCell1 + Vector2i(xCoord, yCoord)
				#if there is no cell at these coords, jump out of the currrent loop iteration
				if !xpOrbHashMap.has(gridCell2):
					continue
				var neighborOrbs: Array[Sprite2D] = xpOrbHashMap[gridCell2]
				#loop through orbs in the current cell and check distance between it and orbs in all neighbor cells, by looping through them as well
				for currOrb in currentOrbs:
					for neighborOrb in neighborOrbs:
						#if same orb, ignore
						if currOrb == neighborOrb:
							continue
						#also if either of these orbs are already marked for delete, skip it
						if orbsToDelete.has(currOrb) or orbsToDelete.has(neighborOrb):
							continue
						if currOrb.global_position.distance_squared_to(neighborOrb.global_position) <= xpOrbCombinationRangeSquared:
							currOrb.xpValue += neighborOrb.xpValue
							currOrb.resize(xpOrbBaseScale, xpOrbGrowthFactor)
							orbsToDelete.append(neighborOrb)
							#if the currentOrb is already on the delete list, we don't need to check its neighbors
							break
	for orb in orbsToDelete:
		xpOrbList.erase(orb)
		orb.queue_free()
