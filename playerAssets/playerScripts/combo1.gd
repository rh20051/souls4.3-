extends TextureRect
var itemHeld = false

func itemInserted(item):
	var image =Image.load_from_file(Global.inventoryDisplays[item][0])
	image = ImageTexture.create_from_image(image)
	self.texture = image
	itemHeld = true
