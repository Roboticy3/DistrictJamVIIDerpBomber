extends Node3D

@export var max_distance := 7.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var c := get_viewport().get_camera_3d()
	if c is Camera3D:
		var distance := c.global_position.distance_to(global_position)
		visible = distance < max_distance
