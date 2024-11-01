extends SpringArm3D

# Zoom range properties
@export var min_length: float = 2.0  # Minimum length of the spring arm
@export var max_length: float = 10.0  # Maximum length of the spring arm
@export var zoom_factor: float = 1.0   # Amount to change zoom per scroll
@export var rotation_speed: float = 0.1  # Custom speed of the rotation

# The spring arm's current length
var current_length: float = 5.0

# Player reference
@onready var player = Global.player

func _ready():
	# Set initial length of the spring arm
	spring_length = current_length
	# Capture mouse to hide the cursor and lock it within the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Rotate camera based on mouse movement
		rotation_degrees.y -= event.relative.x * rotation_speed
		rotation_degrees.x -= event.relative.y * rotation_speed
		rotation_degrees.x = clamp(rotation_degrees.x, -80, 80)  # Limit vertical rotation

		# Check for mouse wheel scrolling for zoom
		if event.relative.y != 0:
			# Scroll up to zoom in
			if event.relative.y > 0:
				current_length = clamp(current_length - zoom_factor, min_length, max_length)
			# Scroll down to zoom out
			else:
				current_length = clamp(current_length + zoom_factor, min_length, max_length)

			# Update the spring arm's length based on current zoom level
			spring_length = current_length

		# Make the player face the camera's direction
		if player:
			var direction = -transform.basis.z.normalized()  # In Godot, the forward direction is negative Z
			player.look_at(player.position + direction, Vector3.UP)

func _process(delta):
	pass  # The rotation logic is handled in _input(), so nothing is needed here
