extends Node

@export var body:RigidBody3D

func _physics_process(delta: float) -> void:
	body.look_at(body.linear_velocity)
