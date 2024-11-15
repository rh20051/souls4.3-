extends Area3D
var item 
var type 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pickUp():
	Global.increment += 1
	Global.newItem = [str(self.name)]
	if Global.consumables.has(str(self.name)): #if the item is in the database of consumable items
		
		type = "consumable"
		item = str(self.name)
		Global.newItem = [item,type]
		Global.increment += 1
	elif Global.weapons.has(str(self.name)): #if the item is in the database of weapon items
		type = "weapon"
		item = str(self.name)
		Global.newItem = [item,type]
		Global.increment += 1
	self.queue_free()
