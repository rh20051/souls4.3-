extends CharacterBody3D
var life = 100
var player
var target
const SPEED = 5.0
var direction 
var damaged = false
var angle
@export var type: String
func _ready() -> void:
	if type == "S":
		$Armature/Skeleton3D/BoneAttachment3D/sword.visible = false
		$Armature/Skeleton3D/BoneAttachment3D9/shield.visible = false
	elif type == "SNS":
		$Armature/Skeleton3D/BoneAttachment3D/spear.visible = false
		$Armature/Skeleton3D/BoneAttachment3D/sword.visible = true
		$Armature/Skeleton3D/BoneAttachment3D9/shield.visible = true
		
	player = get_tree().get_first_node_in_group("player")
	target = player.global_position
	
func _physics_process(delta: float) -> void:
	if life <= 0:
		queue_free()
	target = player.global_position
	direction = (target - global_position)
	angle = atan2(direction.x,direction.z)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	move_and_slide()
func hurted(damage):
	life -= damage
	damaged = true
	
	
