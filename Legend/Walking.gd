class_name Walking
extends State

@export var fall_state: State
@export var idle_state: State
@export var jump_state: State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	# Apply gravity
	parent.velocity.y += parent.gravity * delta

	# Get movement input and apply to parent velocity
	var movement = parent.get_movement_input(delta) * parent.move_speed
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	parent.move_and_slide()

	# Transition to idle if no movement input
	if parent.is_on_floor():
		if movement.length() == 0:
			return idle_state

	# Transition to fall if not on floor
	if !parent.is_on_floor():
		return fall_state

	return null

