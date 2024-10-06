extends CharacterBody3D

const SENSITIVITY =.0007
var SPEED = 5.0
var input_dir
const JUMP_VELOCITY = 4.5
const roll_distance = 130
const roll_speed = 3.0
var life = 30
var recoverableLife = 0
var rallyEnded = false
var lastAction
var inventoryCycle = 0
var canMove = false
var item
var invItemSelected = 0
var newItem
var stamina = 100
var buttonSelected = 0
var rolling = false
var invOpen = false
var lockedOn = false
var parrying = false
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
@onready var weaponInv = $inventoryScreen/inventoryManager/weaponInventory
@onready var camera = $cameraPoint
@onready var armature = $Armature/Skeleton3D
@onready var animTree = $AnimationTree
@onready var inv = $inventoryScreen/inventoryManager/inventory
@onready var invArmor = $inventoryScreen/inventoryManager/inventoryArmor
@onready var weaponDisplay = $inventoryScreen/inventoryManager/weaponsEquipped
@onready var armorDisplay = $inventoryScreen/inventoryManager/armorEquipped
@onready var itemDisplay = $inventoryScreen/inventoryManager/itemDisplay
@onready var itemDisplayPoint = $inventoryScreen/inventoryManager/itemDisplay/SubViewportContainer/SubViewport/itemPoint
@onready var wep = $Armature/Skeleton3D/weaponHolder
@onready var leftwep = $Armature/Skeleton3D/parryWeaponHolder
@onready var bottomPoint = $pickupArea/CollisionShape3D/Node3D
@onready var equip = $inventoryScreen/VBoxContainer/equip
@onready var unequip = $inventoryScreen/VBoxContainer/unequip
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var inventory = ["grass"]
var equippedArmor = {"chest": "flutedChest", "hands": "flutedGauntlets", "legs": "flutedLegs", "head": "flutedHead"}
var armorCatagories = ["chest", "hands", "legs", "head"]
var weaponInventory = ["longsword", "parryingdagger", "flamberge", "lamp"]
var acquiredArmor = [["flutedChest", "flutedGauntlets", "flutedHead", "flutedLegs"], ["nakedChest", "nakedGauntlets", "nakedHead", "nakedLegs"]]
func _input(event):
	if event is InputEventMouseMotion and !lockedOn:
		$cameraPoint.rotation.y += (-event.relative.x * SENSITIVITY)
		$cameraPoint.rotation.x +=(event.relative.y * SENSITIVITY * 1.4)
		$cameraPoint.rotation.x = clamp($cameraPoint.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))

