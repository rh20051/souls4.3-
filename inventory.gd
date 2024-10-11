extends ItemList
@onready var player = get_parent().get_parent().get_parent()
@onready var invArmor = get_parent().get_node("equipment/inventoryArmor")
@onready var armorDisplay = get_parent().get_node("equipment/armorEquipped")
@onready var itemDisplay = get_parent().get_node("itemDisplay")
@onready var inventoryScreen = get_parent().get_parent()
@onready var equipButtons = get_parent().get_parent().get_node("VBoxContainer")
@onready var weaponInv = get_parent().get_node("equipment/weaponInventory")
@onready var weaponDisplay = get_parent().get_node("equipment/weaponsEquipped")
@onready var equip = get_parent().get_parent().get_node("VBoxContainer").get_node("equip")
@onready var unequip = get_parent().get_parent().get_node("VBoxContainer").get_node("unequip")
@onready var use = get_parent().get_parent().get_node("VBoxContainer").get_node("use")
@onready var itemDisplayPoint = get_parent().get_parent().get_node("inventoryManager/itemDisplay/SubViewportContainer/SubViewport/itemPoint") 
var itemSelected = null
var invOpen = false
var invItemSelected
var inventoryCycle = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		if Input.is_action_just_pressed("heavyAttack"):
			inventoryCycle += 1
			if inventoryCycle == 3:
				inventoryCycle = 0
			if inventoryCycle == 1:
					self.hide()
					invArmor.show()
					armorDisplay.show()
					self.deselect_all()
					weaponInv.hide()
					invArmor.grab_focus()
			elif inventoryCycle == 0:
					self.show()
					invArmor.hide()
					weaponDisplay.hide()
					armorDisplay.hide()
					weaponInv.hide()
					self.grab_focus()
			elif inventoryCycle == 2:
				self.hide()
				invArmor.hide()
				armorDisplay.hide()
				weaponInv.show()
				weaponDisplay.show()
				weaponInv.grab_focus()
		if Input.is_action_just_pressed("menuRight"):
			if self.has_focus():
				if invItemSelected < len(player.inventory) -1:	
					invItemSelected += 1
				self.select(invItemSelected) #change currently selected inventory item
			elif !invArmor.has_focus():
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
		player.inventory.append(Global.newItem[0])
		checkInventory()
		Global.oldIncrement = 0
		Global.increment = 0
func openInventory():
	if invOpen == false:
		inventoryCycle = 0
		self.show()
		invArmor.hide()
		armorDisplay.hide()
		invOpen = true
		invItemSelected = 0
		inventoryScreen.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		invArmor.release_focus()
		self.grab_focus() #inventory takes input priority
		self.select(invItemSelected) #automatically select first item
			
	else:
		invOpen = false
		itemDisplay.hide()
		invArmor.hide()
		armorDisplay.hide()
		weaponDisplay.hide()
		weaponInv.hide()
		inventoryScreen.get_node("VBoxContainer").visible = false

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
	var addArmor = true
	var armorInventoryLength = len(player.acquiredArmor) * 4

	for i in range(len(player.acquiredArmor)):
		for a in player.acquiredArmor[i]:
				for g in armorInventoryLength:
					if a in invArmor.get_item_text(g):
						addArmor = false
						
				if addArmor == true:
					invArmor.add_item(a)
					addArmor = true
	for i in range(len(player.inventory)):
	
		if player.inventory[i] in Global.inventoryDisplays:
			if player.inventory[i] in get_item_text(i):
				pass
			else:
				
				var image = Image.load_from_file(Global.inventoryDisplays[player.inventory[i]][0])
				var texture = ImageTexture.create_from_image(image)
				add_item(str(player.inventory[i]), texture, true)
			
