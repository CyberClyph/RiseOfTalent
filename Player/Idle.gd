extends State
class_name Idle

@export var ANIMATION: AnimationPlayer  # Reference to the animation player

func _ready():
	if ANIMATION:
		ANIMATION.play("Idle")  # Play idle animation

# Enter Idle state
func enter() -> void:
	if ANIMATION:
		ANIMATION.pause()  # Pause any other animations
		ANIMATION.play("Idle")  # Play idle animation

# Update logic for the Idle state
func update(_delta: float) -> void:
	# Check if player is moving and on the floor to transition to Walking state
	if Global.player and Global.player.velocity.length() > 0.0 and Global.player.is_on_floor():
		Transition.emit("Walk")  # Transition to Walking state

func _input(event) -> void:
	# Check for movement input
	if Global.player.is_on_floor():
		if event.is_action_pressed("forward"):
			Transition.emit("Walking")
		elif event.is_action_pressed("left"):  # Added missing colon
			Transition.emit("StrafeLeft")
		elif event.is_action_pressed("right"):
			Transition.emit("StrafeRight")
		elif event.is_action_pressed("backward"):
			Transition.emit("Backwards")
		
	# Check for attack input
	if Global.player.is_on_floor() and event.is_action_pressed("attack"):
		Transition.emit("Attack")  # Transition to Attack state
