class_name PlayerManager
extends CharacterBody3D

@onready var animations = $AnimationPlayer
@onready var state_machine = $StateMachine
var gravity: float = -0.3 # Positive gravity

@export var speed: float = 1.5 
@export var move_speed: float = 10.0
var JUMP_VELOCITY: float = 3.0  # Increase jump velocity for better jump

func _ready() -> void:
	Global.player = self
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	get_movement_input(delta)  # Pass delta to the input function
	state_machine.process_physics(delta)
	
	# Gravity application
	if not is_on_floor():
		velocity.y += gravity * delta  # Apply gravity to pull the player down
	
	# Jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Set the upward velocity for the jump

	# Apply the movement and slide
	move_and_slide()  # Ensure velocity is applied correctly

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

# Centralized input handling
func get_movement_input(delta: float) -> Vector3:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction.length() > 0:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		# Smoothly reduce speed toward zero
		velocity.x = move_toward(velocity.x, 0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta)

	# Always return a Vector3 value
	return direction

