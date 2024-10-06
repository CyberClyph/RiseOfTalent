extends Node
class_name State

# Signal for state transitions
signal Transition(new_state_name: StringName)

# Called when entering the state
func enter() -> void:
	pass  # To be overridden in child states

# Called when exiting the state
func exit() -> void:
	pass  # To be overridden in child states

# Called every frame for logic updates
func update(_delta: float) -> void:
	pass  # To be overridden in child states

# Called every physics frame for movement and physics-related logic
func physics_update(_delta: float) -> void:
	pass  # To be overridden in child states
