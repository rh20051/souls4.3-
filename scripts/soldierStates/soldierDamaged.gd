extends State
class_name soldierDamaged
@export var enemy: CharacterBody3D
@export var animPlayer: AnimationPlayer

func enter():
	enemy.damaged = false
	enemy.velocity = Vector3()
	animPlayer.play("damaged1")
	
	
func physics_update(delta:float):
	if enemy.damaged == true:
		animPlayer.play("damaged2")
		enemy.damaged = false
	var currentRotation = enemy.transform.basis.get_rotation_quaternion()
	enemy.velocity = (currentRotation.normalized() * animPlayer.get_root_motion_position()) / delta
	await animPlayer.animation_finished
	transitioned.emit(self, "soldierIdle")
