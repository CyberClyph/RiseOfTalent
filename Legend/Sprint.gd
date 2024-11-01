extends State
class_name Sprint

@export var TOP_ANIM_SPEED: float = 2.2  # Maximum speed for animation scaling

# Called when entering the Sprint state
func enter():
	ANIMATION.play("Sprint")
	print("Sprint")
	
	Global.player._speed = Global.player. # Set player speed to sprinting speed
	print("Entered Sprint State")

# Called every frame for logic updates
func update(_delta: float):
	if Global.player.velocity.length() == 0.0:
		Transition.emit("Idle")  # Transition back to Idle state if player stops moving



func process_input(event: InputEvent):
	if event.is_action_just_pressed("forward"):
		Transition.emit("Walking")
	

