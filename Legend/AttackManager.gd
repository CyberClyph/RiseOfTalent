extends Node
class_name AttackManager

@export var player: Area3D
@onready var state_machine: StateManager = $"../../Player/StateMachine"

func _ready():
	# Connecting the "attack_hit" signal from the player to the _on_attack_hit method using Callable
	player.connect("attack_hit", Callable(self, "_on_attack_hit"))

func process_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		player.perform_attack()

func _on_attack_hit(target: Node, damage: float) -> void:
	if target is EnemyHitbox:
		target.take_damage(damage)
