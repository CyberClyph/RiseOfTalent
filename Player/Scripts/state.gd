class_name State
extends Node

@export var animation_name: String
@export var move_speed: float = 400

@export var animation_playback_speed: float = 1.0  # Variable to control animation playback speed per state

var parent = Global.player

func enter() -> void:
	# Play the animation with the specified playback speed
	parent.animations.play(animation_name)  # Adjust speed while playing

func exit() -> void:
	# Optionally reset playback speed or other variables when exiting
	parent.animations.stop()  # Stop any current animation if needed
	
func process_frame(delta: float) -> State:
	# Check if the animation is currently playing
	if not parent.animations.is_playing():
		# Transition to the desired state after the animation ends
		return null  # or return the next state here, if needed

	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null

