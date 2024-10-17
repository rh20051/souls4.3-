extends weapon
class_name longsword
var damage = 20
var lastEnemy
var recoverScale = .3
@onready var player = get_tree().get_first_node_in_group("player")
func _physics_process(delta):
	
	var enemies = $hitbox.get_overlapping_areas()
	for i in enemies:
		if i.is_in_group("enemyhurtbox") and i.get_tree().get_first_node_in_group("enemy") != lastEnemy:
			i.get_tree().get_first_node_in_group("enemy").hurted(damage)
			if player.life < 100 and player.recoverableLife > player.life:
				player.life += (player.recoverableLife - player.life) * recoverScale
				player.recoverableLife -= (player.recoverableLife - player.life) * recoverScale
			lastEnemy = i.get_tree().get_first_node_in_group("enemy")
		
