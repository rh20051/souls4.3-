extends Node
@onready var craftInv = get_node("craftingInventory")
@onready var combo1 = get_node("craftingInventory/combo1")
@onready var combo2 = get_node("craftingInventory/combo2")
@onready var comboButtons = get_parent().get_node("VBoxContainer")


func _process(delta: float) -> void:
	pass


func onCraftInvItemActivated(index: int) -> void:
	comboButtons.show()
