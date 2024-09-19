extends State
class_name skeletonAttack

var accel = 10
var player
var distance
var space_state
@export var enemy: CharacterBody3D

var target
func enter():
	enemy.SPEED = 0
	player = get_tree().get_first_node_in_group("player")
	target = player.global_position
	enemy.anim.play("attack1")
	await enemy.anim.animation_finished
	if enemy.global_position.distance_to(player.global_position) > 3:
		enemy.SPEED = 5
		transitioned.emit(self, "skeletonChase")
		
	else:
		transitioned.emit(self, "skeletonAttack")
