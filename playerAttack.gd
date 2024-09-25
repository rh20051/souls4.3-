extends State
class_name playerAttack
@export var animTree : AnimationTree
@export var player: CharacterBody3D

var chain = false
var canMove
func enter():
	animTree["parameters/conditions/moving"] = false
	animTree["parameters/conditions/idle"] = false
	animTree["parameters/conditions/running"] = false

	animTree["parameters/conditions/attack"] = true
	
	#player.direction = Vector3()
	player.SPEED  = 0

	await animTree.animation_finished
	transitioned.emit(self, "playerIdle")

func physics_update(delta:float):
	
	if Input.is_action_just_pressed("attack"):
		animTree["parameters/conditions/chain"] = true
		animTree["parameters/conditions/attack"] = false
	var currentRotation = player.get_node("Armature").transform.basis.get_rotation_quaternion()
	player.velocity = (currentRotation.normalized() * animTree.get_root_motion_position()) / delta
func Move():
	canMove = true
func cantMove():
	canMove = false
