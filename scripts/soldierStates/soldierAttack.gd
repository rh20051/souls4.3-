extends State
class_name soldierAttack
@export var enemy: CharacterBody3D
@export var animTree: AnimationTree

var turnSpeed = 1
var canTurn = true
var comboFinished = false
func enter():

	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	animTree["parameters/conditions/attack"] = true
	enemy.velocity = Vector3()
func physics_update(delta: float):
	if canTurn:
		enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), delta * (turnSpeed * 2))
		var currentRotation = enemy.transform.basis.get_rotation_quaternion()
		enemy.velocity = (currentRotation.normalized() * animTree.get_root_motion_position()) / delta
	else:
		turnSpeed = 1
	
	if enemy.global_position.distance_to(enemy.player.global_position) > 5 or comboFinished == true:
		animTree["parameters/conditions/attack"] = false


func turn():
	canTurn = true
func turnEnd():
	canTurn = false
func checkChain():
	if enemy.damaged == true:
		
		transitioned.emit(self, "soldierDamaged")
	elif animTree.get_current_node() == "stab1":
		if enemy.global_position.distance_to(enemy.player.global_position) < 5:
			
			animTree["parameters/conditions/combo1"] = true
	elif animTree.get_current_node() == "stab2":
		if enemy.global_position.distance_to(enemy.player.global_position) < 5 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .3 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.3:
			if enemy.type != "SNS":
				var first_value = bool(randi() % 2)
				if first_value:
					animTree["parameters/conditions/combo2"] = true
				else:
					animTree["parameters/conditions/swing"] = true

				
				
			
