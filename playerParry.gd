extends State
class_name playerParry
@export var animTree : AnimationTree
@export var player: CharacterBody3D
@onready var parryBox = player.get_node("parryArea")
signal successfulParry
func enter():
	animTree["parameters/conditions/parrying"] = true
	animTree["parameters/conditions/running"] = false
	await animTree.animation_finished
	player.parrying = false
	transitioned.emit(self,  "playerIdle")

func physics_update(delta:float):
	var a = parryBox.get_overlapping_bodies()
	for i in a:
		if i.is_in_group("enemy"):
			if i.parryable == true:
				successfulParry.connect(i.parried)
				successfulParry.emit()
	player.SPEED = 0
	player.direction = Vector3()
	
	
