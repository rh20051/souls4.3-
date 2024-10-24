extends State
class_name playerRolling
@export var animTree : AnimationTree
@export var player: CharacterBody3D
var dir
func enter():
	animTree["parameters/conditions/moving"] = false
	animTree["parameters/conditions/idle"] = false
	animTree["parameters/conditions/running"] = false
	animTree["parameters/conditions/rolling"] = true
	animTree["parameters/StateMachine/conditions/dodging"] = true
	player.stamina -=20
	player.SPEED = 2
	
	
	
	await animTree.animation_finished
	animTree["parameters/conditions/rolling"] = false
	animTree["parameters/StateMachine/conditions/dodging"] = false
	player.rolling = false

	
	
	transitioned.emit(self,"playerIdle")

func physics_update(delta:float):
	
		if player.lockedEnemy:
			
			player.get_node("Armature").rotation.x = 0
			player.get_node("Armature").rotation.z = 0
		var currentRotation = player.get_node("Armature").transform.basis.get_rotation_quaternion()
		player.velocity = (currentRotation.normalized() * animTree.get_root_motion_position()) / delta
		player.velocity.z = lerp(player.velocity.z,player.direction.z * player.roll_distance,.02)
		player.velocity.x = lerp(player.velocity.x,player.direction.x * player.roll_distance,.02)
