extends State
class_name Sprint

@export var ANIMATION: AnimationPlayer  # Reference to the animation player
@export var TOP_ANIM_SPEED: float = 2.2  # Maximum speed for animation

func enter() -> void:
	if ANIMATION:
		ANIMATION.play("Sprint", -1.0, 1.0)  # Start sprint animation
	Global.player._speed = Global.player.SPEED_SPRINTING  # Set sprint speed

func update(_delta: float) -> void:
	set_animation_speed(Global.player.velocity.length())  # Update animation speed based on player speed
	if Global.player.velocity.length() == 0.0:
		Transition.emit("Idle")  # Transition back to Idle state if not moving

# Sets the animation speed based on player speed
func set_animation_speed(spd: float) -> void:
	var alpha = remap(spd, 0.0, Global.player.SPEED_SPRINTING, 0.0, 1.0)  # Normalize speed
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)  # Lerp to set animation speed

func _input(event) -> void:
	if event.is_action_released("sprint"):
		Transition.emit("Idle")  # Transition back to Idle when sprint is released
