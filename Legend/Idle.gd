class_name Idle
extends State

@export var fall_state: State
@export var jump_state: State
@export var move_state: State
@export var backward : State
@export var strafe_left: State
@export var strafe_right: State
@export var attack : State
@export var attack2 : State
@export var ability : State
@export var ability2 : State
@export var dodge : State
@export var died : State
@export var took_damage : State

@export var enemy_death: EnemyDamageSystem

func enter() -> void:
	super()
	# Stop all movement on the X and Z axes when entering idle state
	parent.velocity.x = 0
	parent.velocity.z = 0
	

func process_input(_event: InputEvent) -> State:
	# Check if jump is pressed while on the floor
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed('left') and parent.is_on_floor():
		return strafe_left
	if Input.is_action_just_pressed('right') and parent.is_on_floor():
		return strafe_right
	if Input.is_action_just_pressed('backward') and parent.is_on_floor():
		return backward
	if Input.is_action_just_pressed("attack") and parent.is_on_floor():
		return attack
	if Input.is_action_just_pressed("attack2") and parent.is_on_floor():
		return attack2	
		
	# Check for movement input directly
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	if input_dir.length() > 0:
		return move_state

	return null

func process_physics(delta: float) -> State:
	# Apply gravity
	parent.velocity.y += parent.gravity * delta  # Access gravity from the parent

	# Move the character
	parent.move_and_slide()

	# Transition to fall state if the player is not on the floor
	if !parent.is_on_floor():
		return fall_state
		
	if enemy_death:
		enemy_death.current_health == 0

		return died
	
	if died:
		print("death state active")

	return null

