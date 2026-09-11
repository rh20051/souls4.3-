extends State
class_name soldierChase
@export var enemy: CharacterBody3D
const accel = 7
@export var animTree: AnimationTree
#loleaaqqqS

var distance


func enter():
	print(angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)))
	animTree["parameters/conditions/chase"] = false
	if angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) > 2.2 or angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) <= -2.2:
		animTree["parameters/conditions/sharpturn"] = true
	else:
		animTree["parameters/conditions/sharpturn"] = false
	print("woah")
	animTree["parameters/conditions/combo1"] = false
	animTree["parameters/conditions/comboend"] = true
	animTree["parameters/conditions/attack"] = false
	animTree["parameters/conditions/combo1"] = false
	animTree["parameters/conditions/swing"] = false
	animTree["parameters/conditions/idle"] = false



func physics_update(delta:float):
	
	animTree["parameters/conditions/chase"] = true
	animTree["parameters/conditions/idle"] = false
	if enemy.damaged == true:
		transitioned.emit(self, "soldierDamaged")

	if animTree["parameters/conditions/sharpturn"] == false:
		enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), delta * 4)


	enemy.rotation.x = 0
	enemy.rotation.z = 0
	enemy.target = enemy.player.global_position
	var nav = enemy.get_node("NavigationAgent3D")
	enemy.direction = enemy.player.global_position - enemy.global_position
	if angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .1 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.1:
		enemy.velocity = enemy.direction.normalized() * 5
	enemy.velocity.y = 0
	nav.target_position = enemy.target
	distance = nav.get_next_path_position() - enemy.global_position
	distance = distance.normalized()
	#enemy.velocity.y -= enemy.gravity * delta
	if enemy.global_position.distance_to(enemy.player.global_position) < 4  and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .1 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.1:
		transitioned.emit(self, "soldierAttack")
		
	else:
		pass
		enemy.velocity = enemy.velocity.lerp(distance * 3, delta * accel)
		
func sharpTurn():
	enemy.rotation.y = enemy.angle + deg_to_rad(180)
	animTree["parameters/conditions/sharpturn"] = false
