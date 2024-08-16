extends Node

@onready var player = $PlayerTemplate

func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_position", player.global_transform.origin)
