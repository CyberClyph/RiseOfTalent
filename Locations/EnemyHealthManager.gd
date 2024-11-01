extends HealthManager
class_name EnemyDamageSystem

@export var animation_player : AnimationPlayer

# Override or add additional functionality to take_damage if needed
func take_damage(damage: int) -> void:
	# Call the base function from HealthManager to reduce health and update health bar
	super.take_damage(damage)

	# Additional behavior for enemies when they take damage
	print("Enemy takes", damage, "damage, current health:", current_health)

func update_health_bar() -> void:
	super.update_health_bar()
	if animation_player:
		animation_player.play("Hit_Reaction")
		
	else:
		die()

func die() -> void:
	if animation_player:  # Override death behavior for the enemy
		print("Enemy has died.")
		animation_player.play("Knockout_2")  # Play the knockout animation
		# Wait for the animation to finish before removing the enemy
		await get_tree().create_timer(animation_player.get_animation("Knockout_2").length).timeout
		queue_free()  # Remove the enemy from the scene
