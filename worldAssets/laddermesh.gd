
extends MultiMeshInstance3D
@export var ladderLength: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.multimesh.instance_count = ladderLength
	for y in range(self.multimesh.instance_count):
		self.multimesh.set_instance_transform(y, Transform3D(Basis(Vector3(0,0,1),Vector3(0,.2,0),Vector3(-1,0,0)), Vector3(0,y*.1, 0)))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
