extends State
class_name soldierAttack
@export var enemy: CharacterBody3D
@export var animPlayer :AnimationPlayer
var turnSpeed = 1

func enter():
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	animPlayer.play("stab1")
	enemy.velocity = Vector3()
func physics_update(delta: float):
	enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), delta * turnSpeed)
	var currentRotation = enemy.transform.basis.get_rotation_quaternion()
	enemy.velocity = (currentRotation.normalized() * animPlayer.get_root_motion_position()) / delta
	if animPlayer.animation_finished:
		turnSpeed = 3
	else:
		turnSpeed = 1
	
	if enemy.global_position.distance_to(enemy.player.global_position) > 5:
		await animPlayer.animation_finished
		transitioned.emit(self, "soldierIdle")



func checkChain():
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	elif animPlayer.current_animation == "stab1":
		if enemy.global_position.distance_to(enemy.player.global_position) < 5:
			
			animPlayer.play("stab2")
	elif animPlayer.current_animation == "stab2":
		if enemy.global_position.distance_to(enemy.player.global_position) < 5:
			var first_value = bool(randi() % 2)
			if first_value:
				animPlayer.play("stab3")
			else:
				animPlayer.play("swing")
			await animPlayer.animation_finished
			await get_tree().create_timer(.5).timeout
			transitioned.emit(self, "soldierIdle")