func _process(delta):
	if Input.is_action_pressed("camStickDown"):
		$cameraPoint.rotation.x -=(40 * SENSITIVITY * 1.4)
		$cameraPoint.rotation.x = clamp($cameraPoint.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	if Input.is_action_pressed("camStickUp"):
		$cameraPoint.rotation.x +=(40 * SENSITIVITY * 1.4)
		$cameraPoint.rotation.x = clamp($cameraPoint.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	if Input.is_action_pressed("camJoystickLeft"):
		$cameraPoint.rotation.y +=(40 * SENSITIVITY * 1.4)
		$cameraPoint.rotation.x = clamp($cameraPoint.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	if Input.is_action_pressed("camStickRight"):
		$cameraPoint.rotation.y -=(40 * SENSITIVITY * 1.4)
		$cameraPoint.rotation.x = clamp($cameraPoint.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
	$cameraPoint.rotation.x = clamp($cameraPoint.rotation.x, deg_to_rad(-90.0), deg_to_rad(70.0))
		
		
		
func _ready():
	updateArmorDisplay()
	checkInventory()
	$inventoryScreen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if rallyEnded == true and recoverableLife > life:
		recoverableLife -= .1
		if recoverableLife == life:
			rallyEnded = false
	if Global.increment != Global.oldIncrement:
		inventory.append(Global.newItem[0])
		checkInventory()
		Global.oldIncrement = 0
		Global.increment = 0
		
	if Input.is_action_just_pressed("lockOn"):
		if !lockedOn:
			lockon()
	
		else:
			$cameraPoint.look_at(lockedEnemy.get_node("lockonPoint").global_position)
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
		$cameraPoint.look_at(lockedEnemy.get_node("lockonPoint").global_position)
		
		lockedEnemy.get_node("healthDisplay").visible = true
		lockedEnemy.get_node("lockonPoint").get_node("Sprite3D").visible = true
	
	if !rolling and stamina <100:
		stamina +=.2
	$lifeTexture/life.value = life
	$rallyTexture/rally.value = recoverableLife
	$staminaTexture/stamina.value = stamina
	# Add the gravity.
	if not is_on_floor() and climbing != true:
		velocity.y -= gravity * delta
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
			lastAction = "pickup"
			headsUp(item)
			$interact.hide()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("openInventory"):
		if invOpen == false:
			inventoryCycle = 0
			inv.show()
			invArmor.hide()
			armorDisplay.hide()
			invOpen = true
			invItemSelected = 0
			$inventoryScreen.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			invArmor.release_focus()
			inv.grab_focus() #inventory takes input priority
			inv.select(invItemSelected) #automatically select first item
			
		else:
			invOpen = false
			itemDisplay.hide()
			$inventoryScreen/VBoxContainer.visible = false
	if invOpen != true:
		if camera.position.y != 2.78:
				camera.position.y = lerp(camera.position.y, 2.78, delta*2)
	if invOpen == true:
		$lifeTexture/life.hide()
		$staminaTexture/stamina.hide()
		if invArmor.visible == true:
			if camera.position.y != 1.4:
				camera.position.y = lerp(camera.position.y, 1.4, delta*2)
			if camera.position.z !=  3 * camera.basis.z.x:
				camera.position.z = lerp(camera.position.z, 3 * camera.basis.z.x, delta*2)
			if camera.position.x !=  3 * camera.basis.z.z:
				camera.position.x = lerp(camera.position.x, 3 * -camera.basis.z.z, delta*2)
		if Input.is_action_just_pressed("interact"): #interacting with item in inventory to open equip,unequip etc
			if inv.has_focus(): 
				_on_inventory_item_activated(invItemSelected)
		if Input.is_action_just_pressed("heavyAttack"):
			inventoryCycle += 1
			if inventoryCycle == 3:
				inventoryCycle = 0
			if inventoryCycle == 1:
					inv.hide()
					invArmor.show()
					armorDisplay.show()
					inv.deselect_all()
					weaponInv.hide()
					invArmor.grab_focus()
			elif inventoryCycle == 0:
					inv.show()
					invArmor.hide()
					weaponDisplay.hide()
					armorDisplay.hide()
					weaponInv.hide()
					inv.grab_focus()
			elif inventoryCycle == 2:
				inv.hide()
				invArmor.hide()
				armorDisplay.hide()
				weaponInv.show()
				weaponDisplay.show()
				weaponInv.grab_focus()
		if Input.is_action_just_pressed("menuRight"):
			if inv.has_focus():
				if invItemSelected < len(inventory) -1:	
					invItemSelected += 1
				inv.select(invItemSelected) #change currently selected inventory item
			elif !invArmor.has_focus():
				$inventoryScreen/VBoxContainer.get_child(buttonSelected +1).grab_focus() #if an inventory item is not selected,(but inventory is open) presume its equip/unequip selected and change between them
		if Input.is_action_just_pressed("menuLeft"):
			if invItemSelected > 0:
				invItemSelected -= 1
			inv.select(invItemSelected)#same but left

	else:
		$lifeTexture/life.show()
		$staminaTexture/stamina.show()
		$inventoryScreen.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		

	input_dir = Input.get_vector("left", "right", "forward", "back")

	direction = ($cameraPoint.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	
	if running:
		
		if Input.is_action_pressed("run") and direction != Vector3():
			running = true
		else:
			running = false

	
	if is_on_floor():
		if Input.is_action_just_pressed("attack") and canAttack == true and wep.get_child_count() > 0:
			canAttack = false
		if Input.is_action_just_pressed("parry") and canAttack == true and leftwep.get_child_count() >0:
			parrying = true
		if Input.is_action_just_pressed("roll") and stamina > 0 and invOpen == false:
			rolling = true
		if Input.is_action_pressed("run") and canAttack == true and invOpen == false:
			running = true
			
		if direction:
			
			if !lockedEnemy and canAttack and !rolling:
				$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(-direction.x, -direction.z), delta * 7)
			
				#$Armature.look_at(global_position+direction)
			elif !canAttack and !rolling:
				$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(-direction.x, -direction.z), delta )
			elif lockedEnemy and !rolling:
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
			
func changeInventory():
		inventory.append(Global.newItem)

func hurted(dmg):
	recoverableLife = life
	life -= dmg

	$rallyTimer.start(2)		
func checkInventory():
	var addArmor = true
	var armorInventoryLength = len(acquiredArmor) * 4

	for i in range(len(acquiredArmor)):
		for a in acquiredArmor[i]:
				for g in armorInventoryLength:
					if a in invArmor.get_item_text(g):
						addArmor = false
						
				if addArmor == true:
					invArmor.add_item(a)
					addArmor = true
	for i in range(len(inventory)):
	
		if inventory[i] in Global.inventoryDisplays:
			if inventory[i] in inv.get_item_text(i):
				pass
			else:
				
				var image = Image.load_from_file(Global.inventoryDisplays[inventory[i]][0])
				var texture = ImageTexture.create_from_image(image)
				inv.add_item(str(inventory[i]), texture, true)
			

func attackStart():
	currentWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = false
	
func attackEnd():
	currentWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = true
	currentWeapon.lastEnemy = null
func parryStart():
	currentParryWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = false
	
func parryEnd():
	currentParryWeapon.get_node("hitbox").get_node("CollisionShape3D").disabled = true
func updateArmorDisplay():
	weaponDisplay.clear()
	weaponInv.clear()
	for i in weaponInventory:
		weaponInv.add_item(i)
	if currentWeapon:
		weaponDisplay.add_item(currentWeapon.name)
		
	if currentParryWeapon:
		weaponDisplay.add_item(currentParryWeapon.name)
	armorDisplay.clear()
	for i in equippedArmor.values():
		armorDisplay.add_item(i)
func headsUp(item):
	$HeadsUp.show()
	if lastAction == "pickup":
		$HeadsUp.text = "picked up "+ str(item)
	await get_tree().create_timer(2).timeout
	$HeadsUp.hide()

func _on_inventory_item_clicked(index, at_position, mouse_button_index):
	if inv.has_focus():
		itemSelected = inv.get_selected_items()[0]
		itemSelected = inv.get_item_text(itemSelected)

func consume(item):
	if item.is_in_group("healingItem"):
		life += item.restoredLife


func _on_inventory_item_activated(index):
	itemDisplay.show()
	$inventoryScreen/VBoxContainer.show()
	itemSelected = inv.get_selected_items()[0]
	
	itemSelected = inv.get_item_text(itemSelected)
	
	if itemSelected not in Global.weapons and itemSelected not in Global.leftHandWeapons:

		equip.disabled = true
		unequip.disabled = true
	elif itemSelected not in Global.consumables and itemSelected not in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.weapons[itemSelected][1])
		equip.disabled = false
		$inventoryScreen/VBoxContainer/use.disabled = true
	elif itemSelected in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.leftHandWeapons[itemSelected][1])
		equip.disabled = false
		$inventoryScreen/VBoxContainer/use.disabled = true
	else:
		$inventoryScreen/VBoxContainer/use.disabled = false


func _on_equip_pressed():

	for i in Global.armorSets:
		for a in range(len(i)):
			if itemSelected == i[a]:
				var armorType = equippedArmor.values()[a]
				armature.get_node(itemSelected).show()
				if !itemSelected in armorType:
					armature.get_node(armorType).hide()
				equippedArmor[armorCatagories[a]] = itemSelected
				updateArmorDisplay()
				break
	if wep.get_child_count() >0 and itemSelected in Global.weapons:
		for i in wep.get_children():
			wep.remove_child(i)
	if leftwep.get_child_count() > 0 and itemSelected in Global.leftHandWeapons:
		for i in leftwep.get_children():
			leftwep.remove_child(i)
	if Global.weapons.has(itemSelected):
		wep.add_child(Global.weapons[itemSelected][0].instantiate())
		
		for i in wep.get_children():
			currentWeapon = i
			updateArmorDisplay()
	if Global.leftHandWeapons.has(itemSelected):
		if currentWeapon:
			if currentWeapon.name == "flamberge":
				pass
		else:
			leftwep.add_child(Global.leftHandWeapons[itemSelected][0].instantiate())
				
			for i in leftwep.get_children():
				currentParryWeapon = i
				updateArmorDisplay()
	armorDisplay.hide()
	weaponDisplay.hide()
	$inventoryScreen/VBoxContainer.hide()
	itemDisplay.hide()
	$inventoryScreen.hide()
	weaponInv.hide()
	
	invOpen = false

func _on_pickup_area_area_entered(area):
	if area.is_in_group("pickup"):
		newItem = area
		canPickUp = true
	if area.is_in_group("ladder"):
		ladder = area
		canClimb = true


func _on_unequip_pressed():
	if inv.visible == true:
		if wep.get_child_count() >0:
			for i in wep.get_children():
				wep.remove_child(i)
	elif invArmor.visible == true:
		pass


func _on_use_pressed():
	var item = Global.consumables[itemSelected][0].instantiate()
	leftwep.add_child(item)
	consume(item)


func _on_inventory_armor_item_activated(index):
	$inventoryScreen/VBoxContainer.show()
	itemSelected = invArmor.get_selected_items()[0]
	itemSelected = invArmor.get_item_text(itemSelected)



func _on_rally_timer_timeout():
	rallyEnded = true


func _on_pickup_area_area_exited(area: Area3D) -> void:
	if area == ladder:
		canClimb = false


func _on_weapon_inventory_item_activated(index: int) -> void:
	itemSelected = weaponInv.get_selected_items()[0]
	itemSelected = weaponInv.get_item_text(itemSelected)
	$inventoryScreen/VBoxContainer.show()
	
	$inventoryScreen/VBoxContainer.grab_focus()
	if itemSelected not in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.weapons[itemSelected][1])
		equip.disabled = false
		$inventoryScreen/VBoxContainer/use.disabled = true
	else:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.leftHandWeapons[itemSelected][1])
		equip.disabled = false
		$inventoryScreen/VBoxContainer/use.disabled = true
