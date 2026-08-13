extends Node

var currentState: PlayerState
var player #This makes the class tightly coupled, but that is ok since by nature the PLayerState is dependent and revolves around the Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	player = owner
	#starting state
	_onChangePlayerState(PlayerState_Idle_Alive.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(d: float) -> void:
	currentState.update(d)

func _onChangePlayerState(newState):
	if currentState != null:
		currentState.queue_free()
	currentState = newState
	_connectStateToManager()
	
func move(dir):
	currentState.move(dir)
	
func _connectStateToManager() -> void:
	currentState.changePlayerState.connect(_onChangePlayerState)
	currentState.player = player
