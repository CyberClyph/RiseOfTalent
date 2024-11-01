class_name Attack
extends State

@onready var health_manager = HealthManager
@export var top_animation_speed : float = 10.0
@export var fall_state: State
@export var idle_state: State
@export var jump_state: State

@export var hitbox : Area3D
@export var hurtbox : Area3D
var is_playing_attack = false

# Assume we have a reference to the PlayerDamageSystem (assigned or fetched)
@onready var damage_system =$"../../PlayerController/Damage/HitBox"

func enter() -> void:
	if animation_name == "Attack":
		parent.animations.play("Attack")
		is_playing_attack = true

		# Set the animation speed when the attack starts
		set_animation_speed(1.0)

		# Play the attack animation and connect the finished signal
		var callable_func = Callable(self, "_on_animation_finished")
		if not parent.animations.is_connected("animation_finished", callable_func):
			parent.animations.connect("animation_finished", callable_func)

		print("Punching")
		
		# Call the perform_attack on the damage system
		if damage_system:
			damage_system.perform_attack()  # Activate the attack temporarily
			print("Damage system activated and deactivated")
		else:
			print("Damage system is null!")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Attack":
		is_playing_attack = false
		set_animation_speed(0.3)
		parent.state_machine.change_state(idle_state)  # Return to idle state after attack finishes
		
		# Disconnect the signal to avoid multiple connections
		var callable_func = Callable(self, "_on_animation_finished")
		if parent.animations.is_connected("animation_finished", callable_func):
			parent.animations.disconnect("animation_finished", callable_func)

func process_input(_event: InputEvent) -> State:
	# Avoid interrupting the attack animation
	if not is_playing_attack:
		if Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta

	var movement = parent.get_movement_input(delta) * parent.move_speed
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	parent.move_and_slide()

	if parent.is_on_floor():
		# Only allow transitioning to idle if attack animation is done
		if movement.length() == 0 and !is_playing_attack:
			return idle_state

	if not parent.is_on_floor():
		return fall_state
	
	return null

func set_animation_speed(spd: float) -> void:
	# Remap the speed and set the animation's speed_scale
	var alpha = remap(spd, 0.0, Global.player.speed, 0.0, 1.0)
	parent.animations.speed_scale = lerp(0.0, top_animation_speed, alpha)
