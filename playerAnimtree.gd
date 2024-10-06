extends AnimationTree
@export var player: CharacterBody3D
@onready var animTree = get_parent().get_node("AnimationTree")
@onready var stateMachine = get_parent().get_node("stateMachine")
@onready var idle = get_parent().get_node("stateMachine/playerIdle")
@onready var walk = get_parent().get_node("stateMachine/playerWalking")
@onready var attack = get_parent().get_node("stateMachine/playerAttack")
@onready var parry = get_parent().get_node("stateMachine/playerParry")
# Called when the node enters the scene tree for the first time.

func _physics_process(delta: float) -> void:
	if player.currentParryWeapon:
		if player.currentParryWeapon.name == "lamp":
			
			animTree["parameters/conditions/holdingLamp"] = true
	if player.lockedOn:
		if player.input_dir.x < -.2:
			animTree["parameters/conditions/movingLeft"] = true
			animTree["parameters/StateMachine/conditions/movingLeft"] = true
			animTree["parameters/conditions/movingRight"] = false
			animTree["parameters/StateMachine/conditions/movingRight"] = false
			animTree["parameters/conditions/movingBack"] = false
			animTree["parameters/StateMachine/conditions/movingBack"] = false
		elif player.input_dir.x > 0.2:
			animTree["parameters/conditions/movingLeft"] = false
			animTree["parameters/StateMachine/conditions/movingLeft"] = false
			animTree["parameters/conditions/movingRight"] = true
			animTree["parameters/StateMachine/conditions/movingRight"] = true
			animTree["parameters/conditions/movingBack"] = false
			animTree["parameters/StateMachine/conditions/movingBack"] = false
		elif player.input_dir.y < 0:
			animTree["parameters/conditions/movingLeft"] = false
			animTree["parameters/StateMachine/conditions/movingLeft"] = false
			animTree["parameters/conditions/movingRight"] = false
			animTree["parameters/StateMachine/conditions/movingRight"]= false
			animTree["parameters/conditions/movingBack"] = false
			animTree["parameters/StateMachine/conditions/movingBack"] = false
		else:
			animTree["parameters/conditions/movingLeft"] = false
			animTree["parameters/StateMachine/conditions/movingLeft"] = false
			animTree["parameters/conditions/movingRight"] = false
			animTree["parameters/StateMachine/conditions/movingRight"] = false
			animTree["parameters/conditions/movingBack"] = true
			animTree["parameters/StateMachine/conditions/movingBack"] = true
			
	else:
		animTree["parameters/conditions/movingLeft"] = false
		animTree["parameters/StateMachine/conditions/movingLeft"] = false
		animTree["parameters/conditions/movingRight"] = false
		animTree["parameters/StateMachine/conditions/movingRight"] = false
		animTree["parameters/conditions/movingBack"] = false
		animTree["parameters/StateMachine/conditions/movingBack"] = false
	if stateMachine.current_state.name == "playerIdle":
		animTree["parameters/StateMachine/conditions/running"] = false
		animTree["parameters/StateMachine/conditions/walking"] = false
		animTree["parameters/StateMachine/conditions/dodging"] = false
		animTree["parameters/StateMachine/conditions/idle"] = true
		animTree["parameters/StateMachine/conditions/moving"] = false
		animTree["parameters/conditions/parrying"] = false
		animTree["parameters/conditions/attack"] = false
		animTree["parameters/StateMachine/conditions/attacking"] = false
		animTree["parameters/StateMachine/conditions/chain"] = false
		animTree["parameters/conditions/chain"] = false
		animTree["parameters/conditions/moving"] = false
		animTree["parameters/conditions/idle"] = true
		animTree["parameters/conditions/running"] = false
		if player.currentWeapon:
			if player.currentWeapon.name == "flamberge":
				animTree["parameters/conditions/holdingFlamberge"] = true
				animTree["parameters/conditions/notHoldingFlamberge"] = false
			else:
				animTree["parameters/conditions/holdingFlamberge"] = false
				animTree["parameters/conditions/notHoldingFlamberge"] = true
	if stateMachine.current_state.name == "playerAttack":
		animTree["parameters/StateMachine/conditions/moving"] = false
		animTree["parameters/StateMachine/conditions/idle"] = false
		animTree["parameters/conditions/moving"] = false
		animTree["parameters/conditions/idle"] = false
		animTree["parameters/conditions/running"] = false
	if stateMachine.current_state.name == "playerWalking":
		animTree["parameters/StateMachine/conditions/idle"] = false
		animTree["parameters/conditions/parrying"] = false
		animTree["parameters/conditions/attack"] = false
		animTree["parameters/StateMachine/conditions/attacking"] = false
		animTree["parameters/conditions/chain"] = false
		animTree["parameters/StateMachine/conditions/moving"] = true
		animTree["parameters/conditions/moving"] = true
		animTree["parameters/conditions/idle"] = false
		if player.currentWeapon:
			if player.currentWeapon.name == "flamberge":
				animTree["parameters/conditions/holdingFlamberge"] = true
				animTree["parameters/conditions/notHoldingFlamberge"] = false
			else:
				animTree["parameters/conditions/holdingFlamberge"] = false
				animTree["parameters/conditions/notHoldingFlamberge"] = true
	if stateMachine.current_state.name == "playerParry":
		animTree["parameters/conditions/parrying"] = true
		animTree["parameters/conditions/running"] = false
		animTree["parameters/conditions/moving"] = false
