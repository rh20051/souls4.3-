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
	player.stamina -=20
	
	player.velocity.z = lerp(player.velocity.z,player.direction.z * player.roll_distance,.5)
	player.velocity.x = lerp(player.velocity.x,player.direction.x * player.roll_distance,.5)
	
	
	await animTree.animation_finished
	animTree["parameters/conditions/rolling"] = false
	player.rolling = false
	player.velocity.z = 0
	player.velocity.x = 0
	
	if player.direction:
		transitioned.emit(self, "playerWalking")
	else:
		transitioned.emit(self,"playerIdle")

func physics_update(delta:float):
		if player.lockedEnemy:
			player.get_node("Armature").look_at(player.global_position+player.direction)
			player.get_node("Armature").rotation.x = 0
			player.get_node("Armature").rotation.z = 0
