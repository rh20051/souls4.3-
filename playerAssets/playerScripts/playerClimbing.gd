extends State
class_name playerClimbing
@export var animTree : AnimationTree
@export var player: CharacterBody3D
var dir
func enter():
	animTree["parameters/conditions/moving"] = false
	animTree["parameters/conditions/idle"] = false
	animTree["parameters/conditions/running"] = false
	player.anim.play("default")

func physics_update(delta:float):
	if player.climbing == false:
		transitioned.emit(self, "playerIdle")
	player.velocity.x = 0
	player.velocity.z = 0
	
	player.velocity.y = -player.input_dir.y * player.SPEED
