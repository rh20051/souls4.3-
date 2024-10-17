extends enemy
class_name mage
var parryable = false
var parriedState = false
var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var anim = $anim
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	attacking = false
	health = 80
func parried():
	parriedState = true

func _physics_process(delta):

	$Armature.rotation.x = 0	
	$Armature.rotation.z = 0
	
	velocity.y -= gravity * delta 
	if attacking == true and anim.current_animation != "slash2" and anim.current_animation != "slash3" and anim.current_animation != "runningstab":
		velocity = Vector3(0,0,0)
		
	move_and_slide()
	
func hurted(damage):
	health -= damage
	if health <= 0:
		self.queue_free()
	$SubViewport/healthBar.value = health
