extends Damageable

@onready var health_bar = $"../HealthBar"  # Reference to your health UI

func take_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	if current_health < 0:
		current_health = 0
	health_bar.value = current_health / max_health * 100  # Assuming the health bar takes a value from 0 to 100
	if current_health <= 0:
		die()
