extends State
class_name skeletonIdle

@export var enemy: CharacterBody3D
var player
func _ready():
	player = get_tree().get_first_node_in_group("player")

func physics_update(delta:float):
	enemy.anim.play("idle")
	var direction = player.global_position - enemy.global_position
	enemy.velocity = Vector3()
	if direction.length() > 2:
		transitioned.emit(self, "skeletonChase")
