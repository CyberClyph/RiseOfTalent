extends State


@export var died : State
@export var idle : State
		
func enter() -> void:
		print('enemy died')

func exit() -> void:
	pass
	
func process_frame(delta: float) -> State:
	# Check if the animation is currently playing
	if not parent.animations.is_playing():
		# Transition to the desired state after the animation ends
		return idle  # or return the next state here, if needed

	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
