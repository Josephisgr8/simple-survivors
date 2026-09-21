extends Node
class_name AllPlayerWeapons


@export var playerWeaponManagerList: Array[PlayerWeaponManagerBase] = [
BoomerangManager.new(),
MissileManager.new(),
PulseManager.new(),
RubberBallManager.new()
]

func getRandomWeapon(excludes: Array[PlayerWeaponManagerBase] = []) -> PlayerWeaponManagerBase:
	var temp = playerWeaponManagerList
	#print("-----------")
	#print("before filter: ", temp)
	temp = temp.filter(func(val): return !excludes.has(val))
	#print("after filter: ",temp)
	#print("------------")
	if temp.is_empty():
		return null
	else:
		return temp.pick_random()
	
