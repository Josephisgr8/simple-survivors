class_name PlayerLevelUpMenuOption

extends Button

#signals
signal ButtonPressed


var statToUpgrade: Dictionary
var amountToIncrease

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setValues(stat: Dictionary, amt):
	statToUpgrade = stat
	amountToIncrease = amt

func _on_pressed() -> void:
	ButtonPressed.emit(statToUpgrade, amountToIncrease)
	pass # Replace with function body.
