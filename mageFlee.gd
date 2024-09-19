extends State
class_name mageFlee
@export var enemy: CharacterBody3D
var player
var distance
var space_state
var target
var pathfinding = false
var particlespos
func enter():
	particlespos = enemy.global_position
	#enemy.SPEED = 6
	enemy.attacking = false
	player = get_tree().get_first_node_in_group("player")
	target = player.global_position
	enemy.get_node("Armature").visible = false
	enemy.get_node("teleportparticles").visible = true
	enemy.get_node("teleportparticles").global_position = particlespos
	enemy.get_node("Timer").start(1.5)
func physics_update(delta: float):
	#enemy.anim.play("jog")
	enemy.get_node("teleportparticles").global_position = particlespos
	var direction = (target - enemy.global_position).normalized()
	var angle = atan2(direction.x,direction.z) + deg_to_rad(-90)
	enemy.rotation = enemy.rotation.lerp(Vector3(0,angle,0), delta * 7)
	

	enemy.rotation.x = 0
	enemy.rotation.z = 0
	target = player.global_position
	var nav = enemy.get_node("NavigationAgent3D")
	direction = enemy.global_position - player.global_position
	nav.target_position = enemy.global_position - target
	distance = nav.get_next_path_position() - player.global_position
	distance = distance.normalized()
	enemy.velocity = enemy.velocity.lerp(distance * 3, delta * 2)


func _on_timer_timeout() -> void:
	transitioned.emit(self, "mageAttack")
