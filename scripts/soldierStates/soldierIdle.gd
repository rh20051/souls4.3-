extends State
class_name soldierIdle
@export var enemy: CharacterBody3D
@export var animPlayer : AnimationPlayer


func _ready():
	animPlayer.play("default")
	
func physics_update(_delta: float):
	if enemy.damaged == true:
		transitioned.emit(self, "soldierDamaged")
	
	enemy.velocity = Vector3()
	print(enemy.direction.length())
	if enemy.direction.length() > 2:
		transitioned.emit(self, "soldierChase")
