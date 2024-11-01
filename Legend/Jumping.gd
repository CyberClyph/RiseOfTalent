class_name Jumping
extends State

@export var top_animation_speed : float = 10.0
@export var fall_state: State
@export var idle_state: State
@export var move_state: State


@export var fall_threshold: float = 10.0
@export var jump_sustain_gravity: float = 10  # Gravity while holding jump button

var jump_time: float = 0.2  # How long the jump is sustained
var jump_timer: float = -0.5  # Timer to track jump sustain
var is_playing_jump = false

func enter() -> void:
	super()
	print('Jumping')
	# Set the initial jump velocity
	  # Reset the jump sustain timer
	if animation_name == "Jump_Up":
		parent.animations.play("Jump_Up")
		is_playing_jump = true
		parent.velocity.y = parent.JUMP_VELOCITY
		jump_timer = 0.0
		# Set the animation speed when the attack starts
		set_animation_speed(0.4)
		# Check if the animation_finished signal is already connected
		var callable_func = Callable(self, "_on_animation_finished")
		if not parent.animations.is_connected("animation_finished", callable_func):
			parent.animations.connect("animation_finished", callable_func)
	
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Jump_Up":
		is_playing_jump = false
		set_animation_speed(0.3)
		# Return to idle state after attack finishes
		parent.state_machine.change_state(fall_state)
		# Disconnect the signal to prevent multiple connections
		var callable_func = Callable(self, "_on_animation_finished")
		if parent.animations.is_connected("animation_finished", callable_func):
			parent.animations.disconnect("animation_finished", callable_func)
			
func process_physics(delta: float) -> State:
	# If jump key is held, sustain jump for a certain time
	if Input.is_action_pressed("jump") and jump_timer < jump_time:
		parent.velocity.y -= jump_sustain_gravity * delta  # Reduce gravity for smoother jump
		jump_timer += delta
	else:
		# Apply normal gravity
		parent.velocity.y += parent.gravity * delta

	# Check if the player is falling fast enough to transition to fall_state
	if parent.velocity.y > fall_threshold:
		return fall_state

	# Handle horizontal movement
	var movement = parent.get_movement_input(delta) * parent.move_speed
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	parent.move_and_slide()

	# Check if the player has landed on the floor
	if parent.is_on_floor():
		if movement.length() > 0:
			return move_state  # Transition to moving state
		else:
			return idle_state  # Transition to idle state

	return null  # Stay in the jumping state

func set_animation_speed(spd: float) -> void:
	# Remap the speed and set the animation's speed_scale
	var alpha = remap(spd, 0.0, Global.player.speed, 0.0, 1.0)
	parent.animations.speed_scale = lerp(0.0, top_animation_speed, alpha)
