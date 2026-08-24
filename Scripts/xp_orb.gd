extends Sprite2D
class_name XP_Orb

#signals
signal DeleteOrb


var xpValue: int #This is the total xp value of the orb, and is used to increase the size of the orb.
var magentizeTarget: Vector2  #Decided to go with a simple variable instead of a State class. This is because, the xp orb manager controls movement for the xp orb,
								#so the xp orb state would only act as a flag to let the manager know that the orb is magnetized.

func resize(baseScale, addScale) -> void:
	var totScale: float = (xpValue * addScale) + baseScale
	global_scale = Vector2(totScale, totScale)
