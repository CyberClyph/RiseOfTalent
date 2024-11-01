# Health3D.gd
extends Node3D
class_name HealthManager


# Variables for health
@export var max_health: int = 100
var current_health: int = max_health

# Reference to the TextureProgressBar for health display (UI)
@export var health_bar: TextureProgressBar

# Called when this character takes damage
func take_damage(damage: int) -> void:
	current_health -= damage
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()

	# Check if health is depleted
	if current_health <= 0:
		die()

# Update the health bar based on the current health
func update_health_bar() -> void:
	if health_bar:
		health_bar.value = float(current_health) / max_health * 100

# This function should be overridden by child classes (e.g., player, enemy)
func die() -> void:
	queue_free()  # Default behavior: remove the character from the scene
