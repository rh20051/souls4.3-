extends State
class_name mageChase
@export var enemy: CharacterBody3D
var accel = 10
var player
var distance
var space_state
var target
var pathfinding = false
func enter():
	enemy.SPEED = 5
	enemy.attacking = false
	player = get_tree().get_first_node_in_group("player")
	target = player.global_position
	
func physics_update(delta:float):
	enemy.anim.play("jog")
	var direction = (target - enemy.global_position).normalized()
	var angle = atan2(direction.x,direction.z) + deg_to_rad(-90)
	enemy.rotation = enemy.rotation.lerp(Vector3(0,angle,0), delta * 7)
	

	enemy.rotation.x = 0
	enemy.rotation.z = 0
	target = player.global_position
	var nav = enemy.get_node("NavigationAgent3D")
	direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * 3
	enemy.velocity.y = 0
	nav.target_position = target
	distance = nav.get_next_path_position() - enemy.global_position
	distance = distance.normalized()
	#enemy.velocity.y -= enemy.gravity * delta
	if enemy.global_position.distance_to(player.global_position) < 2:
		transitioned.emit(self, "mageAttack")
	else:
		enemy.velocity = enemy.velocity.lerp(distance * 3, delta * accel)
