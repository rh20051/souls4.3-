extends Node
var newItem = []
var increment = 0 # the increment checks for a new item being picked up without having to edit the item's properties
var oldIncrement = 0
var damage = 1
var inventoryDisplays = {"longsword":["res://sword.png", "weapon"], "grass":["res://icon.svg", "consumable"], "bomb":["res://icon.svg", "consumable"], "flamberge":["res://icon.svg", "weapon"],
							"parryingdagger":["res://sword.png", "leftHandWeapon"], "herb":["res://icon.svg"],"mushroom":["res://icon.svg"], "potion": ["res://icons/potion.png"], "item1":["res://icon.svg"],
							"item2":["res://icon.svg"], "item3":["res://icon.svg"], "item4":["res://icon.svg"]}
var weapons = {"longsword": [preload("res://weapons/longsword.tscn"), "Hello lol"], "flamberge": [preload("res://weapons/flamberge.tscn"), "Yurp"]}
var leftHandWeapons = {"shield": [preload("res://playerAssets/texturesAndDependencies/shield.tscn"
), "Common shield for blocking and parrying blades."], "lamp": [preload("res://misc/lamp.tscn"), "Lamp used to illuminate the dark."]}
#heal, damage, type
var consumables = {"grass":[preload("res://worldAssets/grass.tscn"), "consume"], "bomb":[0,50, "throw"], "potion":[30,0,"consume"]}
var stackables = ["healing"]
var armorSets = [["flutedChest", "flutedGauntlets", "flutedLegs", "flutedHead"], ["nakedChest", "nakedGauntlets", "nakedLegs", "nakedHead"]]
var craftingMaterials = ["herb", "mushroom"]
var craftingRecipes = {"potion": ["herb", "mushroom"]}

# Called when the node enters the scene tree for the first time.

func _process(delta):
	pass
