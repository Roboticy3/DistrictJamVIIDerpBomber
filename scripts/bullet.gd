extends Node

@export var model:VisualInstance3D
@export var body:RigidBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!body.linear_velocity.is_zero_approx()):
		model.look_at(body.linear_velocity)
