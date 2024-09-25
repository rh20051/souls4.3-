extends State
class_name playerIdle
@export var animTree : AnimationTree
@export var player: CharacterBody3D

@onready var anim = player.get_node("AnimationPlayer")
@onready var cam = player.get_node("cameraPoint")
func enter():
	player.canAttack = true



func physics_update(_delta: float):
	animTree["parameters/conditions/parrying"] = false
	animTree["parameters/conditions/attack"] = false
	animTree["parameters/conditions/chain"] = false
	animTree["parameters/conditions/moving"] = false
	animTree["parameters/conditions/idle"] = true
	animTree["parameters/conditions/running"] = false
	player.velocity = Vector3()
	if player.currentWeapon:
		if player.currentWeapon.name == "flamberge":
			animTree["parameters/conditions/holdingFlamberge"] = true
			animTree["parameters/conditions/notHoldingFlamberge"] = false
		else:
			animTree["parameters/conditions/holdingFlamberge"] = false
			animTree["parameters/conditions/notHoldingFlamberge"] = true
	player.SPEED = 0
	
	
	if cam.position.z != 0:
		cam.position.z = lerp(cam.position.z, 0.0, _delta*2)
	if cam.position.x != 0:
		cam.position.x = lerp(cam.position.x, 0.0, _delta*2)
	if player.parrying:
		transitioned.emit(self, "playerParry")
	if player.direction:
		transitioned.emit(self, "playerWalking")
	if player.canAttack == false:
		transitioned.emit(self,"playerAttack")
