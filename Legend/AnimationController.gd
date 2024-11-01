extends Node
class_name AnimationController

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var player = Global.player

func _ready():
	# Initialize the AnimationTree here if needed
	pass  # You can add initialization logic here if necessary

func update_animation(state: String):
	match state:
		"Idle":
			animation_tree.set("parameters/Idle/blend_position", Vector2.ZERO)  # Set idle blend position
		"Sprint":
			animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(0, 1))  # Set run blend position
		"Walking":
			animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(0, 0.5))  # Set run blend position
		"StrafeLeft":
			animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(-1, 0))  # Set run blend position
		"StrafeRight":
			animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(1, 0))  # Set run blend position
		"Backwards":
			animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(0, -1))
		# Add more states as needed
		_:
			print("Unknown state: ", state)  # Optional: Handle unknown states
