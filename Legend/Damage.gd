extends Area3D
class_name PlayerDamage



@export var base_attack_power: float = 10.0
@export var crit_chance: float = 0.1
@export var crit_multiplier: float = 1.5
@onready var attack_animation: AnimationPlayer = $"../Player/AnimationPlayer"
var is_attacking: bool = false

signal attack_hit(target: Node, damage: float)

func _ready():
	# Connecting the signal using Callable
	$".".connect("area_entered", Callable(self, "_on_area_entered"))

func perform_attack():
	if not is_attacking:
		is_attacking = true
		attack_animation.play("Attack")
		# Connecting the signal using Callable for animation finished
		attack_animation.connect("animation_finished", Callable(self, "_on_attack_finished"))

func _on_attack_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
		# Disconnecting using Callable for the same method
		attack_animation.disconnect("animation_finished", Callable(self, "_on_attack_finished"))

func _on_area_entered(area):
	if area is EnemyHitbox:
		var damage = calculate_damage()
		emit_signal("attack_hit", area, damage)

func calculate_damage() -> float:
	var final_damage = base_attack_power
	if randf() <= crit_chance:
		final_damage *= crit_multiplier
		print("Critical Hit!")
	return final_damage
