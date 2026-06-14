extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y += 2 * delta
	position.y = 2 * sin(Time.get_ticks_msec() / 500.0)
