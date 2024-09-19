extends Node3D
class_name HealingItem

var restoredLife 

func _ready() -> void:
	if self.name == "grass":
		restoredLife = 30
