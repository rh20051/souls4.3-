extends CharacterBody3D

const SENSITIVITY =.0007
var SPEED = 5.0
var input_dir
const JUMP_VELOCITY = 4
const roll_distance = 130
const roll_speed = 3.0
var life = 30
var interactable
var recoverableLife = 0
var rallyEnded = false
var canMove = false
var canInteract = false
var item
var newItem
var stamina = 100
var rolling = false
var lockedOn = false
var blocking = false
var itemSelected = null
var canAttack = true
var canPickUp = false
var currentWeapon = null
var currentParryWeapon
var direction
var lockedEnemy
var canClimb = false
var climbing = false
var ladder = null
var running = false
@onready var camera = $cameraPoint
@onready var armature = $Armature/Skeleton3D
@onready var animTree = $AnimationTree
@onready var inv = $inventoryScreen/inventoryManager/inventory
@onready var armorDisplay = $inventoryScreen/inventoryManager/inventory/equipment/armorEquipped
@onready var wep = $Armature/Skeleton3D/weaponHolder
@onready var leftwep = $Armature/Skeleton3D/parryWeaponHolder
@onready var bottomPoint = $pickupArea/CollisionShape3D/Node3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var inventory = {"mushroom":1, "herb":2}
var equippedArmor = {"chest": "flutedChest", "hands": "flutedGauntlets", "legs": "flutedLegs", "head": "flutedHead"}
var armorCatagories = ["chest", "hands", "legs", "head"]
var weaponInventory = ["longsword", "shield", "flamberge", "lamp"]
var acquiredArmor = [["flutedChest", "flutedGauntlets", "flutedHead", "flutedLegs"], ["nakedChest", "nakedGauntlets", "nakedHead", "nakedLegs"]]
func _input(event):
	if event is InputEventMouseMotion and !lockedOn:
		camera.rotation.y += (-event.relative.x * SENSITIVITY)
		camera.rotation.x +=(event.relative.y * SENSITIVITY * 1.4)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))

func _process(delta):
	if Input.is_action_pressed("camStickDown"):
		camera.rotation.x -=(40 * SENSITIVITY * 1.4)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	if Input.is_action_pressed("camStickUp"):
		camera.rotation.x +=(40 * SENSITIVITY * 1.4)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	if Input.is_action_pressed("camJoystickLeft"):
		camera.rotation.y +=(40 * SENSITIVITY * 1.4)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	if Input.is_action_pressed("camStickRight"):
		camera.rotation.y -=(40 * SENSITIVITY * 1.4)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
		
		
		
