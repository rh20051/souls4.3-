extends ItemList
@onready var player = get_parent().get_parent().get_parent()
@onready var invHead = $equipment/armorEquipped/headArmor
@onready var invChest = $equipment/armorEquipped/chestArmor
@onready var invArms = $equipment/armorEquipped/armsArmor
@onready var invLegs = $equipment/armorEquipped/legsArmor
@onready var armorDisplay = $equipment/armorEquipped
@onready var itemDisplay = get_parent().get_node("itemDisplay")
@onready var craftingInventory = get_parent().get_node("crafting/craftingInventory")
@onready var inventoryScreen = get_parent().get_parent()
@onready var equipButtons = $equipment/VBoxContainer
@onready var rWepInv = $equipment/weaponsEquipped/mainWeaponInventory
@onready var lWepInv = $equipment/weaponsEquipped/leftHandWeaponInventory
@onready var weaponDisplay = $equipment/weaponsEquipped
@onready var equip = $equipment/VBoxContainer/equip
@onready var unequip = $equipment/VBoxContainer/unequip
@onready var use = $equipment/VBoxContainer/use
@onready var amountLabel = preload("res://playerAssets/inventoryLabel.tscn")
@onready var itemDisplayPoint = get_parent().get_parent().get_node("inventoryManager/itemDisplay/SubViewportContainer/SubViewport/itemPoint") 
var itemSelected = null
var invOpen = false
var invItemSelected
var craftItemSelected
var inventoryCycle = 0
var invLength
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invLength = len(player.inventory)
	checkInventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("openInventory"):
		openInventory()
	if invOpen == true:
		player.get_node("lifeTexture").get_node("life").hide()
		player.get_node("staminaTexture").get_node("stamina").hide()
		if Input.is_action_just_pressed("interact"): #interacting with item in inventory to open equip,unequip etc
			if self.has_focus(): 
				_on_item_activated(invItemSelected)
		if Input.is_action_just_pressed("roll"):
			if equipButtons.visible == true:
				equipButtons.visible = false
				if self.visible == true:
					self.grab_focus()
				elif craftingInventory.visible == true:
					craftingInventory.grab_focus()
		if Input.is_action_just_pressed("heavyAttack"):
			equip.text = "EQUIP"
			unequip.text = "UNEQUIP"
			use.text = "USE"
			inventoryCycle += 1
			if inventoryCycle == 4:
				inventoryCycle = 0
			if inventoryCycle == 1:
					self.hide()
					craftingInventory.hide()
					armorDisplay.show()
					use.disabled = true
					equip.disabled = false
					unequip.disabled = false
					self.deselect_all()
					rWepInv.hide()
					lWepInv.hide()
					armorDisplay.grab_focus()
			elif inventoryCycle == 0:
					
					self.show()
					weaponDisplay.hide()
					craftingInventory.hide()
					use.disabled = false
					equip.disabled = true
					unequip.disabled = true
					armorDisplay.hide()
					rWepInv.hide()
					lWepInv.hide()
					self.grab_focus()
			elif inventoryCycle == 2:
				self.hide()
				armorDisplay.hide()
				craftingInventory.hide()
				weaponDisplay.show()
				use.disabled = true
				equip.disabled = false
				unequip.disabled = false
				weaponDisplay.grab_focus()
			elif inventoryCycle == 3:
				self.hide()
				armorDisplay.hide()
				weaponDisplay.hide()
				craftingInventory.show()
				craftingInventory.grab_focus()
				craftItemSelected = 0
				craftingInventory.select(craftItemSelected)
				equip.text = "add"
				unequip.text = "combo"
				use.text = "remove"
				use.disabled = false
				equip.disabled = false
				unequip.disabled = false
		if Input.is_action_just_pressed("menuRight"):
			if self.has_focus():
				if invItemSelected < len(player.inventory) -1:	
					invItemSelected += 1
				self.select(invItemSelected) #change currently selected inventory item
			elif craftingInventory.has_focus():
				if craftItemSelected < craftingInventory.get_item_count() -1:
					craftItemSelected += 1
				craftingInventory.select(craftItemSelected)
				
			elif !armorDisplay.has_focus():
				equipButtons.get_child(1).grab_focus() #if an inventory item is not selected,(but inventory is open) presume its equip/unequip selected and change between them
		if Input.is_action_just_pressed("menuLeft"):
			if invItemSelected > 0:
				invItemSelected -= 1
			self.select(invItemSelected)#same but left


	else:
		player.get_node("lifeTexture").get_node("life").show()
		player.get_node("staminaTexture").get_node("stamina").show()
		inventoryScreen.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Global.increment != Global.oldIncrement:
		
		if Global.newItem[0][0] not in player.inventory.keys():
			for i in player.inventory.keys():
				if i == Global.newItem[0]:
					player.inventory[i] +=1
		checkInventory()
		Global.oldIncrement = 0
		Global.increment = 0
