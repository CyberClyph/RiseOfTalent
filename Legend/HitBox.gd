extends Area3D

@export var base_damage: int = 10

func _ready():
	# Ensure to disconnect any existing connections to avoid duplicate connections
	self.disconnect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.monitoring = false  # Start with monitoring disabled

func perform_attack():
	self.monitoring = true  # Enable hitbox during attack
	await get_tree().create_timer(0.5).timeout  # Wait 0.5 seconds for the attack duration
	self.monitoring = false  # Disable hitbox after the attack

func _on_body_entered(body):
	# Check if monitoring is enabled and the collided body is an enemy
	if self.monitoring and body.is_in_group("enemy"):
		print("Enemy group detected")
		
		# Assuming the enemy's HealthManager is directly attached to the enemy node
		if body.has_method("take_damage"):  # Check if `take_damage` exists
			body.take_damage(base_damage)  # Call take_damage directly on the body
			print("Damaging enemy within range")
		else:
			print("No take_damage function found on enemy")
	else:
		print("Enemy out of attack range or monitoring disabled")
