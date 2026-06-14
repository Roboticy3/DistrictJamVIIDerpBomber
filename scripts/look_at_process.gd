extends Node3D

@export var targets:Array[Node3D]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var avg := Vector3.ZERO
	for t in targets:
		avg += t.global_position
	
	if targets.size() > 0:
		look_at(avg)
