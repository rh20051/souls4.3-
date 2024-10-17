extends State
class_name playerIdle
@export var animTree : AnimationTree
@export var player: CharacterBody3D

@onready var anim = player.get_node("AnimationPlayer")
@onready var cam = player.get_node("cameraPoint")
func enter():
	player.canAttack = true
	


func physics_update(_delta: float):
	
	player.velocity = Vector3()
	player.SPEED = 0
	
	
	if cam.position.z != 0:
		cam.position.z = lerp(cam.position.z, 0.0, _delta*2)
	if cam.position.x != 0:
		cam.position.x = lerp(cam.position.x, 0.0, _delta*2)
	if player.parrying:
		transitioned.emit(self, "playerParry")
	if player.direction:
		transitioned.emit(self, "playerWalking")
	if player.canAttack == false:
		transitioned.emit(self,"playerAttack")
