class_name PlayerLevelUpMenu

extends CanvasLayer

#signals
signal LevelUpChoiceSelected

const PLAYER_LEVEL_UP_MENU_OPTION = preload("uid://cquqiq7l3tokj")

var playerStats: PlayerStatsResource
var numOfOptions: int = 3
#var optionContainer: VBoxContainer

# Called when the node enters the scene tree for the first time.

func _init() -> void:
	
	pass

func addOptions() -> void:
	var playerStatArray: Array = playerStats.playerUpgradeableStats.values()
	var optionContainer: VBoxContainer = $VBoxContainer
	_addOptionsToContainer(optionContainer, playerStatArray, numOfOptions)
	#add_child(optionContainer)

func _addOptionsToContainer(container: VBoxContainer, statList: Array, optionAmount: int) -> void:
	for i in range(optionAmount):
		var randStat = statList.pick_random()
		statList.erase(randStat)
		var upgradeValueType = typeof(randStat["value"])
		var upgradeValue = snappedf(randf_range(randStat["upgradeMinimum"], randStat["upgradeMaximum"]), 0.01)
		upgradeValue = type_convert(upgradeValue, upgradeValueType)
		
		var option: PlayerLevelUpMenuOption = PLAYER_LEVEL_UP_MENU_OPTION.instantiate()
		option.setValues(randStat, upgradeValue)
		option.ButtonPressed.connect(_onButtonPressed)
		option.text = str("Upgrade ", randStat["name"], " by ", upgradeValue * 100, "%")
		container.add_child(option)

#func _createContainer() -> VBoxContainer:
#
	#return cont

func _onButtonPressed(stat: Dictionary, amount):
	playerStats.setStatAt(stat, playerStats.getStatAt(stat) + amount)
	LevelUpChoiceSelected.emit()
	queue_free()
	#for child in get_children():
		#child.queue_free() #This whole node gets queued free, but this is to ensure multiple upgrades aren't selected quickly.
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
