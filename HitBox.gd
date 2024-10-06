extends Area3D
class_name EnemyHitbox

@export var health: float = 100.0  # Enemy health
@onready var health_bar: TextureProgressBar = $HealthBar  # Reference to the health bar

func _ready() -> void:
	health_bar.max_value = health  # Set the max value of the health bar
	health_bar.value = health  # Initialize the health bar value

func take_damage(amount: float) -> void:
	health -= amount  # Subtract damage from health
	health_bar.value = health  # Update the health bar value
	if health <= 0:
		die()  # Call die method if health drops to 0 or below

func die() -> void:
	queue_free()  # Remove the enemy from the scene
