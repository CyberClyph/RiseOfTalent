class_name PlayerDamageSystem
extends HealthManager

var attack_damage = 15
var special_attack_damage = 50
@export var hitbox : Area3D 
@export var hurtbox : Area3D
@export var attack_range = 5.0  # Maximum range for the attack to be effective
var attack_in_progress = false  # Track whether an attack is in progress

func _ready():
	# Connect signals but keep monitoring off until an attack starts
	hitbox.connect("body_entered", Callable(self, "_on_hit_box_area_entered"))
	hurtbox.connect("body_entered", Callable(self, "_on_hurt_box_area_entered"))
	hitbox.monitoring = false  # Start with hitbox monitoring disabled

func perform_attack(damage: int) -> void:
	attack_in_progress = true
	hitbox.monitoring = true  # Enable hitbox monitoring only during the attack
	hitbox.damage = damage
	await get_tree().create_timer(0.5).timeout  # Wait for the attack duration
	attack_in_progress = false
	hitbox.monitoring = false  # Disable hitbox monitoring after the attack

func _on_hit_box_area_entered(hurtbox):
	pass
	
func _on_hurt_box_area_entered(hitbox):
	print("enemy hit box touch players hurtbox")

# Additional logic for player-specific behavior when they die
func die() -> void:
	print("Player has died.")
	queue_free()


