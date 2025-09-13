extends State
class_name soldierDamaged
@export var enemy: CharacterBody3D
var animPlayer

func enter():
	if enemy.type == "S":
		animPlayer = enemy.get_node("SAnimationPlayer")
	else:
		animPlayer= enemy.get_node("SNSAnimationPlayer")
	enemy.damaged = false
	enemy.velocity = Vector3()

	
	
func physics_update(delta:float):
	var currentRotation = enemy.transform.basis.get_rotation_quaternion()
	enemy.velocity = (currentRotation.normalized() * animPlayer.get_root_motion_position()) / delta
	await animPlayer.animation_finished
	transitioned.emit(self, "soldierIdle")
