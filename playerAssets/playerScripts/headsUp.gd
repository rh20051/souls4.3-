extends Label
var lastAction


func headsUp(item):
	self.show()
	if lastAction == "pickup":
		self.text = "picked up "+ str(item)
	await get_tree().create_timer(2).timeout
	self.hide()
