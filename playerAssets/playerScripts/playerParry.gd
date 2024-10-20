extends State
class_name playerParry
@export var animTree : AnimationTree
@export var player: CharacterBody3D
@onready var parryBox = player.get_node("parryArea")
signal successfulParry

func physics_update(delta:float):
	
	if !Input.is_action_pressed("parry"):
		
		animTree["parameters/conditions/notBlocking"] = true
		animTree["parameters/conditions/blocking"] = false
		player.blocking = false
		transitioned.emit(self, "playerIdle")
		
	else:
		animTree["parameters/conditions/notBlocking"] = false
		animTree["parameters/conditions/blocking"] = true
	player.SPEED = 0
	player.velocity = Vector3()
	
