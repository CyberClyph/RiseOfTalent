extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED =3.0

func _pysics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_location()
	var new_velcity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velcity.move_toward(new_velcity, .25)
	move_and_slide()
	
func update_target_location(target_location):
	nav_agent.set_target_location(target_location)
