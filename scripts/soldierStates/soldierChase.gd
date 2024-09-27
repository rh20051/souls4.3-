extends State
class_name soldierChase
@export var enemy: CharacterBody3D
const accel = 10
var animPlayer

var distance
func enter():
	if enemy.type == "S":
		animPlayer = enemy.get_node("SAnimationPlayer")
	else:
		animPlayer= enemy.get_node("SNSAnimationPlayer")


func physics_update(delta:float):
	animPlayer.play("walk")
	if enemy.damaged == true:
		transitioned.emit(self, "soldierDamaged")

	
	enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), delta * 4)


	enemy.rotation.x = 0
	enemy.rotation.z = 0
	enemy.target = enemy.player.global_position
	var nav = enemy.get_node("NavigationAgent3D")
	enemy.direction = enemy.player.global_position - enemy.global_position
	enemy.velocity = enemy.direction.normalized() * 5
	enemy.velocity.y = 0
	nav.target_position = enemy.target
	distance = nav.get_next_path_position() - enemy.global_position
	distance = distance.normalized()
	#enemy.velocity.y -= enemy.gravity * delta
	if enemy.global_position.distance_to(enemy.player.global_position) < 3  and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .1 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.1:
		transitioned.emit(self, "soldierAttack")
	else:
		enemy.velocity = enemy.velocity.lerp(distance * 3, delta * accel)
