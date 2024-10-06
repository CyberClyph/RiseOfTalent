extends State
class_name StrafeLeft

@export var ANIMATION: AnimationPlayer  # Reference to the animation player
@export var TOP_ANIM_SPEED: float = 2.2  # Maximum speed for animation

func enter() -> void:
	if ANIMATION:
		ANIMATION.play("Left_Strafe", -1.0, 1.0)  # Start walking animation

func update(_delta: float) -> void:
	set_animation_speed(Global.player.velocity.length())  # Update animation speed based on player speed
	if Global.player.velocity.length() == 0.0:
		Transition.emit("Idle")  # Transition to Idle state if not moving

# Sets the animation speed based on player speed
func set_animation_speed(spd: float) -> void:
	var alpha = remap(spd, 0.0, Global.player.SPEED_DEFAULT, 0.0, 1.0)  # Normalize speed
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)  # Lerp to set animation speed

func _input(event) -> void:
	if event.is_action_released("sprint") and Global.player.is_on_floor():
		Transition.emit("Sprint")  # Transition to Sprint state
