extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_rotation = Vector3.ZERO
	var children := get_children()
	for i in children.size():
		var child := children[i]
		child.scale = Vector3.ONE
		child.position = Vector3.DOWN * i
