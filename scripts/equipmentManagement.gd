extends Node
var itemSelected = null
@onready var inv = get_parent().get_node("inventory")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var invHead = get_node("armorEquipped/headArmor")
@onready var invChest = get_node("armorEquipped/chestArmor")
@onready var invArms = get_node("armorEquipped/armsArmor")
@onready var invLegs = get_node("armorEquipped/legsArmor")
@onready var itemDisplayPoint = get_parent().get_node("itemDisplay/SubViewportContainer/SubViewport/itemPoint")
@onready var itemDisplay = get_parent().get_node("itemDisplay")
@onready var weaponDisplay = get_node("weaponsEquipped")
@onready var armorDisplay = get_node("armorEquipped")
@onready var rWepInv = get_node("weaponsEquipped/mainWeaponInventory")
@onready var lWepInv = get_node("weaponsEquipped/leftHandWeaponInventory")
@onready var equipButtons = get_parent().get_parent().get_node("VBoxContainer")
@onready var equip = get_parent().get_parent().get_node("VBoxContainer/equip")
@onready var use = get_parent().get_parent().get_node("VBoxContainer/use")
@onready var unequip = get_parent().get_parent().get_node("VBoxContainer/unequip")

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	updateArmorDisplay()
	
func _on_main_weapon_inventory_item_activated(index: int) -> void:
	itemSelected = rWepInv.get_selected_items()[0]
	itemSelected = rWepInv.get_item_text(itemSelected)
	get_parent().get_parent().get_node("VBoxContainer").show()
	
	get_parent().get_parent().get_node("VBoxContainer").grab_focus()
	if itemSelected not in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.weapons[itemSelected][1])
		equip.disabled = false
		use.disabled = true

func _on_left_hand_weapon_inventory_item_activated(index: int) -> void:
	itemSelected = lWepInv.get_selected_items()[0]
	itemSelected = lWepInv.get_item_text(itemSelected)
	itemDisplayPoint.addSelectedItem(itemSelected)
	get_parent().get_parent().get_node("VBoxContainer").show()
	get_parent().get_parent().get_node("VBoxContainer").grab_focus()
	itemDisplay.get_node("itemName").text = str(itemSelected)
	itemDisplay.get_node("itemDesc").text = str(Global.leftHandWeapons[itemSelected][1])
	equip.disabled = false
	use.disabled = true
func updateArmorDisplay():
	weaponDisplay.clear()
	rWepInv.clear()
	lWepInv.clear()
	for i in player.weaponInventory:
		if i in Global.weapons:
			rWepInv.add_item(i)
		elif i in Global.leftHandWeapons:
			lWepInv.add_item(i)
	for i in player.wep.get_children():
		player.currentWeapon = i
		weaponDisplay.add_item(player.currentWeapon.name)
		
	for i in player.leftwep.get_children():
		player.currentParryWeapon = i
		weaponDisplay.add_item(player.currentParryWeapon.name)
	armorDisplay.clear()
	for i in player.equippedArmor.values():
		armorDisplay.add_item(i)
		
func _on_head_armor_item_activated(index):
	equipButtons.show()
	itemSelected = invHead.get_selected_items()[0]
	itemSelected = invHead.get_item_text(itemSelected)
func _on_chest_armor_item_activated(index: int) -> void:
	equipButtons.show()
	itemSelected = invChest.get_selected_items()[0]
	itemSelected = invChest.get_item_text(itemSelected)
func _on_arms_armor_item_activated(index: int) -> void:
	equipButtons.show()
	itemSelected = invArms.get_selected_items()[0]
	itemSelected = invArms.get_item_text(itemSelected)
func _on_legs_armor_item_activated(index: int) -> void:
	equipButtons.show()
	itemSelected = invLegs.get_selected_items()[0]
	itemSelected = invLegs.get_item_text(itemSelected)
func _on_equip_pressed():
	inv.invOpen = false
	for i in Global.armorSets:
		for a in range(len(i)):
			if itemSelected == i[a]:
				var armorType = player.equippedArmor.values()[a]
				player.armature.get_node(itemSelected).show()
				if !itemSelected in armorType:
					player.armature.get_node(armorType).hide()
				player.equippedArmor[player.armorCatagories[a]] = itemSelected
				updateArmorDisplay()
				break
	if itemSelected in Global.weapons:
		for i in player.wep.get_children():
			player.wep.remove_child(i)
	if itemSelected in Global.leftHandWeapons:
		for i in player.leftwep.get_children():
			player.leftwep.remove_child(i)
	if Global.weapons.has(itemSelected):
		player.wep.add_child(Global.weapons[itemSelected][0].instantiate())
		
		for i in player.wep.get_children():
			player.currentWeapon = i
			updateArmorDisplay()
	if Global.leftHandWeapons.has(itemSelected):
		if player.currentWeapon.name == "flamberge":
				pass
		else:
			player.leftwep.add_child(Global.leftHandWeapons[itemSelected][0].instantiate())
				
			for i in player.leftwep.get_children():
				player.currentParryWeapon = i
				updateArmorDisplay()
	armorDisplay.hide()
	invHead.hide()
	invChest.hide()
	invLegs.hide()
	invArms.hide()
	get_node("armorEquipped").hide()
	weaponDisplay.hide()
	equipButtons.hide()
	itemDisplay.hide()
	rWepInv.hide()
	lWepInv.hide()
	
	
	
func _on_use_pressed():
	itemSelected = inv.get_selected_items()[0]
	itemSelected = inv.get_item_text(itemSelected)
	inv.invOpen = false
	var item = Global.consumables[itemSelected][0].instantiate()
	player.leftwep.add_child(item)
	player.consume(item)
	
func _on_unequip_pressed():
	inv.invOpen = false
	if inv.visible == true:
		if player.wep.get_child_count() >0:
			for i in player.wep.get_children():
				player.wep.remove_child(i)
	elif get_node("armorEquipped").visible == true:
		pass


func _on_armor_equipped_item_activated(index: int) -> void:
	if index == 0:
		invChest.visible = true
		invChest.grab_focus()
	elif index == 1:
		invArms.visible = true
		invArms.grab_focus()
	elif index == 2:
		invLegs.visible = true
		invLegs.grab_focus()
	else:
		invHead.visible = true
		invHead.grab_focus()
		


func _on_weapons_equipped_item_activated(index: int) -> void:
	if index == 0:
		rWepInv.visible = true
		rWepInv.grab_focus()
	elif index == 1:
		lWepInv.visible = true
		lWepInv.grab_focus()

		
