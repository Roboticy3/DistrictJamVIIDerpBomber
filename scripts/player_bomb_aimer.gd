extends Node

@export var body:RigidBody3D
@export var emitter:Node3D
@export var launch_mult := 0.75

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var global_d := body.linear_velocity
	var angular_global_d := Vector3.ZERO
	if body.angular_velocity.length() > 0:
		var a := body.angular_velocity.normalized()
		angular_global_d = (emitter.global_position - body.global_position).rotated(a, 1.0) * body.angular_velocity.length()
	var d := emitter.global_basis.inverse() * (global_d + angular_global_d) * launch_mult
	emitter.set("direction", d)
	emitter.set("speed", body.linear_velocity.length())
