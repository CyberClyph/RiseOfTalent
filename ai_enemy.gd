extends CharacterBody3D

#nav
@export var player_path: NodePath
const Speed = 4.5
const Attack_Range = 1.2
var player = null
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
var nav_finish = null
var nav_player_range = null

var state_machine


func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	

	move_and_slide()
	
func _process(delta):
	velocity = Vector3.ZERO
	
	
	match state_machine.get_current_node():		
		"Run":		
	#Navigation	
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			anim_tree.set("parameters/conditions/IsOnFloor", next_nav_point)
			velocity = (next_nav_point - global_transform.origin).normalized() * Speed
				#look at Player
			look_at(Vector3(player.global_position.x + velocity.x, global_position.y, player.global_position.z + velocity.z), Vector3.UP)
			
		"Attack1", "Attack2", "BigAttack":
				#look at Player
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			
	
	
	
	#Conditions
	
	anim_tree.set("parameters/conditions/isBigAttack", _target_in_range())
	anim_tree.set("parameters/conditions/IsWalking", !_target_in_range())
	anim_tree.set("parameters/conditions/IsRunning", !_target_in_range())
	#anim_tree.set("parameters/conditions/IsOnFloor", !_target_in_range())
	#anim_tree.set("parameters/conditions/IsOnFloor", _target_in_range())
	anim_tree.set("parameters/conditions/IsNotWalking", _target_in_range())
	anim_tree.set("parameters/conditions/IsNotRunning", _target_in_range())
	anim_tree.set("parameters/conditions/isAttack", _target_in_range())
	
	anim_tree.get("parameters/playback")


	
	move_and_slide()
	
	
func _target_in_range():
		return global_position.distance_to(player.global_position) < Attack_Range
		

func _hit_finished():
	if global_position.distance_to(player.global_position) < Attack_Range + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)

