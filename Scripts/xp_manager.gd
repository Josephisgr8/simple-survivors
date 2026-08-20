extends Node
class_name XP_Manager

const XpBlueprint: PackedScene = preload("res://Scenes/xp_orb.tscn")

#signals
signal XP_Absorbed



var xpOrbList: Array[Sprite2D]
var xpOrbsToDelete: Array[Sprite2D]


var playerPosition: Vector2 # It ends up being better for this node to hold this data, since orbs need it for the magnetized effect
var playerPickupRange: float

#var xpOrbCombinationValue := 5
var xpOrbBaseScale := 2.0
var xpOrbCombinationRange := 100
var xpOrbGrowthFactor := 0.05 #how much an xp orb will scale in size per xpValue it is
var xpOrbCombineWaitSecs := 2.0

@onready var xp_orb_combine_wait: Timer = $"XP Orb Combine Wait"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xp_orb_combine_wait.wait_time = xpOrbCombineWaitSecs
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_removeXpOrbs()
	getXpOrbsInRange(playerPosition, playerPickupRange)
	pass

func spawnXP(pos, val):
	_createXpOrb(pos, val)
	

func _createXpOrb(pos, val):
	for i in range(val):
		var newXp: XP_Orb = XpBlueprint.instantiate()
		newXp.global_position = pos
		newXp.resize(xpOrbBaseScale, xpOrbGrowthFactor)
		newXp.global_scale = Vector2(xpOrbBaseScale, xpOrbBaseScale)
		newXp.xpValue = val
		newXp.DeleteOrb.connect(func(orb: XP_Orb): xpOrbsToDelete.append(orb)) # lambda function, very fancy. Way to create quick functions on the fly, usually for a specific call.
		xpOrbList.append(newXp)
		add_child(newXp)
	pass

func _removeXpOrbs():
	for orb in xpOrbsToDelete:
		orb.queue_free()
	xpOrbList = xpOrbList.filter(func(orb: XP_Orb): return is_instance_valid(orb) and not orb.is_queued_for_deletion())
	xpOrbsToDelete.clear()
		#xpOrbList.erase(orb) #CAN CAUSE BOTTLENECK IF MANY ORBS PRESENT. SWITCH TO HASHMAP DELETION IF NECESSARY.
		#xpOrbsToDelete.erase(orb) #CAN CAUSE BOTTLENECK IF MANY ORBS PRESENT. SWITCH TO HASHMAP DELETION IF NECESSARY.
		#if is_instance_valid(orb):
			#orb.queue_free()
		
func _mergeOrbs(orb1: XP_Orb, orb2: XP_Orb):
	orb1.xpValue += orb2.xpValue
	orb1.resize(xpOrbBaseScale, xpOrbGrowthFactor)
	xpOrbsToDelete.append(orb2)

func getUpdatedXpOrbHashMap(cellSize: float) -> Dictionary:
	var hashMap: Dictionary
	for orb in xpOrbList:
		#if the orb is already suppose to be gone, skip it
		if !is_instance_valid(orb):
			continue
		var cell: Vector2i = Vector2i(floori(orb.global_position.x/cellSize), floori(orb.global_position.y/cellSize))
		#if the hashmap doesn't have the key (grid coordinate vector), then create it and append the current orb to the array
		if !hashMap.has(cell):
			hashMap[cell] = [] as Array[Sprite2D]
		hashMap[cell].append(orb)
	return hashMap


func _on_xp_orb_combine_wait_timeout() -> void:
	if (xpOrbList.size() <= 1):
		return
	
	var xpOrbHashMap: Dictionary = getUpdatedXpOrbHashMap(xpOrbCombinationRange)
	var xpOrbCombinationRangeSquared = xpOrbCombinationRange * xpOrbCombinationRange #using this with .distance_squared_to is apparently much more efficient than regular distance and .distance_to()

	#loop through each grid coord
	for gridCell1 in xpOrbHashMap:
		var currentOrbs: Array[Sprite2D] = xpOrbHashMap[gridCell1]
		#loop through the neighboring cells
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
						if xpOrbsToDelete.has(currOrb) or xpOrbsToDelete.has(neighborOrb):
							continue
						if currOrb.global_position.distance_squared_to(neighborOrb.global_position) <= xpOrbCombinationRangeSquared:
							_mergeOrbs(currOrb, neighborOrb)
							#if the currentOrb is already on the delete list, we don't need to check its neighbors
							break


func getXpOrbsInRange(pos: Vector2, rng: float) -> void:
	var rangeSquared = rng * rng #for performance reasons
	
	#determine the cell range to check
	var cellBoundLower: Vector2i = Vector2i(floori((pos.x - rng)/xpOrbCombinationRange), floori((pos.y - rng)/xpOrbCombinationRange))
	var cellBoundUpper: Vector2i = Vector2i(floori((pos.x + rng)/xpOrbCombinationRange), floori((pos.y + rng)/xpOrbCombinationRange))
	
	#get updated hashmap
	var hashMap: Dictionary = getUpdatedXpOrbHashMap(xpOrbCombinationRange)
	
	#loop through nearby cells and check each orb if they are in range
	for xCoord in range(cellBoundLower.x, cellBoundUpper.x + 1):
		for yCoord in range(cellBoundLower.y, cellBoundUpper.y + 1):
			var currCell: Vector2i = Vector2i(xCoord,yCoord)
			#check if the current cell exists in the hashmap
			if !hashMap.has(currCell):
				continue
			for orb: XP_Orb in hashMap[currCell]:
				if orb.global_position.distance_squared_to(pos) <= rangeSquared:
					#if xp is in range
					_awardXp(orb)
					orb.deleteOrb()
	#THIS FUNCTION WILL SEND THE ORBS TO MAGNET MODE, CONTROLLED BY THIS MANAGER. SINCE IT HAS CONTROLL, IT KNOWS WHEN THE XP REACHES THE PLAYER. AT THAT POINT IT WILL DELETE THEE XP, 
	# AND EMIT A SIGNAL TO LET THE PLAYER KNOW HOW MUCH RAW XP THEY GOT
	#ONCE THE ORBS REACH THE PLAYER, DO THIS^^^ THEN DELETE THEM
	

func _awardXp(orb: XP_Orb):
	XP_Absorbed.emit(orb.xpValue)


func updatePlayerInfo(pos: Vector2, rng: float):
	playerPosition = pos
	playerPickupRange = rng
