extends State
class_name soldierAttack
@export var enemy: CharacterBody3D
@export var animTree: AnimationTree

var turnSpeed = 1
var canTurn
var comboFinished
var swingAngle
func enter():
	animTree["parameters/conditions/comboend"] = false
	animTree["parameters/conditions/idle"] = false
	animTree["parameters/conditions/attack"] = true
	canTurn = false
	print("g")
	comboFinished = false
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	
	enemy.velocity = Vector3()
func physics_update(delta: float):
	var currentRotation = enemy.transform.basis.get_rotation_quaternion()
	if canTurn and !comboFinished and animTree["parameters/conditions/attack"] == true:
		turnSpeed = 1
		#brief moments during attack anims, set by turn() and turnEnd()
		if animTree["parameters/conditions/swing"] == false:
			enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), delta * (turnSpeed * 2))
	
			enemy.velocity = (currentRotation.normalized() * animTree.get_root_motion_position()) / delta
		else:
			enemy.rotation.y = lerp_angle(enemy.rotation.y, swingAngle + animTree.get_root_motion_rotation().y + deg_to_rad(180), delta * (turnSpeed * 4))
			enemy.velocity = Vector3()
	elif !comboFinished:
		#attacking
		turnSpeed = 0
		
		enemy.velocity = (currentRotation.normalized() * animTree.get_root_motion_position()) / delta
		
		
		
	
	elif enemy.global_position.distance_to(enemy.player.global_position) > 5 or comboFinished:
		animTree["parameters/conditions/attack"] = false
		
		transitioned.emit(self, "soldierChase")
		



func turn():
	canTurn = true
	if animTree["parameters/conditions/swing"] == true:
		swingAngle = atan2(enemy.direction.x, enemy.direction.z)
func turnEnd():
	canTurn = false
func comboEnd():
	comboFinished = true
	animTree["parameters/conditions/comboend"] = true
func checkChain():
	comboFinished = false
	print(animTree.get("parameters/playback").get_current_node())
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	elif animTree.get("parameters/playback").get_current_node() == "stab1" and !comboFinished:
		if enemy.global_position.distance_to(enemy.player.global_position) < 5:
			print("Hi")
			animTree["parameters/conditions/combo1"] = true
		else:
			animTree["parameters/conditions/combo1"] = false
			animTree["parameters/conditions/comboend"] = true
			animTree["parameters/conditions/attack"] = false
			animTree["parameters/conditions/combo1"] = false
			comboFinished = true
			
			
	elif animTree.get("parameters/playback").get_current_node() == "stab2" and !comboFinished:
		if enemy.global_position.distance_to(enemy.player.global_position) < 5 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .3 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.3:
			if enemy.type != "SNS":
				animTree["parameters/conditions/combo2"] = true
		elif enemy.global_position.distance_to(enemy.player.global_position) < 5 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < 1.5 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -1.5:
			animTree["parameters/conditions/swing"] = true
	



	elif animTree.get("parameters/playback").get_current_node() == "stab3" or animTree.get("parameters/playback").get_current_node() =="swingLeft":
		comboFinished = true
		animTree["parameters/conditions/comboend"] = true
		animTree["parameters/conditions/combo2"] = false
		animTree["parameters/conditions/combo1"] = false
		animTree["parameters/conditions/attack"] = false
		
		

				
				
			
