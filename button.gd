extends Button
var focus = true
var stylebox
# Called when the node enters the scene tree for the first time.
func _ready():
	stylebox = get_theme_stylebox("normal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if focus == true:
		if get_parent().visible:
			grab_focus()
			focus = false
	if get_parent().visible == false:
		focus = true
