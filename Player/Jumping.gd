extends State
class_name Jumping

@export var ANIMATION: AnimationPlayer  # Reference to the animation player
var jump_time: float = 0.0  # Timer to track jump duration
var is_jumping: bool = false  # Track if the player is currently jumping

func enter() -> void:
	if ANIMATION:
		ANIMATION.play("Run_Jump", -1.0, 1.0)  # Play jump animation
	Global.player.velocity.y = Global.player.JUMP_VELOCITY  # Apply jump velocity
	is_jumping = true  # Set jumping flag

func update(delta: float) -> void:
	if is_jumping:
		jump_time += delta  # Increment jump time
		# Check if the player has landed
		if Global.player.is_on_floor():
			Transition.emit("Idle")  # Transition to Idle when landing

func physics_update(_delta: float) -> void:
	# Optional: Additional logic for jump control could be placed here
	pass