func _ready():
	
	$inventoryScreen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if rallyEnded == true and recoverableLife > life:
		recoverableLife -= .1
		if recoverableLife == life:
			rallyEnded = false

		
	if Input.is_action_just_pressed("lockOn"):
		if !lockedOn:
			lockon()
	
		else:
			camera.look_at(lockedEnemy.get_node("lockonPoint").global_position)
			lockedEnemy.get_node("healthDisplay").visible = false
			lockedEnemy.get_node("lockonPoint").get_node("Sprite3D").visible = false			
			lockedEnemy = null
			lockedOn = false
	
	if lockedEnemy != null:
		#switch lockon targets
		if Input.is_action_just_pressed("lockswitchright"):
			var enemies = $lockOnArea.get_overlapping_bodies()
			lockedEnemy.get_node("lockonPoint").get_node("Sprite3D").visible = false #hides lockon icon on all enemies except new target
			for i in enemies:
				if i != lockedEnemy and i.is_in_group("enemy"):
					lockedEnemy = i
					break
		camera.look_at(lockedEnemy.get_node("lockonPoint").global_position)
		
		lockedEnemy.get_node("healthDisplay").visible = true
		lockedEnemy.get_node("lockonPoint").get_node("Sprite3D").visible = true
	
	if !rolling and stamina <100:
		stamina +=.2
	$lifeTexture/life.value = life
	$rallyTexture/rally.value = recoverableLife
	$staminaTexture/stamina.value = stamina
	# Add the gravity.
	if not is_on_floor() and climbing != true:
		animTree["parameters/conditions/falling"] = true
		animTree["parameters/conditions/onGround"] = false
		velocity.y -= gravity * delta
	else:
		animTree["parameters/conditions/onGround"] = true
		animTree["parameters/conditions/falling"] = false
	if canClimb == true:
		$interact.show()
		if Input.is_action_just_pressed("interact"):
			climbing = true
			canClimb = false
	if climbing:
		if ladder != null:
			$Armature.look_at(ladder.get_node("CollisionShape3D").get_node("MeshInstance3D").global_position, Vector3.UP)
			global_position.x = ladder.get_node("CollisionShape3D").get_node("playerPos").global_position.x
			global_position.z = ladder.get_node("CollisionShape3D").get_node("playerPos").global_position.z
			$Armature.rotation.x = 0
			$Armature.rotation.z = 0

			if ladder.get_node("CollisionShape3D").get_node("Node3D").global_position.y < bottomPoint.global_position.y:
				climbing = false
			if ladder.get_node("CollisionShape3D").get_node("Node3D2").global_position.y > bottomPoint.global_position.y and input_dir.y > .5:
				climbing = false
	if canPickUp == true:
		$interact.show()
		if Input.is_action_just_pressed("interact"):
			newItem.pickUp()
			canPickUp = false
			item = newItem.name
			newItem = null
			$HeadsUp.lastAction = "pickup"
			$HeadsUp.headsUp(item)
			$interact.hide()
	if canInteract == true:
		if Input.is_action_just_pressed("interact") and inv.invOpen == false and interactable:
			interactable.get_parent().interacted()
			interactable = null
			

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if inv.invOpen != true:
		if camera.position.y != 2.78:
				camera.position.y = lerp(camera.position.y, 2.78, delta*2)
	if armorDisplay.visible == true:
			if camera.position.y != 1.4:
				camera.position.y = lerp(camera.position.y, 1.4, delta*2)
			if camera.position.z !=  3 * camera.basis.z.x:
				camera.position.z = lerp(camera.position.z, 3 * camera.basis.z.x, delta*2)
			if camera.position.x !=  3 * camera.basis.z.z:
				camera.position.x = lerp(camera.position.x, 3 * -camera.basis.z.z, delta*2)
		

	input_dir = Input.get_vector("left", "right", "forward", "back")

	direction = (camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	
	if running:
		
		if Input.is_action_pressed("run") and direction != Vector3():
			running = true
		else:
			running = false

	
	if is_on_floor():
		if Input.is_action_just_pressed("attack") and canAttack == true and wep.get_child_count() > 0 and wep.get_child(0).name != "none":
			canAttack = false
		if Input.is_action_just_pressed("parry") and canAttack == true and leftwep.get_child_count() >0 and leftwep.get_child(0).name != "none":
			blocking = true
		if Input.is_action_just_pressed("roll") and stamina > 0 and inv.invOpen == false:
			rolling = true
		if Input.is_action_pressed("run") and canAttack == true and inv.invOpen == false:
			running = true
			
		if direction:
			
			if !lockedEnemy and canAttack and !rolling:
				$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(-direction.x, -direction.z), delta * 7)
			
				#$Armature.look_at(global_position+direction)
			elif !canAttack and !rolling:
				$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(-direction.x, -direction.z), delta *3)
			elif lockedEnemy:
				$Armature.look_at(lockedEnemy.global_position, Vector3.UP)
			$Armature.rotation.z = 0
			$Armature.rotation.x = 0	


	move_and_slide()
func lockon():
	var a = $lockOnArea.get_overlapping_bodies()
	for i in a:
		if i.is_in_group("enemy"):
			lockedOn = true
			lockedEnemy = i 
			break


func hurted(dmg):
	recoverableLife = life
	life -= dmg

	$rallyTimer.start(2)		


func attackStart():
	currentWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = false
	
func attackEnd():
	currentWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = true
	currentWeapon.lastEnemy = null
func parryStart():
	currentParryWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = false
	
func parryEnd():
	currentParryWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = true




func consume(item):
	if item.is_in_group("healingItem"):
		life += item.restoredLife







func _on_pickup_area_area_entered(area):
	if area.is_in_group("pickup"):
		newItem = area
		canPickUp = true
	if area.is_in_group("ladder"):
		ladder = area
		canClimb = true
	if area.is_in_group("interact"):
		canInteract = true
		interactable = area


func _on_rally_timer_timeout():
	rallyEnded = true


func _on_pickup_area_area_exited(area: Area3D) -> void:
	if area == ladder:
		canClimb = false
	if area.is_in_group("interact"):
		canInteract = false
		interactable = null
