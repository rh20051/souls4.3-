extends State
class_name soldierAttack
@export var enemy: CharacterBody3D
var animPlayer
var turnSpeed = 1
var canTurn = true
var comboFinished = false
func enter():
	if enemy.type == "S":
		animPlayer = enemy.get_node("SAnimationPlayer")
	else:
		animPlayer= enemy.get_node("SNSAnimationPlayer")
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	animPlayer.play("attack1")
	enemy.velocity = Vector3()
func physics_update(delta: float):
	if animPlayer.is_playing():
		comboFinished = true
		turnSpeed = 1
	if canTurn:
		enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), delta * turnSpeed)
	var currentRotation = enemy.transform.basis.get_rotation_quaternion()
	enemy.velocity = (currentRotation.normalized() * animPlayer.get_root_motion_position()) / delta
	if animPlayer.animation_finished:
		turnSpeed = 1
	else:
		turnSpeed = 1
	
	if enemy.global_position.distance_to(enemy.player.global_position) > 5 or comboFinished == true:
		if !animPlayer.is_playing():
			transitioned.emit(self, "soldierIdle")


func turn():
	canTurn = true
func turnEnd():
	canTurn = false
func checkChain():
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	elif animPlayer.current_animation == "attack1":
		if enemy.global_position.distance_to(enemy.player.global_position) < 5:
			
			animPlayer.play("attack2")
	elif animPlayer.current_animation == "attack2":
		if enemy.global_position.distance_to(enemy.player.global_position) < 5 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .3 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.3:
			if enemy.type != "SNS":
				var first_value = bool(randi() % 2)
				if first_value:
					animPlayer.play("attack3")
				else:
					animPlayer.play("swing")
			else:
				animPlayer.play("attack3")
				
				
			
