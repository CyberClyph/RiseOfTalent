class_name Falling
extends State

@export var idle_state: State
@export var move_state: State

func process_physics(delta: float) -> State:
	# Apply gravity to the player's velocity
	parent.velocity.y += parent.gravity * delta

	# Get movement input and update horizontal velocity
	var movement = parent.get_movement_input(delta) * parent.move_speed  # Pass delta to the input method
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z

	# Move the character
	parent.move_and_slide()

	# Check if the player has landed on the floor
	if parent.is_on_floor():
		if movement.length() > 0:
			return move_state  # Transition to moving state if there is movement
		else:
			return idle_state  # Transition to idle state if there's no movement

	return null  # Continue in the falling state if not on the floor

