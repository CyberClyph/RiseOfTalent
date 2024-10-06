extends Area3D
class_name Hitbox

signal hit_target(body: Node)

@export var damage: int = 15
@export var is_active: bool = false  # Renamed to avoid shadowing base class

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))  # Use Callable
	is_active = false  # Initially, disable hitbox monitoring

func activate() -> void:
	is_active = true  # Enable hitbox for detecting collisions
	print("Hitbox activated")

func deactivate() -> void:
	is_active = false  # Disable hitbox when the attack is over
	print("Hitbox deactivated")

# Called when another body enters the hitbox area
func _on_body_entered(body: Node) -> void:
	if body.has_method("receive_attack"):
		emit_signal("hit_target", body)  # Emit signal to indicate a hit
		body.receive_attack(damage)  # Apply damage to the body hit
