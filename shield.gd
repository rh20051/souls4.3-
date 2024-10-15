extends weapon
class_name shield


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var enemies = $hitbox.get_overlapping_bodies()
	for i in enemies:
		if i.is_in_group("enemy"):
			pass
	
