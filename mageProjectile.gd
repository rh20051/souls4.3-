extends Area3D
@onready var player = get_tree().get_first_node_in_group("player")

var pos
const SPEED = 2
var velocity
var t = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pos = player.global_position
	look_at(Vector3(player.global_position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var check = self.get_overlapping_areas()
	for i in check:
		if i.is_in_group("playerHurtbox"):
			player.hurted(20)
			self.queue_free()
	t += 0.01
	global_position -= velocity * delta * SPEED
	if t >= 5:
		self.queue_free()
