extends Node3D

@export var rotation_speed := 2
@export var position_factor := 500.0
@export var position_amplitude := 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y += rotation_speed * delta
	position.y = position_amplitude * sin(Time.get_ticks_msec() / position_factor)
