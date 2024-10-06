extends Node
class_name HealthSystem

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(damage: int) -> void:
	current_health -= damage
	if current_health <= 0:
		die()

func die() -> void:
	print("Player has died.")
