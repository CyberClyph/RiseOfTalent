extends Node3D

@onready var player = $PlayerTemplate
@onready var hit_rect = $UI/HitRect


func _process(delta):
	pass
	#get_tree().call_group("enemies", "update_target_position", player.global_transform.origin)


func _on_player_template_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false
