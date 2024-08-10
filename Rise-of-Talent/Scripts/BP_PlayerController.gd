extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Camera parameters
@export var camera_target: Node3D
@export var camera_parent: Node3D
var camera_T = 0.0
var cam_speed = 250.0

# Additional variables 
var horizontal = 0.0
var vertical = 0.0
var turn_speed = 5.0
var input_block = false
var anim_canmove = false
var root_velocity = Vector3.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

	# Movement input with camera
	camera_T = camera_target.global_transform.basis.get_euler().y

	input_dir = Vector3(horizontal, 0, vertical).normalized()
	if input_dir != Vector3.ZERO and not input_block:
		direction = Vector3(horizontal, 0, vertical).rotated(Vector3.UP, camera_T).normalized()
		anim_canmove = true
	else:
		anim_canmove = false

	if direction != Vector3.ZERO:
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), turn_speed * delta)

	# Apply velocity
	move_and_slide()

func camera_smooth_follow(delta):
	var cam_offset = Vector3(-0.5, 1.5, 0).rotated(Vector3.UP, camera_T)
	var cam_timer = clamp(delta * cam_speed / 20, 0, 1)
	camera_parent.global_transform.origin = camera_parent.global_transform.origin.lerp(global_transform.origin + cam_offset, cam_timer)