func openInventory():
	if invOpen == false:
		equip.text = "EQUIP"
		unequip.text = "UNEQUIP"
		use.text = "USE"
		equip.disabled = false
		unequip.disabled = false
		use.disabled = false
		inventoryCycle = 0
		self.show()
		armorDisplay.hide()
		invOpen = true
		invItemSelected = 0
		inventoryScreen.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		armorDisplay.release_focus()
		self.grab_focus() #inventory takes input priority
		self.select(invItemSelected) #automatically select first item
			
	else:
		invOpen = false
		itemDisplay.hide()
		armorDisplay.hide()
		invHead.hide()
		invChest.hide()
		invLegs.hide()
		invArms.hide()
		weaponDisplay.hide()
		rWepInv.hide()
		lWepInv.hide()
		craftingInventory.hide()
		self.hide()
		equipButtons.visible = false

func _on_item_clicked(index, at_position, mouse_button_index):
	if self.has_focus():
		itemSelected = self.get_selected_items()[0]
		itemSelected = self.get_item_text(itemSelected)
		
func _on_item_activated(index):
	itemDisplay.show()
	equipButtons.show()
	itemSelected = get_selected_items()[0]
	
	itemSelected = get_item_text(itemSelected)
	
	if itemSelected not in Global.weapons and itemSelected not in Global.leftHandWeapons:

		equip.disabled = true
		unequip.disabled = true
	elif itemSelected not in Global.consumables and itemSelected not in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.weapons[itemSelected][1])
		equip.disabled = false
		use.disabled = true
	elif itemSelected in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.leftHandWeapons[itemSelected][1])
		equip.disabled = false
		use.disabled = true
	else:
		use.disabled = false
func checkInventory():
	invLength = len(player.inventory)
	rearrangeQuantityLabels(invLength)
	var addArmor = true
	var row = -1
	var armorInventoryLength = len(player.acquiredArmor) * 4

	for i in range(len(player.acquiredArmor)):
		for a in player.acquiredArmor[i]:
				for g in armorInventoryLength:
					if a in invHead.get_item_text(g) or a in invChest.get_item_text(g) or a in invArms.get_item_text(g):
						addArmor = false
						
				if addArmor == true:
					if "Head" in a:
						invHead.add_item(a)
					elif "Chest" in a:
						invChest.add_item(a)
					elif "Gauntlets" in a:
						invArms.add_item(a)
					else:	
						invLegs.add_item(a)
					addArmor = true
	#self.clear()
	#craftingInventory.clear()
	var itemNotAdded
	for i in player.inventory.keys():
		itemNotAdded = true
		if i in Global.inventoryDisplays:
			for a in range(0, item_count):
				if self.get_item_text(a) == i:
					itemNotAdded = false
					
					self.get_node(i).text = str(player.inventory[i])
					
	
		if itemNotAdded == true:
					
			var image = Image.load_from_file(Global.inventoryDisplays[i][0])
			var texture = ImageTexture.create_from_image(image)
			var lastidx = add_item(str(i), texture, true)
			var amount = amountLabel.instantiate()
			self.add_child(amount)
			var col = lastidx
			amount.text = str(player.inventory[i])
			row = lastidx / 5
			col = (lastidx % 5) +1
			amount.global_position = Vector2(131 + (310* (col)), 70 +(65 * (row)))
			amount.name = str(i)
				
			if i in Global.craftingMaterials:
				craftingInventory.add_item(str(i), texture, true)
			
func rearrangeQuantityLabels(length):
	var idx
	for i in self.get_item_count():
		var item = self.get_item_text(i)
		idx = i
		for a in self.get_children():
			if a.name == item:
				var row = idx /5
				var col = (idx % 5) + 1
				a.global_position = Vector2(131 + (310* (col)), 70 +(65 * (row)))
