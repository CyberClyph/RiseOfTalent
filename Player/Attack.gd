extends State
class_name Attack

@export var ANIMATION: AnimationPlayer  # Reference to the animation player
@export var ANIMATION_SPEED: float = 1.0  # Adjustable animation speed

var is_animation_playing: bool = false  # Track if the animation is currently playing

func enter() -> void:
	if ANIMATION:
		ANIMATION.speed_scale = ANIMATION_SPEED  # Set the animation speed
		ANIMATION.play("Attack")  # Play attack animation
		is_animation_playing = true  # Set flag to indicate animation is playing

func update(_delta: float) -> void:
	if is_animation_playing:
		# Check if the attack animation is still playing
		if not ANIMATION.is_playing():
			is_animation_playing = false  # Animation has finished playing
			Transition.emit("Idle")  # Transition back to Idle state after attack

func _input(event) -> void:
	# Prevent state change while attacking
	if event.is_action_pressed("attack") and not is_animation_playing:
		Transition.emit("Attack")  # Attempt to attack again if not currently attacking
