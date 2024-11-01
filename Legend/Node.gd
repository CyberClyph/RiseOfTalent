extends Node
class_name InputManager

# Define signals to communicate with other parts of the game
signal move_input(direction: Vector3)
signal action_input(action: String)

func _process(delta: float):
	var direction = Vector3.ZERO

	# Check input actions for movement
	if Input.is_action_pressed("forward"):
		direction.z -= 1
	if Input.is_action_pressed("backward"):
		direction.z += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	# Emit move_input signal if there is any movement
	if direction != Vector3.ZERO:
		print("Movement input detected:", direction.normalized())
		emit_signal("move_input", direction.normalized())

	if Input.is_action_just_pressed("attack"):
		print("Attack action detected")
		emit_signal("action_input", "attack")
	if Input.is_action_just_pressed("light_attack"):
		print("Light attack action detected")
		emit_signal("action_input", "light_attack")

		emit_signal("action_input", "light_attack")

