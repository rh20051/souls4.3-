#the equip buttons functions are handled here for better optimisation. i dont really know if its working better or if this was the right decision but
#its done now. sorry future me if this ends up just being inconvenient.
extends Node2D
@onready var inv = $inventory
@onready var equipment = $inventory/equipment
@onready var player = get_parent().get_parent()
@onready var craftingCombo1 = $crafting/craftingInventory/combo1
@onready var craftingCombo2 = $crafting/craftingInventory/combo2
@onready var craftingResult = $crafting/craftingInventory/resultText
@onready var armorDisplay = $inventory/equipment/armorEquipped
@onready var invHead = $inventory/equipment/armorEquipped/headArmor
@onready var invChest = $inventory/equipment/armorEquipped/chestArmor
@onready var invLegs = $inventory/equipment/armorEquipped/legsArmor
@onready var invArms = $inventory/equipment/armorEquipped/armsArmor
@onready var weaponDisplay = $inventory/equipment/weaponsEquipped
@onready var equipButtons = $inventory/equipment/VBoxContainer
@onready var itemDisplay = $itemDisplay
@onready var equip = $inventory/equipment/VBoxContainer/equip
@onready var unequip = $inventory/equipment/VBoxContainer/unequip
@onready var rWepInv = $inventory/equipment/weaponsEquipped/mainWeaponInventory
@onready var lWepInv = $inventory/equipment/weaponsEquipped/leftHandWeaponInventory
var craftItemSelected = null
var craftingItem1
var craftingItem2
# Called when the node enters the scene tree for the first time.
var removeList = ["1","2","3","4","5","6","7","8","9"," "]
func cleanString(str):
	for i in str:
		for a in removeList:
			if i == a:
				str = str.replace(i,"")
				
	return str
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	
func _on_unequip_pressed():
	if unequip.text != "combo":
		inv.invOpen = false
		if inv.visible == true:
			if player.wep.get_child_count() >0:
				for i in player.wep.get_children():
					player.wep.remove_child(i)
		elif armorDisplay.visible == true:
			pass
	else:
		for i in Global.craftingRecipes:
			for a in range(2):
				if Global.craftingRecipes[i][a] == craftingItem1:
					for b in range(2):
						if Global.craftingRecipes[i][b] == craftingItem2:
							for c in player.inventory.keys():
								if c == i:
									player.inventory[c] +=1
								else:
									player.inventory[i] = 1
							craftingResult.text = "crafted " + i
							
							inv.checkInventory()
func _on_use_pressed():
	inv.itemSelected = inv.get_selected_items()[0]
	inv.itemSelected = inv.get_item_text(inv.itemSelected)
	inv.invOpen = false
	var item = Global.consumables[inv.itemSelected][0].instantiate()
	player.leftwep.add_child(item)
	player.consume(item)

func _on_equip_pressed():
	if equip.text != "add":
		inv.invOpen = false
		for i in Global.armorSets:
			for a in range(len(i)):
				if equipment.itemSelected == i[a]:
					var armorType = player.equippedArmor.values()[a]
					player.armature.get_node(equipment.itemSelected).show()
					if !equipment.itemSelected in armorType:
						player.armature.get_node(armorType).hide()
					player.equippedArmor[player.armorCatagories[a]] = equipment.itemSelected
					equipment.updateArmorDisplay()
					break
		if equipment.itemSelected in Global.weapons:
			for i in player.wep.get_children():
				player.wep.remove_child(i)
		if equipment.itemSelected in Global.leftHandWeapons:
			for i in player.leftwep.get_children():
				player.leftwep.remove_child(i)
		if Global.weapons.has(equipment.itemSelected):
			player.wep.add_child(Global.weapons[equipment.itemSelected][0].instantiate())

			
			for i in player.wep.get_children():
				player.currentWeapon = i
				equipment.updateArmorDisplay()
		if Global.leftHandWeapons.has(equipment.itemSelected):
			if player.currentWeapon.name == "flamberge":
					pass
			else:
				player.leftwep.add_child(Global.leftHandWeapons[equipment.itemSelected][0].instantiate())
					
				for i in player.leftwep.get_children():
					player.currentParryWeapon = i
					equipment.updateArmorDisplay()
		armorDisplay.hide()
		invHead.hide()
		invChest.hide()
		invLegs.hide()
		invArms.hide()
		weaponDisplay.hide()
		equipButtons.hide()
		itemDisplay.hide()
		rWepInv.hide()
		lWepInv.hide()
	elif craftingCombo1.itemHeld == false:
		craftingCombo1.itemInserted(cleanString(craftItemSelected))
		craftingItem1 = cleanString(craftItemSelected)
	else:
		craftingCombo2.itemInserted(cleanString(craftItemSelected))
		craftingItem2 = cleanString(craftItemSelected)


func _on_crafting_send(item) -> void:
	craftItemSelected = item
	print(craftItemSelected)
