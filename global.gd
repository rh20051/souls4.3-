extends Node
var newItem = []
var increment = 0 # the increment checks for a new item being picked up without having to edit the item's properties
var oldIncrement = 0
var damage = 1
var inventoryDisplays = {"longsword":["res://sword.png", "weapon"], "grass":["res://icon.svg", "consumable"], "bomb":["res://icon.svg", "consumable"], "flamberge":["res://icon.svg", "weapon"],
							"parryingdagger":["res://sword.png", "leftHandWeapon"]}
var weapons = {"longsword": [preload("res://weapons/longsword.tscn"), "Hello lol"], "flamberge": [preload("res://weapons/flamberge.tscn"), "Yurp"]}
var leftHandWeapons = {"shield": [preload("res://shield.tscn"), "Common shield for blocking and parrying blades."], "lamp": [preload("res://misc/lamp.tscn"), "Lamp used to illuminate the dark."]}
var consumables = {"grass":[preload("res://worldAssets/grass.tscn"), "consume"], "bomb":[0,50, "throw"]}
var stackables = ["ammo", "healing"]
var armorSets = [["flutedChest", "flutedGauntlets", "flutedLegs", "flutedHead"], ["nakedChest", "nakedGauntlets", "nakedLegs", "nakedHead"]]

# Called when the node enters the scene tree for the first time.

func _process(delta):
	pass
