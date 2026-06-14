extends Node

@export var body:RigidBody3D
@export var emitter:Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emitter.set("direction", body.linear_velocity + Vector3.DOWN * 3)
