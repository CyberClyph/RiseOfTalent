extends Node
class_name Attack

# Enum for attack types
enum AttackType {
	MELEE,
	RANGED,
	MAGIC
}

# Attack parameters
@export var attack_type: AttackType = AttackType.MELEE  # Default attack type
@export var damage: float = 10.0  # Damage dealt by the attack
@export var knockback_force: float = 5.0  # Force applied to knocked back enemies
@export var cooldown_time: float = 1.0  # Cooldown duration between attacks
@export var animation_name: String = "Attack"  # Animation to play during the attack

var last_attack_time: float = 0.0  # Timestamp of the last attack
var animation_player: AnimationPlayer  # Reference to the AnimationPlayer
var enemy = Global.enemy

func _ready():
	animation_player = $AnimationPlayer  # Assuming AnimationPlayer is a child node

# Attack function
func perform_attack():
	if can_attack():
		last_attack_time = OS.get_ticks_msec() / 1000.0  # Update last attack time
		play_attack_animation()  # Play the attack animation
		apply_damage()  # Apply damage to enemies

# Check if the attack can be performed
func can_attack() -> bool:
	return (OS.get_ticks_msec() / 1000.0 - last_attack_time) >= cooldown_time  # Check cooldown

# Play the attack animation
func play_attack_animation():
	if animation_player and animation_name:
		animation_player.play(animation_name)  # Play the specified attack animation

# Apply damage to enemies in range
func apply_damage():
	# Here you would implement logic to detect enemies within the attack range
	var enemies = get_overlapping_enemies()  # Placeholder function for getting enemies in range
	for enemy in enemies:
		enemy.take_damage(damage)  # Call the take_damage method on enemy
		apply_knockback(enemy)  # Apply knockback force

# Apply knockback to the enemy
func apply_knockback(enemy: Node):
	if enemy:
		var direction = (enemy.global_position - global_position).normalized()  # Calculate knockback direction
		enemy.velocity += direction * knockback_force  # Apply knockback force

# Placeholder function for detecting overlapping enemies
func get_overlapping_enemies() -> Array:
	# This is a placeholder; implement your logic to find enemies based on your game's mechanics.
	return []  # Return an empty array for now
