extends Node
var itemSelected = null
@onready var inv = get_parent().get_node("inventory")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var weaponInv = get_node("weaponInventory")
@onready var invArmor = get_node("inventoryArmor")
@onready var itemDisplayPoint = get_parent().get_node("itemDisplay/SubViewportContainer/SubViewport/itemPoint")
@onready var itemDisplay = get_parent().get_node("itemDisplay")
@onready var weaponDisplay = get_node("weaponsEquipped")
@onready var armorDisplay = get_node("armorEquipped")
@onready var weaponInventory = get_node("weaponInventory")
@onready var equipButtons = get_parent().get_parent().get_node("VBoxContainer")
@onready var equip = get_parent().get_parent().get_node("VBoxContainer/equip")
@onready var use = get_parent().get_parent().get_node("VBoxContainer/use")
@onready var unequip = get_parent().get_parent().get_node("VBoxContainer/unequip")

func _ready() -> void:
	updateArmorDisplay()
	
func _on_weapon_inventory_item_activated(index: int) -> void:
	itemSelected = weaponInv.get_selected_items()[0]
	itemSelected = weaponInv.get_item_text(itemSelected)
	get_parent().get_parent().get_node("VBoxContainer").show()
	
	get_parent().get_parent().get_node("VBoxContainer").grab_focus()
	if itemSelected not in Global.leftHandWeapons:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.weapons[itemSelected][1])
		equip.disabled = false
		use.disabled = true
	else:
		itemDisplayPoint.addSelectedItem(itemSelected)
		itemDisplay.get_node("itemName").text = str(itemSelected)
		itemDisplay.get_node("itemDesc").text = str(Global.leftHandWeapons[itemSelected][1])
		equip.disabled = false
		use.disabled = true
		
func updateArmorDisplay():
	weaponDisplay.clear()
	weaponInv.clear()
	for i in player.weaponInventory:
		weaponInv.add_item(i)
	if player.currentWeapon:
		weaponDisplay.add_item(player.currentWeapon.name)
		
	if player.currentParryWeapon:
		weaponDisplay.add_item(player.currentParryWeapon.name)
	armorDisplay.clear()
	for i in player.equippedArmor.values():
		armorDisplay.add_item(i)
		
func _on_inventory_armor_item_activated(index):
	equipButtons.show()
	itemSelected = invArmor.get_selected_items()[0]
	itemSelected = invArmor.get_item_text(itemSelected)
	
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
	if player.wep.get_child_count() >0 and itemSelected in Global.weapons:
		for i in player.wep.get_children():
			player.wep.remove_child(i)
	if player.leftwep.get_child_count() > 0 and itemSelected in Global.leftHandWeapons:
		for i in player.leftwep.get_children():
			player.leftwep.remove_child(i)
	if Global.weapons.has(itemSelected):
		player.wep.add_child(Global.weapons[itemSelected][0].instantiate())
		
		for i in player.wep.get_children():
			player.currentWeapon = i
			updateArmorDisplay()
	if Global.leftHandWeapons.has(itemSelected):
		if player.currentWeapon:
			if player.currentWeapon.name == "flamberge":
				pass
		else:
			player.leftwep.add_child(Global.leftHandWeapons[itemSelected][0].instantiate())
				
			for i in player.leftwep.get_children():
				player.currentParryWeapon = i
				updateArmorDisplay()
	armorDisplay.hide()
	invArmor.hide()
	weaponDisplay.hide()
	equipButtons.hide()
	itemDisplay.hide()
	get_parent().hide()
	weaponInv.hide()
	
	
	
func _on_use_pressed():
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
	elif invArmor.visible == true:
		pass
