extends CharacterBody3D
class_name enemy
var health
var speed
var attacking
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	pass
	
func _physics_process(delta):
	pass

func hurted(damage):
	health -= damage
