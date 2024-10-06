extends Node
class_name StateMachine

@export var CURRENT_STATE: State  # Current state of the state machine
var states: Dictionary = {}  # Dictionary to hold states

func _ready():
	# Register all child states
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transition.connect(on_child_transition)
	
	# Enter the initial state
	if CURRENT_STATE:
		CURRENT_STATE.enter()
	else:
		push_error("No initial state assigned to CURRENT_STATE.")

# Called every frame
func _process(delta: float):
	if CURRENT_STATE:
		CURRENT_STATE.update(delta)  # Call update on current state

# Called every physics frame
func _physics_process(delta: float):
	if CURRENT_STATE:
		CURRENT_STATE.physics_update(delta)  # Call physics update on current state

# Signal handler for state transitions
func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state and new_state != CURRENT_STATE:
		CURRENT_STATE.exit()  # Exit current state
		new_state.enter()  # Enter new state
		CURRENT_STATE = new_state  # Update current state
	else:
		push_warning("State does not exist: " + new_state_name)  # Log a warning if the state is not found


