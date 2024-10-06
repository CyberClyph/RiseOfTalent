extends CharacterBody3D
class_name PlayerController

# Movement parameters
@export var ACCELERATION: float = 0.1  # Rate of acceleration
@export var DECELERATION: float = 0.25  # Rate of deceleration
@export var SPEED_DEFAULT: float = 5.0  # Default movement speed
@export var SPEED_SPRINTING: float = 7.0  # Sprinting speed
@export var JUMP_VELOCITY: float = 4.5  # Jump velocity
@export var MOUSE_SENSITIVITY: float = 0.5  # Mouse sensitivity for camera control
@export var TILT_LOWER_LIMIT: float = deg_to_rad(-90.0)  # Lower limit for camera tilt
@export var TILT_UPPER_LIMIT: float = deg_to_rad(90.0)  # Upper limit for camera tilt
@export var ANIMATIONPLAYER: AnimationPlayer  # Reference to AnimationPlayer
@export var CAMERA_CONTROLLER: SpringArm3D  # Reference to the camera controller

# Private variables
var _speed: float = SPEED_DEFAULT  # Current movement speed
var _mouse_input: bool = false  # Flag to check mouse movement
var _rotation_input: float = 0.0  # Input for player rotation
var _tilt_input: float = 0.0  # Input for camera tilt
var _mouse_rotation: Vector3 = Vector3()  # Camera rotation tracking
var _player_rotation: Vector3 = Vector3()  # Player rotation tracking
var _camera_rotation: Vector3 = Vector3()  # Camera rotation tracking
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")  # Gravity value

var state_machine: StateMachine  # Reference to the state machine

# Called when the node enters the scene tree for the first time
func _ready():
	Global.player = self  # Set the global player reference
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Capture mouse input
	state_machine = $StateMachine  # Get the StateMachine node
	state_machine.CURRENT_STATE.enter()  # Enter the initial state

# Called for unhandled input events
func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY  # Invert horizontal mouse movement
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY  # Invert vertical mouse movement

# Called for input events
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()  # Quit the game on exit action

# Updates the camera based on mouse movement
func _update_camera(delta: float):
	_mouse_rotation.x += _tilt_input * delta  # Update tilt based on input
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)  # Clamp tilt
	_mouse_rotation.y += _rotation_input * delta  # Update player rotation

	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)  # Set player rotation
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)  # Set camera rotation

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)  # Update camera orientation
	CAMERA_CONTROLLER.rotation.z = 0.0  # Reset z-rotation
	global_transform.basis = Basis.from_euler(_player_rotation)  # Update player orientation

	# Reset input after processing
	_rotation_input = 0.0
	_tilt_input = 0.0

# Called every physics frame
func _physics_process(delta: float):
	_update_camera(delta)  # Update camera

	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump logic
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Apply jump velocity

	# Handle movement input
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()  # Calculate direction

	if direction:
		velocity.x = lerp(velocity.x, direction.x * _speed, ACCELERATION)  # Accelerate movement
		velocity.z = lerp(velocity.z, direction.z * _speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)  # Decelerate movement
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()  # Move the character

