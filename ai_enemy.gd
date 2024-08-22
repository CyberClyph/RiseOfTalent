extends CharacterBody3D

@export var player_path: NodePath
const Speed = 4.5
const Attack_Range = 2.5
var player = null
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
var nav_finish = null
var nav_player_range = null



func _ready():
	player = get_node(player_path)
	

	move_and_slide()
	
func _process(delta):
	velocity = Vector3.ZERO

	#Navigation	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * Speed
	
	
	
	
	
	#Conditions
	anim_tree.set("parameters/conditions/IsWalking", nav_agent)
	anim_tree.set("parameters/conditions/IsRunning", nav_agent)
	anim_tree.set("parameters/conditions/isBigAttack", _target_in_range())
	anim_tree.set("parameters/conditions/IsOnFloor", next_nav_point)


	
	#look at Player
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	move_and_slide()
	
	
func _target_in_range():
		return global_position.distance_to(player.global_position) < Attack_Range
		
