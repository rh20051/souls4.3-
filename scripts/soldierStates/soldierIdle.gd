extends State
class_name soldierIdle
@export var enemy: CharacterBody3D
@export var animTree: AnimationTree


func _ready():
	animTree["parameters/conditions/idle"] = true
	
func physics_update(_delta: float):
	enemy.rotation.y = lerp_angle(enemy.rotation.y, enemy.angle + deg_to_rad(180), _delta * 3)


	if enemy.damaged == true:
		transitioned.emit(self, "soldierDamaged")
	
	enemy.velocity = Vector3()
	
	if enemy.direction.length() > 2:
		
		if angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) < .3 and angle_difference(enemy.rotation.y, enemy.angle +deg_to_rad(180)) >= -.3:
			transitioned.emit(self, "soldierChase")
