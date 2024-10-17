extends State
class_name skeletonChase

var accel = 10
var player
var distance
var space_state
@export var enemy: CharacterBody3D

var target
var pathfinding = false
func enter():
	enemy.attacking = false
	player = get_tree().get_first_node_in_group("player")
	target = player.global_position
	
func physics_update(delta:float):
	
	enemy.anim.play("chase")
	var direction = (target - enemy.position).normalized()
	var angle = atan2(direction.x,direction.z) + deg_to_rad(180.0)
	enemy.rotation = enemy.rotation.lerp(Vector3(0,angle,0), 1)
	

	enemy.rotation.x = 0
	enemy.rotation.z = 0
	target = player.global_position
	var nav = enemy.get_node("NavigationAgent3D")
	#direction = player.global_position - enemy.global_position
	#enemy.velocity = direction.normalized() * 3
	nav.target_position = target
	distance = nav.get_next_path_position() - enemy.global_position
	distance = distance.normalized()
	if enemy.global_position.distance_to(player.global_position) < 2:
		transitioned.emit(self, "skeletonAttack")
	else:
		enemy.velocity = enemy.velocity.lerp(distance * 3, delta * accel)
