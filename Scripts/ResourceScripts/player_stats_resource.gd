extends Resource
class_name PlayerStatsResource

#HUD signals
signal PlayerStatUpdated

@export var playerBaseStats: Dictionary =  {
	
	"playerSpeed": {"value": 200.0, "name": "Move Speed"},
	"playerCurrentHP": {"value": 0, "name": "Current HP"},
	"playerMaxHP": {"value": 10, "name": "Max HP"},
	"playerInvincibilityDurationSecs": {"value": 1.0, "name": "Invincibility Duration"},
	"playerCurrentXP": {"value": 0, "name": "Current XP"},
	"playerXpToLevel": {"value": 5, "name": "XP To Next Level"},
	"playerXpPickupRange": {"value": 100.0, "name": "XP Pickup Range"},
	"playerCurrentLevel": {"value": 1, "name": "Current Level"},
	"playerAntiSpawnRadius": {"value": 400.0, "name": "Anti-Spawn Radius"},
	"playerXpToLevelMultiplier": {"value": 1.5, "name": "XP To Next Level Multiplier"}
	
}

@export var playerUpgradeableStats: Dictionary = {
	
	"playerMaxHpMultiplier": {"value": 1.00, "name": "Max HP Multiplier", "upgradeMinimum": .1, "upgradeMaximum": .50},
	"playerSpeedMultiplier": {"value": 1.00, "name": "Move Speed Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerDamageMultiplier": {"value": 1.00, "name": "Damage Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerRangeMultiplier": {"value": 1.00, "name": "Range Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerCastSpeedMultiplier": {"value": 1.00, "name": "Cast Speed Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerSizeMultiplier": {"value": 1.00, "name": "Size Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerProjectileSpeedMultiplier": {"value": 1.00, "name": "Projectile Speed Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerXpGainMultiplier": {"value": 1.00, "name": "XP Gain Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20},
	"playerXpPickupRangeMultiplier": {"value": 1.00, "name": "XP Pickup Range Multiplier", "upgradeMinimum": .05, "upgradeMaximum": .20}
	
}

func setStat(name: String, value):
	#exception for when maxHP is upgraded
	if name == "playerMaxHpMultiplier":
		var maxHpIncrease = (value * playerBaseStats["playerMaxHP"]["value"]) -  (playerBaseStats["playerMaxHP"]["value"] * playerUpgradeableStats["playerMaxHpMultiplier"]["value"])
		playerBaseStats["playerCurrentHP"]["value"] = maxHpIncrease + playerBaseStats["playerCurrentHp"]["value"]
	if name in playerBaseStats:
		playerBaseStats[name]["value"] = value
		PlayerStatUpdated.emit()
	elif name in playerUpgradeableStats:
		playerUpgradeableStats[name]["value"] = value
		PlayerStatUpdated.emit()
	
		
func getStat(name: String):
	if name in playerBaseStats:
		return playerBaseStats[name]["value"]
	elif name in playerUpgradeableStats:
		return playerUpgradeableStats[name]["value"]

func setStatAt(statInfo: Dictionary, amount):
	#exception for when maxHP is upgraded
	if statInfo["name"] == "Max HP Multiplier":
		var maxHpIncrease = (amount * playerBaseStats["playerMaxHP"]["value"]) -  (playerBaseStats["playerMaxHP"]["value"] * playerUpgradeableStats["playerMaxHpMultiplier"]["value"])
		playerBaseStats["playerCurrentHP"]["value"] = maxHpIncrease + playerBaseStats["playerCurrentHP"]["value"]
	if statInfo in playerBaseStats.values():
		playerBaseStats[playerBaseStats.find_key(statInfo)]["value"] = amount
		PlayerStatUpdated.emit()
	elif statInfo in playerUpgradeableStats.values():
		playerUpgradeableStats[playerUpgradeableStats.find_key(statInfo)]["value"] = amount
		PlayerStatUpdated.emit()
	
func getStatAt(statInfo: Dictionary):
	if statInfo in playerBaseStats.values():
		return playerBaseStats[playerBaseStats.find_key(statInfo)]["value"]
	elif statInfo in playerUpgradeableStats.values():
		return playerUpgradeableStats[playerUpgradeableStats.find_key(statInfo)]["value"]
		
##player base stats
#@export var speed := 200.0:
	#set(value):
		#speed = value
		#
#@export var maxHP := 10:
	#set(value):
		#maxHP = value
		#HpUpdated.emit()
		#
#@export var currHP := maxHP:
	#set(value):
		#currHP = value
		#HpUpdated.emit()
		#
#@export var invincibilityDurationSecs := 1.0:
	#set(value):
		#invincibilityDurationSecs = value
		#
#@export var currentXP: int = 9:
	#set(value):
		#currentXP = value
		#XpUpdated.emit()
		#
#@export var xpToLevel: int = 10:
	#set(value):
		#xpToLevel = value
		#XpUpdated.emit()
		#
#@export var xpPickupRange := 100.0:
	#set(value):
		#xpPickupRange = value
		#
#@export var currPlayerLevel: int = 1:
	#set(value):
		#currPlayerLevel = value
		#PlayerLevelUpdated.emit()
		#
#@export var antiSpawnRadius: float = 400:
	#set(value):
		#antiSpawnRadius = value



#player stat multipliers
#@export var speedMultiplier := 1.0:
	#set(value):
		#speedMultiplier = value
#
#@export var damageMult := 1.0:
	#set(value):
		#damageMult = value
		#
#@export var rangeMult := 1.0:
	#set(value):
		#rangeMult = value
		#
#@export var castSpeedMult := 1.0:
	#set(value):
		#castSpeedMult = value
		#
#@export var sizeMult := 1.0:
	#set(value):
		#sizeMult = value
		#
#@export var projectileSpeedMult := 1.0:
	#set(value):
		#projectileSpeedMult = value
		#
#@export var xpMult := 1.0:
	#set(value):
		#xpMult = value
		#
#@export var xpToLevelMult := 1.5:
	#set(value):
		#xpToLevelMult = value
		#
#@export var xpPickupRangeMult := 1.0:
	#set(value):
		#xpPickupRangeMult = value
