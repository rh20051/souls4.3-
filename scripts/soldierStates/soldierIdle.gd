extends State
class_name soldierIdle
@export var enemy: CharacterBody3D
var animPlayer


func _ready():
	if enemy.type == "S":
		animPlayer = enemy.get_node("SAnimationPlayer")
	else:
		animPlayer= enemy.get_node("SNSAnimationPlayer")
	animPlayer.play("default")
	
func physics_update(_delta: float):
	enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), _delta * 3)


	if enemy.damaged == true:
		transitioned.emit(self, "soldierDamaged")
	
	enemy.velocity = Vector3()
	
	if enemy.direction.length() > 2:
		
		if angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .3 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.3:
			transitioned.emit(self, "soldierChase")
