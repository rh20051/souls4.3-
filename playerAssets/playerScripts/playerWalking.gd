extends State
class_name playerWalking
@export var player: CharacterBody3D
@export var animTree : AnimationTree

@onready var cam = player.get_node("cameraPoint")
func enter():
	animTree["parameters/conditions/running"] = false
	player.SPEED = 3
func physics_update(delta: float):

	if cam.position.x != -1 * player.direction.x:
		cam.position.x = lerp(cam.position.x, -1*player.direction.x, delta*2)
	if cam.position.x != -1 * player.direction.z:
		cam.position.z = lerp(cam.position.z, -1*player.direction.z, delta*2)

	if player.climbing:
		transitioned.emit(self,"playerClimbing")
	if !player.canAttack:
		transitioned.emit(self,"playerAttack")
	if player.blocking == true:
		transitioned.emit(self, "playerBlock")
	if player.rolling and player.stamina > 0:
		transitioned.emit(self,"playerRolling")
	if player.running and !player.lockedOn and !player.rolling :
		player.SPEED = 6
		animTree["parameters/conditions/walking"] = false
		animTree["parameters/conditions/running"] = true
		animTree["parameters/StateMachine/conditions/running"] = true
		animTree["parameters/StateMachine/conditions/walking"] = false
		
	elif player.canAttack and player.direction and !player.rolling:
		animTree["parameters/conditions/running"] = false
		animTree["parameters/StateMachine/conditions/running"] = false
		animTree["parameters/StateMachine/conditions/walking"] = true
		animTree["parameters/conditions/walking"] = true
		player.SPEED = 3.5
	elif !player.lockedOn:
		transitioned.emit(self,"playerIdle")


	
	player.velocity.x = player.direction.x * player.SPEED
	player.velocity.z = player.direction.z * player.SPEED
